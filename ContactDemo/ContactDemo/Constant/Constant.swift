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
        static let CustomLoaderTag = 995
        static let ShimmeringLoaderTag = 994
    }
    
    enum ProfileButtonTags: Int {
        case messageButtonTag = 999
        case callButtonTag = 998
        case emailButtonTag = 997
        case favouriteButtonTag = 996
    }
    
    enum CustomiseUIHeights {
        static let contactListingCellHeight = 64
        static let contactListingHeaderHeight = 40
        static let contactDetailProfileCellHeight = 335
        static let contactDetailCellHeight = 56
    }
    static let errorTitle = "Error"
    static let contactSuccessfullyPostedMessage = "Contact has been posted successfully"
}
