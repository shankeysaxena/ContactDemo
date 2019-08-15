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
    
    let favouriteImageView: UIImageView = {
        let favouriteImageView = UIImageView()
        favouriteImageView.image = UIImage(named: "home_favourite")
        favouriteImageView.contentMode = .scaleAspectFit
        return favouriteImageView
    }()
    
    var isFavourite: Bool? {
        didSet {
            
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(favouriteImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), viewSize: CGSize(width: 40, height: 40))
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        
        
        favouriteImageView.anchor(top: nil, leading: nameLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), viewSize: CGSize(width: 20, height: 20))
        favouriteImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
