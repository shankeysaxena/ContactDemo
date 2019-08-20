//
//  ContactDetailInfoCell.swift
//  ContactDemo
//
//  Created by apple on 8/19/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class ContactDetailInfoCell: ContactDetailBaseCell {

    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var item: ProfileViewModelItem? {
        didSet {
            titleLabel.text = self.item?.itemTitle
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoTextField.tintColor = UIColor.themeColor
    }
    
    func configureCellWith(item: ProfileViewModelItem?, isInEditMode: Bool) {
        self.item = item
        configureTextField()
        infoTextField.isUserInteractionEnabled = isInEditMode
    }
}

private extension ContactDetailInfoCell {
    func configureTextField() {
        guard let item = item else {
            return
        }
        var text = ""
        switch item.itemType {
        case .mobileNumber:
            if let mobileItem = item as? ProfileMobileNumberItem, let mobileNumber = mobileItem.mobileNumber {
                text = mobileNumber
            }
        case .emailAddress:
            if let emailItem = item as? ProfileEmailAddressItem, let email = emailItem.emailAddress {
                text = email
            }
        case .firstName:
            if let firstNameItem = item as? ProfileFirstNameItem, let firstName = firstNameItem.firstName {
                text = firstName
            }
        case .lastName:
            if let lastNameItem = item as? ProfileLastNameItem, let lastName = lastNameItem.lastName {
                text = lastName
            }
        default:
            break
        }
        
        infoTextField.text = text
        infoTextField.placeholder = item.placeHolderText
    }
}
