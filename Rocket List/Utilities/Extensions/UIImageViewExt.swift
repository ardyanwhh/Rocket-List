//
//  UIImageViewExt.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadFromURL(_ urlStr: String?, callback: @escaping () -> ()) {
        guard let url = URL(string: urlStr ?? "") else { return }
        
        image = nil
        
        if let cachedData = imageCache.object(forKey: .init(string: urlStr!)) {
            image = cachedData
            callback()
        } else {
            URLSession.shared.dataTask(with: url) { data, res, err in
                guard let err = err else {
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data!)
                        imageCache.setObject(imageToCache!, forKey: .init(string: urlStr!))
                        self.image = imageToCache
                        callback()
                    }
                    return
                }
                print(err)
            }.resume()
        }
    }
}
