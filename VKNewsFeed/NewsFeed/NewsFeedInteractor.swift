//
//  NewsFeedInteractor.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright (c) 2020 Саша Руцман. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
	func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

final class NewsFeedInteractor: NewsFeedBusinessLogic
{
	var presenter: NewsFeedPresentationLogic?
	var service: NewsFeedService?
	var revealedPostIds = [Int]()
	var feedResponse: FeedResponse?
	var dataFetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
	
	func makeRequest(request: NewsFeed.Model.Request.RequestType) {
		if service == nil {
			service = NewsFeedService()
		}
		
		switch request {
		case .getNewsFeed:
			service?.getFeed(completion: { [weak self] (revealedPostIds, feed) in
				self?.presenter?.presentData(response: .presentNewsFeed(feed, revealedPostIds: revealedPostIds))
			})
		case .getUser:
			service?.getUser(completion: { [weak self] (user) in
				self?.presenter?.presentData(response: .presentUserInfo(user))
			})
		case .revealPost(let postId):
			service?.revealPostIds(forPostId: postId, completion: { [weak self] (revealedPostIds, feed) in
				self?.presenter?.presentData(response: .presentNewsFeed(feed, revealedPostIds: revealedPostIds))
			})
		case .getNextBatch:
			self.presenter?.presentData(response: .presentFooterLoader)
			service?.getNextBatch(completion: { (revealedPostIds, feed) in
				self.presenter?.presentData(response: .presentNewsFeed(feed, revealedPostIds: revealedPostIds))
			})
		}
	}
}
