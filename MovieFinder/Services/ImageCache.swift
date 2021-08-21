//
//  ImageCache.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-08-20.
//

import UIKit

class ImageCache {
    private let _cache = NSCache<NSString, UIImage>()
    private var _observer: NSObjectProtocol?

    static let shared = ImageCache()

    private init() {
        _observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification,
                                                           object: nil,
                                                           queue: nil) { [weak self] notification in
            self?._cache.removeAllObjects()
        }
    }

    deinit {
        guard let observer = _observer else {return}
        NotificationCenter.default.removeObserver(observer)
    }

    func image(forKey key: String) -> UIImage? {
        return _cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        _cache.setObject(image, forKey: key as NSString)
    }
}
