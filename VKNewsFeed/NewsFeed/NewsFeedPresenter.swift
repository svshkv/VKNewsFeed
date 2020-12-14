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
	
	func presentData(response: NewsFeed.Model.Response.ResponseType) {
		
	}
}
