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
        case NewFunction = 1
        case PreView = 2
    }
    
    let responseData: Response
    //section과 row 개수
    var sectionAndRow: [Section: Int] = [:]
    
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

        // Do any additional setup after loading the view.
        print(responseData)
        setUI()
        configurationTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.backItem?.title = "검색"
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
//        tableView.contentInset = .init(top: -100, left: 0, bottom: 0, right: 0)
//        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = .init(frame: .zero)
        tableView.sectionFooterHeight = 0
        tableView.register(BriefInformationTableViewCell.self, forCellReuseIdentifier: BriefInformationTableViewCell.identifier)
        tableView.register(SummaryInformationTableViewCell.self, forCellReuseIdentifier: SummaryInformationTableViewCell.identifier)
        createSectionAndRow()
    }
    
    func createSectionAndRow() {
        self.sectionAndRow[.SummaryInfo] = 2
        self.sectionAndRow[.NewFunction] = 1
        self.sectionAndRow[.PreView] = 1
    }
}


extension AppDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionAndRow.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.init(rawValue: section) {
        case .SummaryInfo:
            return 2
        case .NewFunction:
            return 1
        case .PreView:
            return 1
        case .none:
            return 0
        }
    }
//https://apps.apple.com/kr/app/alphado-pet/id1551755698
    
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
        case .NewFunction: break
        case .PreView: break
        case .none: break
        }
        
        return resultCell ?? dummyCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.1, height: 0.1)))
        } else {
            let headerView = HeaderViewOfAppDetailTableView()
            headerView.titleLabel.text = "새로운 기능"
            headerView.anyButton.setTitle("버전 기록", for: .normal)
            return headerView
        }
    }
    
}

