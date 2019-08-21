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

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension UIViewController {
    
    func showAlertView(_ title: String?, message: String?, cancelButtonTitle: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertAction = UIAlertAction.init(title: cancelButtonTitle, style: .default, handler: handler)
        showAlert(actions: [alertAction], title: title, message: message)
    }
    
    func showAlert(_ error: String) {
        showAlertView(AppConstants.errorTitle, message: error)
    }
    
    func showAlertView(_ title: String?, message: String?, cancelButtonTitle: String, otherButtonTitle: String, cancelHandler: ((UIAlertAction) -> Void)? = nil, otherOptionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertAction = UIAlertAction.init(title: otherButtonTitle, style: .default, handler: otherOptionHandler)
        let cancelAction = UIAlertAction.init(title: cancelButtonTitle, style: .default, handler: cancelHandler)
        showAlert(actions: [cancelAction, alertAction], title: title, message: message)
    }
    
    func showAlert(actions: [UIAlertAction], title: String? = nil, message: String? = nil, type: UIAlertController.Style = .alert) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: type)
        actions.forEach { alertController.addAction($0) }
        alertController.preferredAction = actions.last
        self.present(alertController, animated: true, completion: nil)
    }
}

