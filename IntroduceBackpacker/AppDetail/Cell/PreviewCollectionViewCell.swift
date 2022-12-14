//
//  PreviewCollectionViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/15.
//

import UIKit

protocol PreviewImageDelegate: AnyObject {
    func tappedImageView(image: UIImage)
}

class PreviewCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "SummaryInformationCollectionViewCell"
    private var delegate: PreviewImageDelegate?
    
    let previewImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 15
        imgV.layer.borderWidth = 1
        imgV.layer.borderColor = UIColor.systemGray4.cgColor
        imgV.isUserInteractionEnabled = true
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //재사용 시 이미지를 초기값으로 셋팅
        self.previewImageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        self.previewImageView.contentMode = .center
    }
    
    
    
    func commonInit() {
        
        self.contentView.addSubview(previewImageView)
        
        previewImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        previewImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        previewImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImageView(_:)))
        self.previewImageView.addGestureRecognizer(tapGesture)
    }
    
    func configuration(delegate: PreviewImageDelegate, image: UIImage?) {
        
        self.delegate = delegate
        
        if let image = image {
            self.previewImageView.image = image
            self.previewImageView.contentMode = .scaleToFill
        }
        
    }
    
    @objc func tappedImageView(_ sender: UITapGestureRecognizer) {
        print("---tapped imageView---")
        
        guard let image = self.previewImageView.image else {
            return
        }
        delegate?.tappedImageView(image: image)
    }
    
}
