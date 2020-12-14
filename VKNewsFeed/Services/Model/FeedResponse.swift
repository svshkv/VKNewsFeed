//
//  FeedResponse.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import Foundation

struct FeedResponseWrapper: Decodable {
	let response: FeedResponse
}

struct FeedResponse: Decodable {
	var items: [FeedItem]
}

struct FeedItem: Decodable {
	let sourceId: Int
	let postId: Int
	let text: String?
	let date: Double
	let comments: CountableItem?
	let likes: CountableItem?
	let reposts: CountableItem?
	let views: CountableItem?
}

struct CountableItem: Decodable {
	let count: Int
}
