//
//  NewsFeedViewController.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 14.12.2020.
//  Copyright (c) 2020 Саша Руцман. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: class {
	func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

final class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic
{
	// MARK: UI Properties
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: Properties
	var interactor: NewsFeedBusinessLogic?
	var router: (NSObjectProtocol & NewsFeedRoutingLogic)?

	// MARK: View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		configureElements()
	}
	
	// MARK: Setup
	private func setup() {
		let viewController        = self
		let interactor            = NewsFeedInteractor()
		let presenter             = NewsFeedPresenter()
		let router                = NewsFeedRouter()
		viewController.interactor = interactor
		viewController.router     = router
		interactor.presenter      = presenter
		presenter.viewController  = viewController
		router.viewController     = viewController
	}
	
	private func configureElements() {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}
	
	func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
		
	}
}

// MARK: UITableViewDelegate
extension NewsFeedViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

// MARK: UITableViewDataSource
extension NewsFeedViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = "\(indexPath.row)"
		return cell
	}
}
