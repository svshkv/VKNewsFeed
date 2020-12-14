//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import Foundation

protocol DataFetcher {
	func getFeed(response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFetcher {
	let networking: Networking
	
	init(networking: Networking) {
		self.networking = networking
	}
	
	private func decodeJson<T: Decodable>(type: T.Type, from data: Data?) -> T? {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		guard let data = data else { return nil }
		let response = try? decoder.decode(type.self, from: data)
		return response
	}
}

extension NetworkDataFetcher: DataFetcher {
	
	func getFeed(response: @escaping (FeedResponse?) -> Void) {
		networking.request(path: API.newsFeed, params: API.params) { (result) in
			switch result {
			case .success(let data):
				let decoded = self.decodeJson(type: FeedResponseWrapper.self, from: data)
				response(decoded?.response)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}
