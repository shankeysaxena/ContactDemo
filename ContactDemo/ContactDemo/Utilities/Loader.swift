//
//  Loader.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit


/// Use this view for animating the activity indicator when required.
/// This will not let user do any action on UI during the animation
/// Note: It won't block the navigation bar
public class Loader: UIView {
    
    private let indicator = UIActivityIndicatorView()
    private let gradView = UIView()
    private let width: CGFloat = 60.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag = AppConstants.UITags.CustomLoaderTag
        
        gradView.frame = CGRect(x: frame.width/2-width/2, y: frame.height/2-width/2, width: width, height: width)
        self.addSubview(gradView)
        gradView.backgroundColor = UIColor.white
        
        let height = CGFloat(30)
        indicator.style = UIActivityIndicatorView.Style.whiteLarge
        indicator.frame = CGRect(x: gradView.frame.width/2-height/2, y: gradView.frame.height/2-height/2, width: height, height: height)
        indicator.startAnimating()
        gradView.addSubview(indicator)
        self.backgroundColor = #colorLiteral(red: 0.0683105862, green: 0.05541461017, blue: 0.1008936216, alpha: 0.2799389983)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideGradient(_ hide: Bool) {
        gradView.backgroundColor = hide ? UIColor.clear : UIColor.white
    }
    
    func isSmallInd(small: Bool) {
        indicator.style = small ? .white : .whiteLarge
        indicator.color = UIColor.themeColor
    }
    
    // MARK: - Class methods
    class func addLoaderOn(_ aView: UIView, gradient: Bool = false, small: Bool = false) {
        Loader.removeLoaderFrom(aView)
        DispatchQueue.main.async {
            let loader = Loader(frame: aView.bounds)
            loader.isSmallInd(small: small)
            loader.hideGradient(!gradient)
            aView.addSubview(loader)
        }
    }
    
    class func removeLoaderFrom(_ aView: UIView?) {
        DispatchQueue.main.async {
            if let loader = aView?.viewWithTag(AppConstants.UITags.CustomLoaderTag) {
                loader.removeFromSuperview()
            }
        }
    }
}

