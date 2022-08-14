//
//  UIImageViewExtension.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/15.
//

import Foundation
import UIKit


extension UIImageView {
    func imageDownload(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("--error: url not available---")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200, let mineType = response?.mimeType, mineType.hasPrefix("image"), let data = data, error == nil, let image = UIImage(data: data) else {
                print("---error: image download fail---")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
