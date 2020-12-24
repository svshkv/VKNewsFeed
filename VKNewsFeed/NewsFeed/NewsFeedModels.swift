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
				case revealPost(postId: Int)
				case getUser
				case getNextBatch
			}
		}
		
		struct Response {
			enum ResponseType {
				case presentNewsFeed(_ feed: FeedResponse, revealedPostIds: [Int])
				case presentUserInfo(_ user: UserResponse?)
				case presentFooterLoader
			}
		}
		
		struct ViewModel {
			enum ViewModelData {
				case displayNewsFeed(_ feedViewModel: FeedViewModel)
				case displayUser(_ userViewModel: UserViewModel)
				case displayFooterLoader
			}
		}
	}
}

struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?
}

struct FeedViewModel {
	let cells: [Cell]
	let footerTitle: String?
	
	struct Cell: FeedCellViewModel {
		var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachements: [FeedCellPhotoAttachementViewModel]
        var sizes: FeedCellSizes
    }
    
     struct FeedCellPhotoAttachment: FeedCellPhotoAttachementViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
}
