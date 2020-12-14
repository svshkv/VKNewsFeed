//
//  NewsFeedModels.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright (c) 2020 Саша Руцман. All rights reserved.
//

import UIKit

enum NewsFeed {
	enum Model {
		struct Request {
			enum RequestType {
				case getNewsFeed
			}
		}
		
		struct Response {
			enum ResponseType {
				case presentNewsFeed(_ feed: FeedResponse)
			}
		}
		
		struct ViewModel {
			enum ViewModelData {
				case displayNewsFeed(_ feedViewModel: FeedViewModel)
			}
		}
	}
}

struct FeedViewModel {
	let cells: [Cell]
	
	struct Cell: FeedCellViewModel {		
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachement: FeedCellPhotoAttachementViewModel?
        var sizes: FeedCellSizes
    }
    
     struct FeedCellPhotoAttachment: FeedCellPhotoAttachementViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
}
