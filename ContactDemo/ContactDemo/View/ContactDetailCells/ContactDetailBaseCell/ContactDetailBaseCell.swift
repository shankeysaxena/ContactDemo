//
//  ContactDetailBaseCell.swift
//  ContactDemo
//
//  Created by apple on 8/19/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

import UIKit

class ContactDetailBaseCell: UITableViewCell {
    
    var item: ProfileViewModelItem?
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
}
