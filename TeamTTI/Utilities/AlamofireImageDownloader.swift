//
//  AlamofireImageDownloader.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 26/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Optik
import AlamofireImage

internal struct AlamofireImageDownloader: Optik.ImageDownloader {
    
    private let internalImageDownloader = AlamofireImage.ImageDownloader()
    
    func downloadImage(from url: URL, completion: @escaping ImageDownloaderCompletion) {
        let URLRequest = Foundation.URLRequest(url: url)
        
        internalImageDownloader.download(URLRequest) {
            response in
            
            switch response.result {
            case .success(let image):
                completion(image)
            case .failure(_):
                // Hanlde error
                return
            }
        }
    }
    
}
