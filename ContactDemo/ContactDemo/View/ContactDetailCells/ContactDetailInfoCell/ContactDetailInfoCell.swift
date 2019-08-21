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
    
    private var editingClosure: ((String?, ProfileViewModelItemType) -> ())?
    
    override var item: ProfileViewModelItem? {
        didSet {
            titleLabel.text = self.item?.itemTitle
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoTextField.tintColor = UIColor.themeColor
        infoTextField.delegate = self
    }
    
    func configureCellWith(item: ProfileViewModelItem?, isInEditMode: Bool, with editingClosure: @escaping ((String?, ProfileViewModelItemType) -> ())){
        self.item = item
        configureTextField()
        infoTextField.isUserInteractionEnabled = isInEditMode
        self.editingClosure = editingClosure
    }
}

extension ContactDetailInfoCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingClosure?(textField.text, item?.itemType ?? .nameAndPicture)
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
