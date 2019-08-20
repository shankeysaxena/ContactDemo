//
//  AsyncImageView.swift
//  ContactDemo
//
//  Created by apple on 8/19/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation
import UIKit

/// Use this image view for setting image asynchronously
/// It will download the image is not cached.

public class AsyncImageView: UIImageView {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    public func imageFromServerURL(_ urlString: String?, placeHolder: UIImage? = nil) {
        
        let originalCotentMode = self.contentMode
        self.contentMode = .scaleAspectFit
        self.image = placeHolder
        guard let urlString = urlString else {
            self.image = placeHolder
            return
        }
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.contentMode = originalCotentMode
            self.image = cachedImage
            return
        }
        Loader.addLoaderOn(self)
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {[weak self] (data, response, error) in
                if error != nil {
                    if let strongSelf = self {
                        DispatchQueue.main.async {
                            Loader.removeLoaderFrom(strongSelf)
                            strongSelf.image = placeHolder
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            if let strongSelf = self {
                                Loader.removeLoaderFrom(strongSelf)
                                strongSelf.imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                                strongSelf.contentMode = originalCotentMode
                                strongSelf.image = downloadedImage
                            }
                        }
                    }
                }
            }).resume()
        }
    }
    
}

