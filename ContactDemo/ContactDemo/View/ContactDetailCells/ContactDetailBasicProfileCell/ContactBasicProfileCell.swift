//
//  ContactBasicProfileCell.swift
//  ContactDemo
//
//  Created by apple on 8/19/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class ContactBasicProfileCell: ContactDetailBaseCell {

    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var profileImageView: AsyncImageView!
    
    private var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "favourite_selected" : "favourite_unselected"
            favouriteButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    private var editingClosure: ((Bool, AppConstants.ProfileButtonTags) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius =  75
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 5.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }

    func configureCellFor(item: ProfileViewModelItem?, contactMode: ContactDetailMode, with editingClosure: @escaping ((Bool?, AppConstants.ProfileButtonTags) -> ())) {
        guard let item = item as? ProfileNameAndPictureItem else {
            return
        }
        stackViewHeightConstraint.constant = (contactMode == .newContact) ? 0 : 61
        nameLabelHeightConstraint.constant = (contactMode == .newContact) ? 0 : 20.5
        self.editingClosure = editingClosure
        self.item = item
        self.isFavorite = item.isFavorite ?? false
        nameLabel.text = item.personName
        
        profileImageView.imageFromServerURL(item.profileImageURL, placeHolder: UIImage(named: "placeholder"))
    }
    
    @IBAction func userInteractiveButtonTapped(_ sender: UIButton) {
        
        switch sender.tag {
        case AppConstants.ProfileButtonTags.callButtonTag.rawValue:
            editingClosure?(true, AppConstants.ProfileButtonTags.callButtonTag)
            break
        case AppConstants.ProfileButtonTags.emailButtonTag.rawValue:
            editingClosure?(true, AppConstants.ProfileButtonTags.emailButtonTag)
            break
        case AppConstants.ProfileButtonTags.messageButtonTag.rawValue:
            editingClosure?(true, AppConstants.ProfileButtonTags.messageButtonTag)
            break
        case AppConstants.ProfileButtonTags.favouriteButtonTag.rawValue:
            isFavorite = !isFavorite
            editingClosure?(true, AppConstants.ProfileButtonTags.favouriteButtonTag)
            break
        default:
            return
        }
    }
}

private extension ContactBasicProfileCell {
 
}
