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
    
    let appTrackName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    var imageHeightConstraint: NSLayoutConstraint!
    
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
        self.addSubview(appIconImageView)
        self.addSubview(appTrackName)
        
        let margin: CGFloat = 24
        
        appIconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
        appIconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        appIconImageView.widthAnchor.constraint(equalTo: appIconImageView.heightAnchor).isActive = true
        appIconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
        
        appTrackName.leadingAnchor.constraint(equalTo: appIconImageView.trailingAnchor, constant: margin).isActive = true
        appTrackName.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        appTrackName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        appTrackName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
        
        imageHeightConstraint = appIconImageView.heightAnchor.constraint(equalToConstant: 1)
        imageHeightConstraint.priority = .init(rawValue: Float(999))
        imageHeightConstraint.isActive = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration(imageUrl: String, trackName: String, imageHeight: CGFloat) {
        
        //do something...
        imageDownload(urlString: imageUrl)
        appTrackName.text = trackName
        imageHeightConstraint.constant = imageHeight

    }
    
    
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
                self.appIconImageView.image = image
            }
        }.resume()
    }

}
