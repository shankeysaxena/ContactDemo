//
//  ContactListingTableViewCell.swift
//  ContactDemo
//
//  Created by apple on 8/15/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class ContactListingTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.contactListingTitleColor
        label.font = UIFont.contactListingFont
        label.text = "Dummy Content"
        return label
    }()
    
    let favoriteImageView: UIImageView = {
        let favouriteImageView = UIImageView()
        favouriteImageView.image = UIImage(named: "home_favourite")
        favouriteImageView.contentMode = .scaleAspectFit
        return favouriteImageView
    }()
    
    var favoriteViewWidthAnchor: NSLayoutConstraint?
    var isFavourite: Bool? {
        didSet {
            if let isFavourite = isFavourite {
                favoriteViewWidthAnchor?.constant = isFavourite ? 20 : 0
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.cellBackgroundColor
        selectionStyle = .none
        configureProfileImageView()
        configureNameLabel()
        configureFavoriteView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        favoriteImageView.image = UIImage(named: "home_favourite")
    }
    
    func configureCellWith(_ contact: Contact?) {
        guard let contact = contact else {return}
        nameLabel.text = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        isFavourite = contact.favorite
    }
}

private extension ContactListingTableViewCell {
    
    func configureProfileImageView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), viewSize: CGSize(width: 40, height: 40))
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
    
    func configureFavoriteView() {
        addSubview(favoriteImageView)
        favoriteImageView.anchor(top: nil, leading: nameLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), viewSize: CGSize(width: 0, height: 20))
        favoriteImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        favoriteViewWidthAnchor = favoriteImageView.widthAnchor.constraint(equalToConstant: 20)
        favoriteViewWidthAnchor?.isActive = true
    }
}
