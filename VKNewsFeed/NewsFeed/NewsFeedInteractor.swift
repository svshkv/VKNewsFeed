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
	
	func makeRequest(request: NewsFeed.Model.Request.RequestType) {
		if service == nil {
			service = NewsFeedService()
		}
	}
}
