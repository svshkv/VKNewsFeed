//
//  PhotosCollectionViewController.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 15.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import UIKit

final class PhotosCollectionView: UICollectionView
{
	private var photos: [FeedCellPhotoAttachementViewModel] = []
	
	init() {
		let layout = RowLayout()
		super.init(frame: .zero, collectionViewLayout: layout)
		
		delegate = self
		dataSource = self
		
		register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
		
		backgroundColor = .clear
		
		showsHorizontalScrollIndicator = false
		
		if let rowLayout = collectionViewLayout as? RowLayout {
            rowLayout.delegate = self
        }
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(photos: [FeedCellPhotoAttachementViewModel]) {
		self.photos = photos
		reloadData()
	}
}

//MARK: - UICollectionViewDelegate
extension PhotosCollectionView: UICollectionViewDelegate {
	
}

//MARK: - UICollectionViewDataSource
extension PhotosCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
		cell.configure(with: photos[indexPath.row].photoUrlString)
		return cell
	}
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: frame.width, height: frame.height)
	}
}

//MARK: - RowLayoutDelegate
extension PhotosCollectionView: RowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
}
