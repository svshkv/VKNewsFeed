//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import Foundation

protocol DataFetcher {
	func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
	func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher {
	private let authService: AuthService
	let networking: Networking
	
	init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
		self.networking = networking
		self.authService = authService
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
	func getUser(response: @escaping (UserResponse?) -> Void) {
		guard let userId = authService.userId else { return }
		let params = ["user_ids": userId, "fields": "photo_100"]
		networking.request(path: API.user, params: params) { (result) in
			switch result {
			case .success(let data):
				let decoded = self.decodeJson(type: UserResponseWrapped.self, from: data)
				response(decoded?.response.first)
			case .failure(let error):
				print(error.localizedDescription)
			}
        }
	}
	
	func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, params: params) { result in
			switch result {
			case .success(let data):
				let decoded = self.decodeJson(type: FeedResponseWrapper.self, from: data)
				response(decoded?.response)
			case .failure(let error):
				print("Error received requesting data: \(error.localizedDescription)")
				print(error.localizedDescription)
			}
        }
    }
}
