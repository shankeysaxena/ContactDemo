//
//  ContactEditableProtocol.swift
//  ContactDemo
//
//  Created by apple on 8/18/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation
import UIKit

enum ProfileViewModelItemType {
    case nameAndPicture
    case mobileNumber
    case emailAddress
    case firstName
    case lastName
}

protocol ProfileViewModelItem {
    var itemType: ProfileViewModelItemType { get }
    var itemTitle: String { get }
    var placeHolderText: String { get }
}

extension ProfileViewModelItem {
    var itemTitle: String {
        return "Basic Profile"
    }
    
    var placeHolderText: String {
        return "Enter Details here"
    }
}

class ProfileNameAndPictureItem: ProfileViewModelItem {
    
    var personName: String?
    var profileImageURL: String?
    var isFavorite: Bool?
    var itemType: ProfileViewModelItemType {
        return .nameAndPicture
    }

    init() {
        self.personName = nil
        self.profileImageURL = nil
    }
    
    init(name: String?, profileImageURL: String?, isFavorite: Bool?) {
        self.personName = name
        self.profileImageURL = profileImageURL
        self.isFavorite = isFavorite
    }
}

class ProfileMobileNumberItem: ProfileViewModelItem {
    
    var mobileNumber: String?
    var itemType: ProfileViewModelItemType {
        return .mobileNumber
    }
    var itemTitle: String {
        return "Mobile"
    }
    
    init() {
        self.mobileNumber = nil
    }
    
    init(mobileNumber: String?) {
        self.mobileNumber = mobileNumber
    }
}

class ProfileEmailAddressItem: ProfileViewModelItem {
    
    var emailAddress: String?
    var itemType: ProfileViewModelItemType {
        return .emailAddress
    }
    var itemTitle: String {
        return "Email"
    }
    
    init() {
        self.emailAddress = nil
    }
    
    init(emailAddress: String?) {
        self.emailAddress = emailAddress
    }
}

class ProfileFirstNameItem: ProfileViewModelItem {
    
    var firstName: String?
    var itemType: ProfileViewModelItemType {
        return .firstName
    }
    var itemTitle: String {
        return "First Name"
    }
    
    init() {
        self.firstName = nil
    }
    
    init(firstName: String?) {
        self.firstName = firstName
    }
}

class ProfileLastNameItem: ProfileViewModelItem {
    
    var lastName: String?
    var itemType: ProfileViewModelItemType {
        return .lastName
    }
    var itemTitle: String {
        return "Last Name"
    }
    
    init() {
        self.lastName = nil
    }
    
    init(lastName: String?) {
        self.lastName = lastName
    }
}
