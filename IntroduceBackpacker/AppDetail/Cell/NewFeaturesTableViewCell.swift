//
//  NewFeaturesTableViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/14.
//

import UIKit

class NewFeaturesTableViewCell: UITableViewCell {

    static let identifier: String = "NewFeaturesTableViewCell"
    
    let versionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    let versionDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    let newFeaturesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byTruncatingTail
        
        return lbl
    }()
    
    let moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
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
        
        moreButton.addTarget(self, action: #selector(viewMore(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(versionLabel)
        self.contentView.addSubview(versionDateLabel)
        self.contentView.addSubview(newFeaturesLabel)
        self.contentView.addSubview(moreButton)
        
        let margin: CGFloat = 10
        let spacing: CGFloat = 24
        
        versionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin).isActive = true
        versionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin).isActive = true
        
        versionDateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: versionLabel.trailingAnchor, constant: margin).isActive = true
        versionDateLabel.topAnchor.constraint(equalTo: versionLabel.topAnchor).isActive = true
        versionDateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin).isActive = true
        
        
        newFeaturesLabel.leadingAnchor.constraint(equalTo: versionLabel.leadingAnchor).isActive = true
        newFeaturesLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: spacing).isActive = true
        newFeaturesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin).isActive = true
        newFeaturesLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin).isActive = true
        
    }


    func configuration(version: String, versionDate: String, newFeatures: String) {
        versionLabel.text = version
        versionDateLabel.text = versionDate
        newFeaturesLabel.text = newFeatures
    }
    
    
    @objc func viewMore(_ sender: UIButton) {
        print("---viewMore Button Clicked---")
        
        
        
    }

}
