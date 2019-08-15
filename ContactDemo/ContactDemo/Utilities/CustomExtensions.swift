//
//  CustomExtensions.swift
//  ContactDemo
//
//  Created by apple on 8/15/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

extension UIFont {
    static var standardAppSemiboldFont: UIFont {
        return UIFont(name: AppFontName.semibold, size: 17.0)!
    }
    
    static var contactListingFont: UIFont {
        return UIFont(name: AppFontName.bold, size: 14.0)!
    }
}
