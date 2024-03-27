//
//  ImageCache.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 26.03.2024.
//

import UIKit

protocol ImageCacheProtocol: AnyObject {
    
    func add(url key: String, image value: UIImage)
    func getImage(url key: String) -> UIImage?
}


final class ImageCache: ImageCacheProtocol {
    
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()

    func getImage(url key: String) -> UIImage? {
        guard let image = cache.object(forKey: key as NSString) else { return nil }
        return image
    }
    
    func add(url key: String, image value: UIImage) {
        cache.setObject(value, forKey: key as NSString)
    }
}
