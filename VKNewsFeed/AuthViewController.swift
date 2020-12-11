//
//  AuthViewController.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 11.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController
{
	
	private var authService: AuthService!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		authService = SceneDelegate.shared().authService
	}
	
	@IBAction func signInButtonPressed(_ sender: Any) {
		authService.wakeupSession()
	}
}

