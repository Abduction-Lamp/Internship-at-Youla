//
//  ImageCache.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()

    public func getImage(url key: String) -> UIImage? {
        guard let image = cache.object(forKey: key as NSString) else { return nil }
        return image
    }
    
    public func add(url key: String, image value: UIImage) {
        cache.setObject(value, forKey: key as NSString)
    }
}
