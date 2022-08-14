//
//  PreviewCollectionViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/15.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "SummaryInformationCollectionViewCell"
    
    let previewImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 15
        imgV.layer.borderWidth = 1
        imgV.layer.borderColor = UIColor.systemGray4.cgColor
        return imgV
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        self.contentView.addSubview(previewImageView)
        
        previewImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        previewImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        previewImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        
    }
    
    func configuration(image: UIImage?) {
        
        if let image = image {
            self.previewImageView.image = image
            self.previewImageView.contentMode = .scaleToFill
        } else {
            self.previewImageView.image = UIImage(systemName: "photo.on.rectangle.angled")
            self.previewImageView.contentMode = .center
        }
        
    }
}
