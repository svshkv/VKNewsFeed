//
//  UserResponse.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 15.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
