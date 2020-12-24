//
//  NewsfeedCodeCell.swift
//  VKNewsFeed
//
//  Created by Алексей Пархоменко on 31/03/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachements: [FeedCellPhotoAttachementViewModel] { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
	var moreTextButtonFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol FeedCellPhotoAttachementViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

protocol NewsfeedCellDelegate: class {
	func revealPost(for cell: NewsfeedCell)
}

final class NewsfeedCell: UITableViewCell {
    
    static let reuseId = "NewsfeedCell"
    
	weak var delegate: NewsfeedCellDelegate?
    // Первый слой
    
    let cardView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Второй слой
    
    let topView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postTextView: UITextView = {
       let textView = UITextView()
        textView.isScrollEnabled = false
		textView.isSelectable = true
		textView.isEditable = false
		textView.isUserInteractionEnabled = true
		textView.dataDetectorTypes = .all
        textView.font = Constants.postLabelFont
		let padding = textView.textContainer.lineFragmentPadding
		textView.textContainerInset = UIEdgeInsets.init(top: 0, left: -padding, bottom: 0, right: -padding)
        textView.textColor = #colorLiteral(red: 0.227329582, green: 0.2323184013, blue: 0.2370472848, alpha: 1)
        return textView
    }()
    
	let moreTextButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		button.setTitleColor(#colorLiteral(red: 0.4, green: 0.6235294118, blue: 0.831372549, alpha: 1), for: .normal)
		button.contentVerticalAlignment = .center
		button.contentHorizontalAlignment = .left
		button.setTitle("Показать больше...", for: .normal)
		return button
	}()
	
	let photosCollectionView = PhotosCollectionView()
	
    let postImageView: WebImageView = {
        let imageView = WebImageView()
		imageView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 10
		return imageView
    }()
    
    let bottomView: UIView = {
       let view = UIView()
        return view
    }()
    
    // Третий слой на topView
    
    let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.227329582, green: 0.2323184013, blue: 0.2370472848, alpha: 1)
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // Третий слой на bottomView
    
    let likesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sharesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Четвертый слой на bottomView
    
    let likesImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "like")
        return imageView
    }()
    
    let commentsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "comment")
        return imageView
    }()
    
    let sharesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "share")
        return imageView
    }()
    
    let viewsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "eye")
        return imageView
    }()
    
    let likesLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let sharesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
	override func prepareForReuse() {
		iconImageView.set(imageURL: nil)
		postImageView.set(imageURL: nil)
	}
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
		iconImageView.layer.cornerRadius = Constants.topViewHeight / 2
		iconImageView.clipsToBounds = true
		
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        overlayFirstLayer() // первый слой
        overlaySecondLayer() // второй слой
        overlayThirdLayerOnTopView() // третий слой на topView
        overlayThirdLayerOnBottomView() // третий слой на bottomView
        overlayFourthLayerOnBottomViewViews() // четвертый слой на bottomViewViews
		
		moreTextButton.addTarget(self, action: #selector(moreTextButtonPressed), for: .touchUpInside)
    }
	
    
    func set(viewModel: FeedCellViewModel) {
        
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postTextView.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        
        postTextView.frame = viewModel.sizes.postLabelFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame
		moreTextButton.frame = viewModel.sizes.moreTextButtonFrame
		
		if let photoAttachment = viewModel.photoAttachements.first, viewModel.photoAttachements.count == 1 {
			postImageView.set(imageURL: photoAttachment.photoUrlString)
			postImageView.isHidden = false
			postImageView.frame = viewModel.sizes.attachmentFrame
			photosCollectionView.isHidden = true
		}
		else if viewModel.photoAttachements.count > 1 {
			photosCollectionView.frame = viewModel.sizes.attachmentFrame
			postImageView.isHidden = true
			photosCollectionView.isHidden = false
			photosCollectionView.set(photos: viewModel.photoAttachements)
		}
		else {
			postImageView.isHidden = true
			photosCollectionView.isHidden = true
		}
    }
    
    private func overlayFourthLayerOnBottomViewViews() {
        likesView.addSubview(likesImage)
        likesView.addSubview(likesLabel)
        
        commentsView.addSubview(commentsImage)
        commentsView.addSubview(commentsLabel)
        
        sharesView.addSubview(sharesImage)
        sharesView.addSubview(sharesLabel)
        
        viewsView.addSubview(viewsImage)
        viewsView.addSubview(viewsLabel)
        
        helpInFourthLayer(view: likesView, imageView: likesImage, label: likesLabel)
        helpInFourthLayer(view: commentsView, imageView: commentsImage, label: commentsLabel)
        helpInFourthLayer(view: sharesView, imageView: sharesImage, label: sharesLabel)
        helpInFourthLayer(view: viewsView, imageView: viewsImage, label: viewsLabel)
    }
    
    private func helpInFourthLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        
        // imageView constraints
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.bottomViewViewsIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.bottomViewViewsIconSize).isActive = true
        
        // label constraints
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func overlayThirdLayerOnBottomView() {
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(sharesView)
        bottomView.addSubview(viewsView)
        
        // likesView constraints
        likesView.anchor(top: bottomView.topAnchor,
                         leading: bottomView.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewViewHeight))
        
        // commentsView constraints
        commentsView.anchor(top: bottomView.topAnchor,
                         leading: likesView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewViewHeight))
        
        // sharesView constraints
        sharesView.anchor(top: bottomView.topAnchor,
                            leading: commentsView.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewViewHeight))
        
        // viewsView constraints
        viewsView.anchor(top: bottomView.topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: bottomView.trailingAnchor,
                          size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewViewHeight))
    }
    
    private func overlayThirdLayerOnTopView() {
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        // iconImageView constraints
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
        
        // nameLabel constraints
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Constants.topViewHeight / 2 - 2).isActive = true
        
        // dateLabel constraints
        dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    private func overlaySecondLayer() {
        cardView.addSubview(topView)
        cardView.addSubview(postTextView)
		cardView.addSubview(moreTextButton)
        cardView.addSubview(postImageView)
		cardView.addSubview(photosCollectionView)
        cardView.addSubview(bottomView)
        
        // topView constraints
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8).isActive = true
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8).isActive = true
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true

        
        // postlabel constraints
        // не нужно, так как размеры задаются динамически
        
        // postImageView constraints
        // не нужно, так как размеры задаются динамически
        
        // bottomView constraints
        // не нужно, так как размеры задаются динамически
    }
    
     private func overlayFirstLayer() {
        addSubview(cardView)
        
        // cardView constraints
        cardView.fillSuperview(padding: Constants.cardInsets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	@objc
	private func moreTextButtonPressed() {
		delegate?.revealPost(for: self)
	}
}
