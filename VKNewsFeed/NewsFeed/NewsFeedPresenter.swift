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
		case .presentNewsFeed(let feed):
			let cells = feed.items.map { (feedItem) in
				cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
			}
			let feedViewModel = FeedViewModel(cells: cells)
			viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel))
		}
	}
	
	private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
		
		let profile = getProfile(for: feedItem.sourceId, profiles: profiles, groups: groups)
		let photoAttachment = self.getPhotoAttachment(feedItem: feedItem)
		let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachment: photoAttachment)
		
		return FeedViewModel.Cell(iconUrlString: profile?.photo ?? "",
								  name: profile?.name ?? "",
								  date: feedItem.date.dateToString(),
								  text: feedItem.text,
								  likes: String(feedItem.likes?.count ?? 0),
								  comments: String(feedItem.comments?.count ?? 0),
								  shares: String(feedItem.reposts?.count ?? 0),
								  views: String(feedItem.views?.count ?? 0),
								  photoAttachement: photoAttachment,
								  sizes: sizes)
	}
	
	private func getProfile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable? {
		let profilesOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profiles : groups
		let normalSourceId = sourseId >= 0 ? sourseId : -sourseId
		let profileRepresentable = profilesOrGroups.first { (profileRepresentable) in
			profileRepresentable.id == normalSourceId
		}
		return profileRepresentable
	}
	
    private func getPhotoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: firstPhoto.srcBIG,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }
}
