//
//  AppDetailViewController.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import UIKit

class AppDetailViewController: UIViewController {
    
    //section과 순서
    enum Section: Int {
        case SummaryInfo = 0
        case NewFeatures = 1
        case PreView = 2
    }
    
    enum SectionName: String {
        case SummaryInfo
        case NewFeatures = "새로운 기능"
        case PreView = "미리보기"
    }
    
    //app data
    let responseData: Response
    
    //section정보
    typealias OpenAndFold = (open:Int, fold: Int, isOpen: Bool)
    var sectionAndRow: [Section: OpenAndFold] = [:]
    var sectionName: [Section: SectionName] = [:]
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    
    
    init?(responseData: Response, coder: NSCoder) {
        self.responseData = responseData
        super.init(coder: coder)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(responseData)
        setUI()
        configurationTableView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func setUI() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = Util.shared.getSafeArea()
        let navigationHeight: CGFloat = self.navigationController?.navigationBar.frame.size.height ?? 0
        
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeArea.top + navigationHeight),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    
    func configurationTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        tableView.tableFooterView = .init(frame: .zero)
        tableView.sectionFooterHeight = 0
        
        //register
        tableView.register(BriefInformationTableViewCell.self, forCellReuseIdentifier: BriefInformationTableViewCell.identifier)
        tableView.register(SummaryInformationTableViewCell.self, forCellReuseIdentifier: SummaryInformationTableViewCell.identifier)
        tableView.register(NewFeaturesTableViewCell.self, forCellReuseIdentifier: NewFeaturesTableViewCell.identifier)
        tableView.register(PreviewTableViewCell.self, forCellReuseIdentifier: PreviewTableViewCell.identifier)
        
        //section 정보 생성
        createSectionAndRow()
    }
    
    
    func createSectionAndRow() {
        self.sectionAndRow[.SummaryInfo] = (open: 2, fold: 0, isOpen: true)
        self.sectionAndRow[.NewFeatures] = (open: 1, fold: 0, isOpen: false)
        self.sectionAndRow[.PreView] = (open: 1, fold: 0, isOpen: false)
        
        self.sectionName[.SummaryInfo] = .SummaryInfo
        self.sectionName[.NewFeatures] = .NewFeatures
        self.sectionName[.PreView] = .PreView
    }
}



//MARK: - TableViewDelegate
extension AppDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionAndRow.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionType = Section.init(rawValue: section) else { return 0 }
        guard let row = self.sectionAndRow[sectionType] else { return 0 }
        
        if true == row.isOpen {
            return row.open
        } else {
            return row.fold
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dummyCell = UITableViewCell()
        var resultCell: UITableViewCell?
        
        switch Section.init(rawValue: indexPath.section) {
        case .SummaryInfo:
            if 0 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: BriefInformationTableViewCell.identifier) as? BriefInformationTableViewCell
                let appImageHeight = UIScreen.main.bounds.size.width * 0.3
                cell?.configuration(imageUrl: responseData.results[0].artworkUrl512, trackName: responseData.results[0].trackName, trackId: responseData.results[0].trackId, developerName: responseData.results[0].sellerName, imageHeight: appImageHeight)
                
                resultCell = cell
            }
            else if 1 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: SummaryInformationTableViewCell.identifier) as? SummaryInformationTableViewCell
                var summaryData: [SummaryInformationTableViewCell.SummaryData] = []
                let digit: Double = pow(10, 1)
                summaryData.append(.init(firstText: "평가",
                                         secondText: "\(ceil(responseData.results[0].averageUserRating * digit) / digit)",
                                         thirdText: "점"))
                summaryData.append(.init(firstText: "연령", secondText: responseData.results[0].contentAdvisoryRating, thirdText: "세"))
                summaryData.append(.init(firstText: "카테고리", secondText:  responseData.results[0].genres[0], thirdText: " "))
                summaryData.append(.init(firstText: "개발자", secondText: responseData.results[0].artistName, thirdText: " "))
                var languardCode = responseData.results[0].languageCodesISO2A[0]
                responseData.results[0].languageCodesISO2A.forEach { code in
                    if true == Locale.preferredLanguages[0].uppercased().contains(code.uppercased()) {
                        languardCode = code
                    }
                }
                var languageCount = responseData.results[0].languageCodesISO2A.count
                languageCount = languageCount > 1 ? languageCount - 1 : 0
                let languageCountString = languageCount > 0 ? "+\(languageCount)" : " "
                summaryData.append(.init(firstText: "언어", secondText: languardCode, thirdText: languageCountString))
                
                cell?.configuration(summaryData: summaryData,
                                    collectionViewHeight: 130)
                resultCell = cell
            }
            break
        case .NewFeatures:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewFeaturesTableViewCell.identifier) as? NewFeaturesTableViewCell
            let version = "버전 \(responseData.results[0].version)"
            
            let dateFormatter = ISO8601DateFormatter()
            
            var days: Int?
            if let versionDate = dateFormatter.date(from: responseData.results[0].currentVersionReleaseDate) {
                let currentDate = Date()
                let interval = currentDate.timeIntervalSince(versionDate)
                days = Int(interval / 86400)
            }
            
            let versionDate = days != nil ? "\(days!)일 전" : responseData.results[0].currentVersionReleaseDate
            
            let newFeatures = responseData.results[0].releaseNotes
            
            cell?.configuration(version: version, versionDate: versionDate, newFeatures: newFeatures)
            
            resultCell = cell
            break
        case .PreView:
            let cell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier) as? PreviewTableViewCell
            
            cell?.configuration(imageUrlStrings: responseData.results[0].screenshotUrls)
            resultCell = cell
            break
        case .none: break
        }
        
        return resultCell ?? dummyCell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let noneView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.1, height: 0.1)))
        if section == 0 {
            return noneView
        } else {
            let headerView = HeaderViewOfAppDetailTableView()
            
            guard let sectionType = Section(rawValue: section) else {
                return noneView
            }
            
            guard let sectionName = self.sectionName[sectionType] else {
                return noneView
            }
            
            guard let row = self.sectionAndRow[sectionType] else {
                return noneView
            }
            
            headerView.titleLabel.text = sectionName.rawValue
            headerView.anyButton.setTitle(row.isOpen == true ? "접기" : "펼치기", for: .normal)
            //tag에 section 번호를 저장해야 버튼 터치 이벤트를 처리할 수 있다.
            headerView.anyButton.tag = section
            headerView.delegate = self
            return headerView
        }
    }
    
}



//MARK: - HeaderViewDelegate
extension AppDetailViewController: HeaderViewOfAppDetailDelegate {
    
    /// '펼치기' 또는 '접기' 버튼 터치 이벤트
    /// tableView delegate메서드에서 anyButton의 tag에 section 번호를 저장해 두었다.
    /// - Parameter sender: 버튼
    func touchAnyButton(_ sender: UIButton) {
        
        guard let sectionType = Section.init(rawValue: sender.tag) else { return }
        guard let row = self.sectionAndRow[sectionType] else { return }
        
        if true == row.isOpen {
            self.sectionAndRow[sectionType]!.isOpen = false
        } else {
            self.sectionAndRow[sectionType]!.isOpen = true
        }
        
        let indexSet = IndexSet(integer: IndexSet.Element(sender.tag))
        self.tableView.reloadSections(indexSet, with: .automatic)
    }
}
