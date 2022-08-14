//
//  BriefInformationTableViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import UIKit


class BriefInformationTableViewCell: UITableViewCell {
    
    static let identifier: String = "BriefInformationTableViewCell"
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let appTrackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let developerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let openButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("앱 스토어에서 열기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        let buttonHeight = button.intrinsicContentSize.height + 2
        button.layer.cornerRadius = buttonHeight/2
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    var imageHeightConstraint: NSLayoutConstraint!
    private var appStoreOpenUrlString: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        appStoreOpenUrlString = "https://itunes.apple.com/app/id"
        openButton.addTarget(self, action: #selector(openAppStore(_:)), for: .touchUpInside)
        
        
        self.contentView.addSubview(appIconImageView)
        self.contentView.addSubview(appTrackNameLabel)
        self.contentView.addSubview(developerNameLabel)
        self.contentView.addSubview(openButton)
        
        let margin: CGFloat = 24
        let spacing: CGFloat = 4
        
        //이미지
        appIconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin).isActive = true
        appIconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin).isActive = true
        appIconImageView.widthAnchor.constraint(equalTo: appIconImageView.heightAnchor).isActive = true
        let appIconImageViewBottomConstraint = appIconImageView.bottomAnchor.constraint(greaterThanOrEqualTo: self.contentView.bottomAnchor, constant: -margin)
        appIconImageViewBottomConstraint.priority = .init(rawValue: 998)
        appIconImageViewBottomConstraint.isActive = true
        //이미지 높이 저장
        imageHeightConstraint = appIconImageView.heightAnchor.constraint(equalToConstant: 1)
        imageHeightConstraint.priority = .init(rawValue: Float(999))
        imageHeightConstraint.isActive = true
        
        //앱 이름
        appTrackNameLabel.leadingAnchor.constraint(equalTo: appIconImageView.trailingAnchor, constant: margin).isActive = true
        appTrackNameLabel.topAnchor.constraint(equalTo: appIconImageView.topAnchor).isActive = true
        appTrackNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin).isActive = true
        
        //개발자 이름
        developerNameLabel.leadingAnchor.constraint(equalTo: appTrackNameLabel.leadingAnchor).isActive = true
        developerNameLabel.topAnchor.constraint(equalTo: appTrackNameLabel.bottomAnchor, constant: spacing).isActive = true
        developerNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin).isActive = true
        
        //열기 버튼
        openButton.leadingAnchor.constraint(equalTo: developerNameLabel.leadingAnchor).isActive = true
        openButton.centerYAnchor.constraint(equalTo: appIconImageView.bottomAnchor).isActive = true
        openButton.topAnchor.constraint(greaterThanOrEqualTo: developerNameLabel.bottomAnchor, constant: margin).isActive = true
        openButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin).isActive = true
        let openButtonOrizinalSize = openButton.intrinsicContentSize
        let openButtonWidthPadding: CGFloat = 10
        let openButtonHeightPadding: CGFloat = 1
        openButton.widthAnchor.constraint(equalToConstant: openButtonOrizinalSize.width + (openButtonWidthPadding * 2)).isActive = true
        openButton.heightAnchor.constraint(equalToConstant: openButtonOrizinalSize.height + (openButtonHeightPadding * 2)).isActive = true
        
    }


    func configuration(imageUrl: String, trackName: String, trackId: Int, developerName: String, imageHeight: CGFloat) {
        
        
        self.appIconImageView.imageDownload(urlString: imageUrl)
        appTrackNameLabel.text = trackName
        developerNameLabel.text = developerName
        imageHeightConstraint.constant = imageHeight
        appStoreOpenUrlString += "\(trackId)"
    }
    
    
    @objc func openAppStore(_ sender: UIButton) {
        print("---openAppStore Button Clicked---")
        
        guard let url = URL(string: appStoreOpenUrlString) else {
            print("---error: Url is invalid.---")
            return
        }
        
        guard true == UIApplication.shared.canOpenURL(url) else {
            print("---error: Unable to open Url.---")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }

}
