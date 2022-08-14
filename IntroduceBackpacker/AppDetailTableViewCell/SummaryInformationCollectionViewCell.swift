//
//  SummaryInformationCollectionViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/14.
//

import UIKit

class SummaryInformationCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "SummaryInformationCollectionViewCell"
    
    let firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let lineView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray3
        return v
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
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(firstLabel)
        containerView.addSubview(secondLabel)
        containerView.addSubview(thirdLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(lineView)
        
        let margin: CGFloat = 10
        firstLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin).isActive = true
        firstLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin).isActive = true
        firstLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin).isActive = true
//        firstLabel.bottomAnchor
        
        secondLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin).isActive = true
        secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: margin).isActive = true
        secondLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin).isActive = true
//        secondLabel.bottomAnchor
        
        thirdLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin).isActive = true
        thirdLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: margin).isActive = true
        thirdLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin).isActive = true
        thirdLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -margin).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        lineView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: margin).isActive = true
        lineView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin).isActive = true
        lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func configuration(firstText: String, secondeText: String, thirdText: String) {
        self.firstLabel.text = firstText
        self.secondLabel.text = secondeText
        self.thirdLabel.text = thirdText
    }
}
