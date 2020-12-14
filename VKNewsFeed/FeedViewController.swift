//
//  FeedViewController.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 11.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController
{
	private let dataFetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataFetcher.getFeed { (feedResponse) in
			guard let feedResponse = feedResponse else { return }
			// do smth with reponse
		}
	}
}
