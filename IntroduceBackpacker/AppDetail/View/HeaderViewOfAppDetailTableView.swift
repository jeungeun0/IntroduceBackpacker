//
//  HeaderViewOfAppDetailTableView.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/14.
//

import UIKit

protocol HeaderViewOfAppDetailDelegate: AnyObject {
    func touchAnyButton(_ sender: UIButton)
}

class HeaderViewOfAppDetailTableView: UIView {
    
    var delegate: HeaderViewOfAppDetailDelegate?
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 24, weight: .heavy)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let anyButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        anyButton.addTarget(self, action: #selector(touchAnyButton(_:)), for: .touchUpInside)
        
        self.addSubview(titleLabel)
        self.addSubview(anyButton)
        
        let margin: CGFloat = 10
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
        
        anyButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: margin).isActive = true
        anyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        anyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        anyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
    }
    
    @objc func touchAnyButton(_ sender: UIButton) {
        delegate?.touchAnyButton(sender)
    }

}
