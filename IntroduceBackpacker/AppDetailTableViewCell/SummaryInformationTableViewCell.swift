//
//  SummaryInformationTableViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/14.
//

import UIKit

class SummaryInformationTableViewCell: UITableViewCell {

    static let identifier: String = "SummaryInformationTableViewCell"
    
    struct SummaryData {
        var firstText: String
        var secondText: String
        var thirdText: String
    }
    
    let collectionView: UICollectionView = {
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 10
            
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        layout.itemSize = CGSize(width: 100, height: 100)
           
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
            return cv
        }()
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    var summaryData: [SummaryData] = []
    
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
        
        self.contentView.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
//        collectionView.widthAnchor.constraint(equalTo: collectionView.heightAnchor).isActive = true
        
        collectionView.register(SummaryInformationCollectionViewCell.self, forCellWithReuseIdentifier: SummaryInformationCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionViewHeightConstraint.priority = .init(rawValue: Float(999))
        collectionViewHeightConstraint.isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration(summaryData: [SummaryData], collectionViewHeight: CGFloat) {
        self.summaryData = summaryData
        collectionViewHeightConstraint.constant = collectionViewHeight
    }

}

extension SummaryInformationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.summaryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dummyCell = UICollectionViewCell()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryInformationCollectionViewCell.identifier, for: indexPath) as? SummaryInformationCollectionViewCell
        cell?.configuration(firstText: self.summaryData[indexPath.row].firstText,
                            secondeText: self.summaryData[indexPath.row].secondText,
                            thirdText: self.summaryData[indexPath.row].thirdText)
        return cell ?? dummyCell
    }
    
}
