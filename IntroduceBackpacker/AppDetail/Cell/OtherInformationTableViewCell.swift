//
//  OtherInformation2TableViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/17.
//

import UIKit

protocol OtherInformationDelegate: AnyObject {
    func tappedOtherInformationMoreButton(_ indexPath: IndexPath)
}

class OtherInformationTableViewCell: UITableViewCell {

    static let identifier = "OtherInformation2TableViewCell"
    
    let categoryLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let summaryLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        return btn
    }()
    
    let detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var indexPath: IndexPath?
    let margin: CGFloat = 10    //기본 마진 값
    typealias OtherInfoData = (summaryText: String, detailText: String?)
    var moreButtonWidthConstraint: NSLayoutConstraint!
    var detailLabelHeightConstraint: NSLayoutConstraint!
    var delegate: OtherInformationDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }

    
    
    func commonInit() {
        
        moreButton.addTarget(self, action: #selector(tappedMoreButton(_:)), for: .touchUpInside)
        
        //레이아웃
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(summaryLabel)
        self.contentView.addSubview(moreButton)
        self.contentView.addSubview(detailLabel)
        
        let spacing: CGFloat = 4
        
        categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        
        summaryLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: spacing).isActive = true
        summaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        moreButton.heightAnchor.constraint(equalTo: categoryLabel.heightAnchor).isActive = true
        
        moreButton.leadingAnchor.constraint(equalTo: summaryLabel.trailingAnchor, constant: spacing).isActive = true
        moreButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        moreButton.heightAnchor.constraint(equalTo: summaryLabel.heightAnchor).isActive = true
        
        moreButtonWidthConstraint = moreButton.widthAnchor.constraint(equalToConstant: 0)
        moreButtonWidthConstraint.priority = .init(rawValue: 998)
        moreButtonWidthConstraint.isActive = true
        
        detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        detailLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: spacing).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        
    }
    
    
    func configuration(_ indexPath: IndexPath, categoryText: String, data: OtherInfoData, isFold: Bool) {
        
        self.indexPath = indexPath
        self.categoryLabel.text = categoryText
        self.summaryLabel.text = data.summaryText
        
        if let detailText = data.detailText, false == detailText.isEmptyWithNoSpaces() {
            self.detailLabel.text = detailText
            self.moreButtonWidthConstraint.constant = 50
        } else {
            self.moreButtonWidthConstraint.constant = 0
        }
        
        if isFold {
//            if detailLabelHeightConstraint == nil {
//                detailLabelHeightConstraint = detailLabel.heightAnchor.constraint(equalToConstant: 0)
//                detailLabelHeightConstraint.priority = .init(rawValue: 999)
//                detailLabelHeightConstraint.isActive = true
//            } else {
//                self.detailLabelHeightConstraint.constant = self.detailLabel.intrinsicContentSize.height
//            }
            
        } else {
            
//            if detailLabelHeightConstraint == nil {
                detailLabelHeightConstraint = detailLabel.heightAnchor.constraint(equalToConstant: 0)
                detailLabelHeightConstraint.priority = .init(rawValue: 999)
                detailLabelHeightConstraint.isActive = true
//            } else {
//                self.detailLabelHeightConstraint.constant = 0
//            }
        }
        
    }
    
    //버튼을 누르면
    @objc func tappedMoreButton(_ sender: UIButton) {
        print("---tapped moreButton---")
        
        guard let indexPath = indexPath else {
            return
        }

        delegate?.tappedOtherInformationMoreButton(indexPath)
    }

}
