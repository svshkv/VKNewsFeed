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
	
	var dataFetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
	
	func makeRequest(request: NewsFeed.Model.Request.RequestType) {
		if service == nil {
			service = NewsFeedService()
		}
		
		switch request {
		case .getNewsFeed:
			dataFetcher.getFeed { [weak self] (feedResponse) in
				guard let feedResponse = feedResponse else { return }
				self?.presenter?.presentData(response: .presentNewsFeed(feedResponse))
			}
		}
	}
}
