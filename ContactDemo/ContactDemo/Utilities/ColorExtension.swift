//
//  ColorExtension.swift
//  ContactDemo
//
//  Created by apple on 8/15/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var themeColor: UIColor {
        //80, 227, 194
        return UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1.0)
    }
    
    static var contactListingTitleColor: UIColor {
        //#4A4A4A
        return UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
    }
    
    static var listingHeaderColor: UIColor {
        //#E8E8E8
        return UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    static var cellBackgroundColor: UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
}
