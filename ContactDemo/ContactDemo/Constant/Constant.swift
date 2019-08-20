//
//  Constant.swift
//  ContactDemo
//
//  Created by apple on 8/15/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

struct AppFontName {
    static let semibold = "SFUIText-Semibold"
    static let bold = "SFUIText-Bold"
}

struct CellIdentifiers {
    static let contactListCellIdentifier = "contactListCellIdentifier"
    static let contactBasicProfileCellIdentifier = "contactBasicProfileCellIdentifier"
    static let contactDetailInfoCellIdentifier = "contactDetailInfoCellIdentifier"
}

struct AppConstants {
    enum UITags {
        static let CustomLoaderTag = 123
        static let messageButtonTag = 999
        static let callButtonTag = 998
        static let emailButtonTag = 997
        static let favouriteButtonTag = 996
    }
    
    enum CustomiseUIHeights {
        static let contactListingCellHeight = 64
        static let contactListingHeaderHeight = 40
        static let contactDetailProfileCellHeight = 335
        static let contactDetailCellHeight = 56
    }
    static let errorTitle = "Error"
}
