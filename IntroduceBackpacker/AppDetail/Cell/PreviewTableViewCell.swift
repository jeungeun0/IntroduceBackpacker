//
//  PreviewTableViewCell.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/15.
//

import UIKit
import Combine

class PreviewTableViewCell: UITableViewCell {

    static let identifier: String = "PreviewTableViewCell"
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.height * 0.7)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.height * 0.7)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        // 스크롤 시 빠르게 감속 되도록 설정
        cv.decelerationRate = .fast
        return cv
    }()
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var imageUrlStrings: [String] = []
    var images: [Int: UIImage] = [:]
    
    // 현재 페이지 인덱스
    var currentIndex: CGFloat = 0
    
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
        
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
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
    
    func configuration(imageUrlStrings: [String]) {
        self.imageUrlStrings = imageUrlStrings
        
        collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.7
        
        imageUrlStrings.enumerated().forEach { index, imageUrlString in
            Util.shared.imageDownload(urlString: imageUrlString) { image in
                let newImage = image.resizeImage(newWidth: UIScreen.main.bounds.size.width * 0.7)
                self.images[index] = newImage
                
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
                
            }
        }
        
    }

}



extension PreviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dummyCell = UICollectionViewCell()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionViewCell.identifier, for: indexPath) as? PreviewCollectionViewCell
        guard let image = self.images[indexPath.row] else {
            return dummyCell
        }
        cell?.configuration(image: image)
        return cell ?? dummyCell
    }
    
    // 페이징
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / itemWidth
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
        
        offset = CGPoint(x: roundedIndex * itemWidth - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
}
