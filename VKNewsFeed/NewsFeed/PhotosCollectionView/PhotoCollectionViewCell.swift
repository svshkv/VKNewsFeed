//
//  PhotoCollectionViewCell.swift
//  VKNewsFeed
//
//  Created by Саша Руцман on 15.12.2020.
//  Copyright © 2020 Саша Руцман. All rights reserved.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "PhotoCollectionViewCell"
	
	private let imageView: WebImageView = {
		let imageView = WebImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = .clear
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		
		backgroundColor = .clear
		
		addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.fillSuperview()
	}
	
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        self.layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
	
	override func prepareForReuse() {
		imageView.image = nil
	}
	
	func configure(with imageUrl: String?) {
		imageView.set(imageURL: imageUrl)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
