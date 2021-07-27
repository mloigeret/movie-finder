//
//  UIDownloadableImageView.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-22.
//

import UIKit

class UIDownloadableImageView: UIImageView {
    let imageCache = NSCache<NSString, AnyObject>()
    var imageURLString: String?

    func downloadImageFrom(urlString: String?,
                           placeholder: UIImage?,
                           imageMode: UIView.ContentMode) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url,
                          placeholder: placeholder,
                          imageMode: imageMode)
    }

    func downloadImageFrom(url: URL,
                           placeholder: UIImage?,
                           imageMode: UIView.ContentMode) {
        image = placeholder
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
            }.resume()
        }
    }
}
