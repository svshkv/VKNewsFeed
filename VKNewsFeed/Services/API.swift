//
//  API.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 12.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import Foundation

struct API {
	static let scheme = "https"
	static let host = "api.vk.com"
	static let version = "5.92"
	static let params = ["filters": "post, photo"]
	
	static let newsFeed = "/method/newsfeed.get"
	static let user = "/method/users.get"
}
