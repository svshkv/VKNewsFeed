//
//  NetworkService.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 12.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import Foundation

typealias RequestResponse = Result<Data?, Error>

protocol Networking {
	func request(path: String, params: [String: String], completion: @escaping (RequestResponse) -> Void)
}

final class NetworkService
{
	private let authService: AuthService
	
	init(authService: AuthService = SceneDelegate.shared().authService) {
		self.authService = authService
	}
	
	private func createUrl(from path: String, params: [String: String]) -> URL? {
		var components = URLComponents()
		components.scheme = API.scheme
		components.host = API.host
		components.path = path
		components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
		return components.url
	}
	
	private func createDataTask(from request: URLRequest, completion: @escaping (RequestResponse) -> Void) -> URLSessionDataTask {
		return URLSession.shared.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error {
					completion(.failure(error))
					return
				}
				completion(.success(data))
			}
		}
	}
}

extension NetworkService: Networking
{
	func request(path: String, params: [String : String], completion: @escaping (RequestResponse) -> Void) {
		guard let token = authService.token else { return }
		
		var allParams = params
		allParams["access_token"] = token
		allParams["v"] = API.version
		let urlOptional = createUrl(from: path, params: allParams)
		
		guard let url = urlOptional else { return }
		print("url: ", url)
		let request = URLRequest(url: url)
		let task = createDataTask(from: request, completion: completion)
		task.resume()
	}
}
