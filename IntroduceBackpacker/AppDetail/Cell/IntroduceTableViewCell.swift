//
//  IntroduceTableViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/15.
//

import UIKit

protocol IntroduceDelegate: AnyObject {
    func tappedMoreButton(_ indexPath: IndexPath)
}

class IntroduceTableViewCell: UITableViewCell {
    
    static let identifier = "IntroduceTableViewCell"
    
    let introduceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    let moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        btn.setTitle("펼치기", for: .normal)
        btn.backgroundColor = .white
        return btn
    }()
    

    
    var gradientLayer: CAGradientLayer? //버튼 옆에 들어갈 그라데이션 레이어
    let margin: CGFloat = 10    //기본 마진 값
    var indexPath: IndexPath?   //버튼 터치 시 셀을 리로드하기 위한 indexPath
    var delegate: IntroduceDelegate?    //버튼의 이벤트를 대신할 대리자
    
    
    
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

    
    
    func commonInit() {
        
        //버튼 타겟 지정
        moreButton.addTarget(self, action: #selector(tappedMoreButton(_:)), for: .touchUpInside)
        
        
        //레이아웃
        self.contentView.addSubview(introduceLabel)
        self.contentView.addSubview(moreButton)
        
        introduceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin).isActive = true
        introduceLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin).isActive = true
        introduceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin).isActive = true
        
        moreButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: margin).isActive = true
        moreButton.topAnchor.constraint(equalTo: introduceLabel.bottomAnchor, constant: margin).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        moreButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -margin).isActive = true
        let moreButtonWidth = moreButton.intrinsicContentSize.width + 4
        let moreButtonHeight = moreButton.intrinsicContentSize.height + 2
        moreButton.widthAnchor.constraint(equalToConstant: moreButtonWidth).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: moreButtonHeight).isActive = true
        
    }
    
    
    func configuration(introduceText: String, indexPath: IndexPath, isMoreButton: Bool, normalLine: Int) {
        
        self.introduceLabel.text = introduceText
        
        
        //더보기 버튼을 터치했을 때 본 셀을 리로드하기 위한, 본 셀의 indexPath 저장
        self.indexPath = indexPath
        
        
        //소개글의 줄 수가 normalLine보다 많거나 적을 때의 처리
        let totalLineCount = self.introduceLabel.calculateMaxLines()
        if totalLineCount > normalLine {
            
            if true == isMoreButton {
                //'펼치기'버튼을 안 눌렀거나 '접기'를 눌렀을 때 이므로, 버튼의 이름이 '펼치기'로 변경되어야 함.
                self.moreButton.setTitle("펼치기", for: .normal)
                //소개글이 normalLine줄을 초과했기 때문에 글을 normalLine줄까지만 보이게 높이를 조정해야 함.
                //font는 라벨을 만들 때 생성했으므로 무조건 있지만, 혹---시나 없으면 버튼을 없애고 소개글을 모두 보여줌
                if let font = self.introduceLabel.font {
                    let lineHeight = font.lineHeight
                    let toHeight = (lineHeight * CGFloat(normalLine)) + (margin * 2)
                    self.introduceLabel.heightAnchor.constraint(equalToConstant: toHeight).isActive = true
                } else {
                    self.moreButton.isHidden = true
                }
            } else {
                //'펼치기'버튼을 눌렀을 때 이므로, 버튼의 이름이 '접기'로 변경되어야 함.
                self.moreButton.setTitle("접기", for: .normal)
            }
        } else {
            //소개글이 normalLine줄 이하이기 때문에 버튼이 필요 없음.
            self.moreButton.isHidden = true
        }
    }

    
    //버튼을 누르면 소개글을 다 보이게 할 지 말지를 토글함.
    @objc func tappedMoreButton(_ sender: UIButton) {
        print("---tapped moreButton---")
        guard let indexPath = indexPath else {
            return
        }
        delegate?.tappedMoreButton(indexPath)
    }

}
