//
//  UILabelExtension.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/15.
//

import Foundation
import UIKit


extension UILabel {
    
    /// 라벨의 현재 줄 수를 구합니다.
    /// - Returns: 현재 라벨의 줄 수
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
