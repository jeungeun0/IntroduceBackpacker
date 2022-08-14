//
//  UIImageExtension.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/15.
//

import Foundation
import UIKit


extension UIImage {
    /// - Parameter newWidth: 새로운 가로 크기
    /// - Returns: 리사이징 된 이미지
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width // 새 이미지 확대/축소 비율
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
