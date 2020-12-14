//
//  SceneDelegate.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 11.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import UIKit
import VK_ios_sdk

final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
	var window: UIWindow?
	var authService: AuthService!

	static func shared() -> SceneDelegate {
		let scene = UIApplication.shared.connectedScenes.first
		let sd: SceneDelegate = (((scene?.delegate as? SceneDelegate)!))
		return sd
	}
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		authService = AuthService()
		authService.delegate = self
		window?.rootViewController = UIStoryboard(name: "AuthViewController", bundle: nil).instantiateInitialViewController() as? AuthViewController
		window?.makeKeyAndVisible()
	}

	func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
		if let url = URLContexts.first?.url {
			VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
		}
	}
	
	func sceneDidDisconnect(_ scene: UIScene) {
		
	}

	func sceneDidBecomeActive(_ scene: UIScene) {

	}

	func sceneWillResignActive(_ scene: UIScene) {

	}

	func sceneWillEnterForeground(_ scene: UIScene) {

	}

	func sceneDidEnterBackground(_ scene: UIScene) {

	}
}

//MARK: - IAuthService
extension SceneDelegate: IAuthService
{
	func authServiceShouldPresent(vc: UIViewController) {
		window?.rootViewController?.present(vc, animated: true)
	}
	
	func authServiceSignIn() {
		let feedVC: NewsFeedViewController = NewsFeedViewController.loadFromStoryboard()
		let navVC = UINavigationController(rootViewController: feedVC ?? UIViewController())
		window?.rootViewController = navVC
	}
	
	func authServiceFailed() {
		
	}
}

