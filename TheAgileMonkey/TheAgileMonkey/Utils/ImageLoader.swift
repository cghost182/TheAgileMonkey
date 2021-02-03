//
//  ImageLoader.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 3/02/21.
//

import UIKit

protocol ImageCacheType: class {
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
    func removeAllImages()
    subscript(_ url: URL) -> UIImage? { get set }
}

class ImageLoader {
    static let cache = ImageCache()
    
    static func loadImage(url: String?, callback: @escaping (_ image: UIImage)->Void) {
        guard let url = url,
              let imageURL = URL(string: url) else { return }
        
        if let image = cache[imageURL] {
            return callback(image)
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                return
            }
                        
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                cache[imageURL] = image
                callback(image ?? UIImage())
            }
        }
    }
}

final class ImageCache {

    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config

    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache: ImageCacheType {
    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer {
            lock.unlock()
        }

        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            let decodedImageData = NSData(data: decodedImage.jpegData(compressionQuality: 1) ?? Data())
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImageData.count)
            return decodedImage
        }
        return nil
    }
    
    func removeAllImages() {
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decodedImage = image.decodedImage()
        let decodedImageData = NSData(data: decodedImage.jpegData(compressionQuality: 1) ?? Data())
        
        lock.lock()
        defer { lock.unlock() }
        
        imageCache.setObject(decodedImage, forKey: url as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImageData.count)
    }

    func removeImage(for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
}
