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
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius =  75
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 5.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }

    func configureCellFor(item: ProfileViewModelItem?, contactMode: ContactDetailMode) {
        guard let item = item as? ProfileNameAndPictureItem else {
            return
        }
        stackViewHeightConstraint.constant = (contactMode == .newContact) ? 0 : 61
        nameLabelHeightConstraint.constant = (contactMode == .newContact) ? 0 : 20.5
        self.item = item
        nameLabel.text = item.personName
    }
    
    @IBAction func userInteractiveButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case AppConstants.UITags.callButtonTag:
            break
        case AppConstants.UITags.emailButtonTag:
            break
        case AppConstants.UITags.messageButtonTag:
            break
        case AppConstants.UITags.favouriteButtonTag:
            break
        default:
            return
        }
    }
}

private extension ContactBasicProfileCell {
 
}
