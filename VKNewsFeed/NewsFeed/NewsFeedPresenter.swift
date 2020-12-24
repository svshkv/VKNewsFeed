//
//  NewsFeedPresenter.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright (c) 2020 Саша Руцман. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
	func presentData(response: NewsFeed.Model.Response.ResponseType)
}

final class NewsFeedPresenter: NewsFeedPresentationLogic
{
	weak var viewController: NewsFeedDisplayLogic?
	
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()

	func presentData(response: NewsFeed.Model.Response.ResponseType) {
		switch response {
		case .presentNewsFeed(let feed, let revealPostIds):
			let cells = feed.items.map { (feedItem) in
				cellViewModel(from: feedItem,
							  profiles: feed.profiles,
							  groups: feed.groups,
							  revealPostIds: revealPostIds)
			}
			
			let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: ""), cells.count)
			let feedViewModel = FeedViewModel.init(cells: cells, footerTitle: footerTitle)
			
			viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayNewsFeed(feedViewModel))
		case .presentUserInfo(let userInfo):
			let userViewModel = UserViewModel(photoUrlString: userInfo?.photo100)
			viewController?.displayData(viewModel: .displayUser(userViewModel))
		case .presentFooterLoader:
			viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayFooterLoader)
		}
	}
	
	private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealPostIds: [Int]) -> FeedViewModel.Cell {
		
		let profile = getProfile(for: feedItem.sourceId, profiles: profiles, groups: groups)
		let photoAttachments = self.getPhotoAttachments(feedItem: feedItem)
		
		let isFullSized = revealPostIds.contains { (postId) -> Bool in
			return postId == feedItem.postId
		}
		
		let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSized: isFullSized)
		
		return FeedViewModel.Cell(postId: feedItem.postId,
								  iconUrlString: profile?.photo ?? "",
								  name: profile?.name ?? "",
								  date: feedItem.date.dateToString(),
								  text: feedItem.text,
								  likes: formattedCounter(feedItem.likes?.count ?? 0),
								  comments: formattedCounter(feedItem.comments?.count ?? 0),
								  shares: formattedCounter(feedItem.reposts?.count ?? 0),
								  views: formattedCounter(feedItem.views?.count ?? 0),
								  photoAttachements: photoAttachments,
								  sizes: sizes)
	}
	
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
	
	private func getProfile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable? {
		let profilesOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profiles : groups
		let normalSourceId = sourseId >= 0 ? sourseId : -sourseId
		let profileRepresentable = profilesOrGroups.first { (profileRepresentable) in
			profileRepresentable.id == normalSourceId
		}
		return profileRepresentable
	}
	
    private func getPhotoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
		guard let attachments = feedItem.attachments else { return [] }
		
		return attachments.compactMap { (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
			guard let photo = attachment.photo else { return nil }
			return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: photo.srcBIG,
														 width: photo.width,
														 height: photo.height)
		}
    }
}
