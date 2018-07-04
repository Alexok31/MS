//
//  DownloadImage.swift
//  myMesseger
//
//  Created by Александр Харченко on 04.06.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloadImeg (from url: String) {
        self.image = nil
        
        if let cachedImeg = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImeg
            return
        }
            let urlRequest = URLRequest (url: URL(string: url)!)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!) {
                            imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                            self.image = UIImage (data: data!)
                        }
                        
                    }
                }
            
        }
      task.resume()
       
    }
    
    
}
