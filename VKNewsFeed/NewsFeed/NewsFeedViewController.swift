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
	var feedViewModel = FeedViewModel.init(cells: [])
	
	// MARK: View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		configureElements()
		
		interactor?.makeRequest(request: .getNewsFeed)
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
		tableView.register(NewsfeedCell.self, forCellReuseIdentifier: NewsfeedCell.reuseId)
	}
	
	func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
		switch viewModel {
		case .displayNewsFeed(let feedViewModel):
			self.feedViewModel = feedViewModel
			tableView.reloadData()
		}
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
		return feedViewModel.cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as? NewsfeedCell else { return UITableViewCell() }
		cell.set(viewModel: feedViewModel.cells[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let cellViewModel = feedViewModel.cells[indexPath.row]
		return cellViewModel.sizes.totalHeight
	}
}
