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
	private var titleView = TitleView()
	private var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return refreshControl
	}()
	private lazy var footerView = FooterView()
	
	// MARK: Properties
	var interactor: NewsFeedBusinessLogic?
	var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
	var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
	
	// MARK: View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		setupTopBars()
		setupTableView()
		
		interactor?.makeRequest(request: .getNewsFeed)
		interactor?.makeRequest(request: .getUser)
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
	
    private func setupTopBars() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
	
	private func setupTableView() {
		let topInset: CGFloat = 8
		tableView.contentInset.top = topInset
		tableView.register(NewsfeedCell.self, forCellReuseIdentifier: NewsfeedCell.reuseId)
		
		tableView.addSubview(refreshControl)
		tableView.tableFooterView = footerView
	}
	
	@objc
	private func refresh() {
		interactor?.makeRequest(request: .getNewsFeed)
	}
	
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextBatch)
        }
    }
	
	func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
		switch viewModel {
		case .displayNewsFeed(let feedViewModel):
			self.feedViewModel = feedViewModel
			tableView.reloadData()
			refreshControl.endRefreshing()
		case .displayUser(let userViewModel):
			titleView.set(userViewModel: userViewModel)
		case .displayFooterLoader:
			footerView.showLoader()
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
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let cellViewModel = feedViewModel.cells[indexPath.row]
		return cellViewModel.sizes.totalHeight
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		let cellViewModel = feedViewModel.cells[indexPath.row]
		return cellViewModel.sizes.totalHeight
	}
}

// MARK: NewsfeedCellDelegate
extension NewsFeedViewController: NewsfeedCellDelegate {
	
	func revealPost(for cell: NewsfeedCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		let cellViewModel = feedViewModel.cells[indexPath.row]
		interactor?.makeRequest(request: .revealPost(postId: cellViewModel.postId))
	}
}
