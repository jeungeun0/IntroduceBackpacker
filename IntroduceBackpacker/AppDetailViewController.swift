//
//  AppDetailViewController.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import UIKit

class AppDetailViewController: UIViewController {
    
    let responseData: Response
    let tableView: UITableView = {
       let tableView = UITableView()
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
        tableView.register(BriefInformationTableViewCell.self, forCellReuseIdentifier: BriefInformationTableViewCell.identifier)
        tableView.register(SummaryInformationTableViewCell.self, forCellReuseIdentifier: SummaryInformationTableViewCell.identifier)
    }
}


extension AppDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
//https://apps.apple.com/kr/app/alphado-pet/id1551755698
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dummyCell = UITableViewCell()
        var resultCell: UITableViewCell?
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BriefInformationTableViewCell.identifier) as? BriefInformationTableViewCell
            let appImageHeight = UIScreen.main.bounds.size.width * 0.3
            cell?.configuration(imageUrl: responseData.results[0].artworkUrl512, trackName: responseData.results[0].trackName, trackId: responseData.results[0].trackId, developerName: responseData.results[0].sellerName, imageHeight: appImageHeight)
            
            resultCell = cell
        } else if indexPath.row == 1 {
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
        
        return resultCell ?? dummyCell
    }
}

