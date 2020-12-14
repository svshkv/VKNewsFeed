//
//  AuthService.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 11.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import UIKit
import VK_ios_sdk

protocol IAuthService: class {
	func authServiceShouldPresent(vc: UIViewController)
	func authServiceSignIn()
	func authServiceFailed()
}

class AuthService: NSObject
{
	weak var delegate: IAuthService?
	
	//MARK: - Properties
	private let appId = "7695758"
	private let vkSdk: VKSdk
	
	var token: String? {
		return VKSdk.accessToken()?.accessToken
	}
	
	//MARK: - Init
	override init() {
		vkSdk = VKSdk.initialize(withAppId: appId)
		super.init()
		vkSdk.register(self)
		vkSdk.uiDelegate = self
	}
	
	func wakeupSession() {
		let scope = ["wall", "friends"]
		VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
			if let error = error {
				fatalError(error.localizedDescription)
			}
			
			switch state {
			case .initialized:
				VKSdk.authorize(scope)
			case .authorized:
				delegate?.authServiceSignIn()
			default:
				delegate?.authServiceFailed()
			}
		}
	}
}

//MARK: - VKSdkDelegate
extension AuthService: VKSdkDelegate
{
	func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
		print(#function)
		if result.token != nil {
			delegate?.authServiceSignIn()
		}
	}
	
	func vkSdkUserAuthorizationFailed() {
		print(#function)
		delegate?.authServiceFailed()
	}
}

//MARK: - VKSdkUIDelegate
extension AuthService: VKSdkUIDelegate
{
	func vkSdkShouldPresent(_ controller: UIViewController!) {
		print(#function)
		delegate?.authServiceShouldPresent(vc: controller)
	}
	
	func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
		print(#function)
	}
}
