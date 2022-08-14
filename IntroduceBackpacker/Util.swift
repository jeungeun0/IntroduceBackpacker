//
//  Util.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import Foundation
import UIKit

public class Util {
    static let shared = Util()
    
    private let keyWindow: UIWindow? = {
        var w: UIWindow?
        if #available(iOS 13.0, *) {
            w = UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            w = UIApplication.shared.keyWindow
        }
        return w
    }()
    
    /// SafeArea의 Top과 Bottom을 구해서 리턴함
    /// - Returns: SafeArea의 Top과 Bottom
    func getSafeArea() -> (top: CGFloat, bottom: CGFloat) {
        
        var topPadding: CGFloat = 48
        var bottomPadding: CGFloat = 36
        
        topPadding = keyWindow?.safeAreaInsets.top ?? topPadding
        bottomPadding = keyWindow?.safeAreaInsets.bottom ?? bottomPadding
        
        return (topPadding, bottomPadding)
    }
    
    func getAlert(message: String, okTitle: String, okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        alert.addAction(okAction)
        
        return alert
    }
    
    
    func imageDownload(urlString: String, completion: ((_ image: UIImage)->Void)?) {
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
            
            completion?(image)
            
        }.resume()
    }
    
}
