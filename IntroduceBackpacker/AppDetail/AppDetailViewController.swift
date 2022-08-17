//
//  AppDetailViewController.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import UIKit


/// section을 새롭게 추가하려면, 열거형 Section, SectionName에 등록하고, createSectionAndRow 메서드에서 row와 flod여부 등을 설정해야 한다. delegate 함수에서 headerView를 만드는 것도 잊지 말아야 함
/// row를 새롭게 추가하려면(section에는 적용되어 있다고 가정하고), 함수 configurationTableView에서 새로운 셀을 register하고, delegate 함수에서 적절한 section에 해당 셀을 만들어서 return해야 함
class AppDetailViewController: UIViewController {
    
    //section 순서 설정
    enum Section: Int {
        case SummaryInfo = 0
        case NewFeatures = 1
        case PreView = 2
        case IntroduceAndDeveloper = 3
        case OtherInformations = 4
    }
    
    //section header 이름 설정
    enum SectionName: String {
        case SummaryInfo
        case NewFeatures = "새로운 기능"
        case PreView = "미리보기"
        case IntroduceAndDeveloper
        case OtherInformations
    }
    
    typealias OtherData = OtherInformationTableViewCell.OtherInfoData
    
    //app data
    let responseData: Response
    //앱 소개글에서 더보기 버튼이 보일것인지 아닌지의 Bool값을 저장
    var isIntroduceMoreButton: Bool = true
    //기타정보의 더보기 버튼이 보일것인지 아닌지의 Bool값
    var isOtherInformationMoreButton: [IndexPath:Bool] = [:]
    
    //section정보
    typealias OpenAndFold = (open:Int, fold: Int, isOpen: Bool)
    var sectionAndRow: [Section: OpenAndFold] = [:]
    var sectionName: [Section: SectionName] = [:]
    
    //other information정보
    var otherInformationData: [(String, OtherData)] = []
    
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
        otherInformationDataConfiguration()
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
    
    
    //tableView를 셋팅한다.
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
        tableView.register(IntroduceTableViewCell.self, forCellReuseIdentifier: IntroduceTableViewCell.identifier)
//        tableView.register(OtherInformationTableViewCell.self, forCellReuseIdentifier: OtherInformationTableViewCell.identifier)
        tableView.register(OtherInformationTableViewCell.self, forCellReuseIdentifier: OtherInformationTableViewCell.identifier)
        
        //section 정보 생성
        createSectionAndRow()
    }
    
    
    func createSectionAndRow() {
        self.sectionAndRow[.SummaryInfo] = (open: 2, fold: 0, isOpen: true)
        self.sectionAndRow[.NewFeatures] = (open: 1, fold: 0, isOpen: false)
        if responseData.results[0].ipadScreenshotUrls.count > 0 {
            self.sectionAndRow[.PreView] = (open: 2, fold: 0, isOpen: false)
        } else {
            self.sectionAndRow[.PreView] = (open: 1, fold: 0, isOpen: false)
        }
        self.sectionAndRow[.IntroduceAndDeveloper] = (open: 1, fold: 0, isOpen: true)
        self.sectionAndRow[.OtherInformations] = (open: self.otherInformationData.count, fold: 0, isOpen: true)
        
        self.sectionName[.SummaryInfo] = .SummaryInfo
        self.sectionName[.NewFeatures] = .NewFeatures
        self.sectionName[.PreView] = .PreView
    }
    
    func otherInformationDataConfiguration() {
        var data: [(String, OtherData)] = []
        
        if false == responseData.results[0].trackContentRating.isEmptyWithNoSpaces() {
            data.append(("연령 등급", OtherData(summaryText: responseData.results[0].trackContentRating, detailText: "")))
        }
        if false == responseData.results[0].sellerName.isEmptyWithNoSpaces() {
            data.append(("제공자", OtherData(summaryText: responseData.results[0].sellerName, detailText: "")))
        }
        if false == responseData.results[0].fileSizeBytes.isEmptyWithNoSpaces() {
            if let bytes = Int64(responseData.results[0].fileSizeBytes) {
                data.append(("크기", OtherData(summaryText: Util.shared.convertBytes(bytes: bytes, toByteType: .MB), detailText: "")))
            } else {
                data.append(("크기", OtherData(summaryText: responseData.results[0].fileSizeBytes + " bytes", detailText: "")))
            }
            
        }
        if false == responseData.results[0].primaryGenreName.isEmptyWithNoSpaces() {
            data.append(("카테고리", OtherData(summaryText: responseData.results[0].primaryGenreName, detailText: "")))
        }
        if false == responseData.results[0].minimumOsVersion.isEmptyWithNoSpaces() {
            data.append(("호환성", OtherData(summaryText: responseData.results[0].minimumOsVersion, detailText: "")))
        }
        
        var summary = ""
        var detail = ""
        var languageCodesISO2A: Set<String> = []
        
        for code in responseData.results[0].languageCodesISO2A {
            _ = languageCodesISO2A.insert(code)
        }
        
        //데이터가 2개 보다 많으면 summary와 detail정보를 나누어서 저장한다.
        //summary example: 한국어 외 14개
        //detail example: 한국어, 독일어, 러시아어, ...
        if languageCodesISO2A.count > 2 {
            
            addFirstLanguageString(&summary, languageCodes: languageCodesISO2A)
            
            if false == summary.isEmptyWithNoSpaces() {
                
                if let appendedCodeInSummary = Language.getLanguageCode(summary) {
                    detail += summary
                    languageCodesISO2A.forEach { item in
                        if item.uppercased() != appendedCodeInSummary.rawValue.uppercased() {
                            detail += ", "
                            self.addLanguageStringAt(&detail, languageCode: item)
                        }
                    }
                } else {
                    languageCodesISO2A.enumerated().forEach { index, item in
                        self.addLanguageStringAt(&detail, languageCode: item)
                        detail += (index != languageCodesISO2A.count - 1) ? ", " : ""
                    }
                }
                summary += " 외 \(languageCodesISO2A.count - 1)개"
            }
            
        }
        //데이터가 2개 이하이면 summary에만 데이터를 저장한다.
        else {
            //첫번째 코드를 저장
            addFirstLanguageString(&summary, languageCodes: languageCodesISO2A)
            
            //첫번째 코드가 저장되었고, 데이터가 2개라면: 두번째 코드를 저장한다.
            //첫번째 코드가 저장되어 있지 않거나 데이터가 1개라면: 아무것도 하지 않는다.
            if false == summary.isEmptyWithNoSpaces() && languageCodesISO2A.count > 1 {
                summary += ", "
                
                let firstElement = languageCodesISO2A[languageCodesISO2A.startIndex]
                let secondElement = languageCodesISO2A[languageCodesISO2A.endIndex]
                
                if summary == firstElement {
                    addLanguageStringAt(&summary, languageCode: secondElement)
                } else {
                    addLanguageStringAt(&summary, languageCode: firstElement)
                }
            }
        }
        
        if false == summary.isEmptyWithNoSpaces() {
            data.append(("언어", OtherData(summaryText: summary, detailText: detail)))
        }
        
        self.otherInformationData = data
        
        data.enumerated().forEach { index, item in
            isOtherInformationMoreButton[IndexPath(row: index, section: Section.OtherInformations.rawValue)] = false
        }
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
                cell?.configuration(imageUrl: responseData.results[0].artworkUrl512,
                                    trackName: responseData.results[0].trackName,
                                    developerName: responseData.results[0].sellerName,
                                    imageHeight: appImageHeight,
                                    appStoreOpenUrlString: responseData.results[0].trackViewUrl)
                
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
            
            if 0 == indexPath.row {
                cell?.configuration(delegate: self, imageUrlStrings: responseData.results[0].screenshotUrls, deviceType: .iPhone)
            } else {
                cell?.configuration(delegate: self, imageUrlStrings: responseData.results[0].ipadScreenshotUrls, deviceType: .iPad)
            }
            
            resultCell = cell
            break
            
        case .IntroduceAndDeveloper:
                let cell = tableView.dequeueReusableCell(withIdentifier: IntroduceTableViewCell.identifier) as? IntroduceTableViewCell
                
                cell?.configuration(introduceText: responseData.results[0].description,
                                    indexPath: indexPath,
                                    isMoreButton: self.isIntroduceMoreButton,
                                    normalLine: 3)
                
                cell?.delegate = self
                resultCell = cell
            break
            
        case .OtherInformations:
            /*
             let cell = tableView.dequeueReusableCell(withIdentifier: OtherInformationTableViewCell.identifier) as? OtherInformationTableViewCell
             
             cell?.configuration(data)
             */
            
            let cell = tableView.dequeueReusableCell(withIdentifier: OtherInformationTableViewCell.identifier) as? OtherInformationTableViewCell
            
            cell?.delegate = self
            let data = self.otherInformationData[indexPath.row]
            cell?.configuration(indexPath, categoryText: data.0, data: data.1, isFold: self.isOtherInformationMoreButton[indexPath] ?? false)
            
            resultCell = cell
            break
            
        case .none: break
        }
        
        resultCell?.selectionStyle = .none
        return resultCell ?? dummyCell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let noneView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.1, height: 0.1)))
        
        
        if section == Section.SummaryInfo.rawValue || section == Section.IntroduceAndDeveloper.rawValue || section == Section.OtherInformations.rawValue{
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
    
    //with으로 들어온 String에 해당 언어코드(매개변수)를 {한국어}(추후 localization 가능)로 저장한다.
    //열거형에 언어코드(매개변수)에 해당하는 {한국어}가 없으면 그냥 언어코드로 저장한다.
    func addLanguageStringAt(_ with: inout String, languageCode: String) {
        if let language = Language.init(rawValue: languageCode.lowercased()) {
            let languageString = language.getLanguageString()
            with += languageString
        }
        else {
            with += languageCode.uppercased()
        }
    }
    
    
    func addFirstLanguageString(_ with: inout String, languageCodes: Set<String>) {
        
        //전달 된 languageCodes의 개수가 0보다 커야하고
        //languageCodes의 첫번째 코드가 빈 문자열이 아니어야 한다.
        guard let firstLanguageCode = languageCodes.first, false == firstLanguageCode.isEmptyWithNoSpaces() else {
            return
        }
        
        var deviceLanguageCode = Locale.preferredLanguages[0].uppercased()
        
        deviceLanguageCode = true == deviceLanguageCode.contains("-") ? deviceLanguageCode.components(separatedBy: "-").first! : deviceLanguageCode
        
        //데이터가 대문자로 온다고 가정했을 때 작동한다.
        if languageCodes.contains(deviceLanguageCode) {
            addLanguageStringAt(&with, languageCode: deviceLanguageCode)
            
        } else {
            //데이터가 소문자로 왔을 수도 있으니, 대문자로 바꿔서 다시 한번 확인한다.
            var languageCodes: [String] = []
            languageCodes.forEach { item in
                languageCodes.append(item.uppercased())
                
            }
            
            //데이터에 기기의 언어코드가 있다면 summary에 기기에 해당하는 언어를 {한국어}로 저장하고
            //기기의 언어코드가 없다면 첫번째 언어를 summary에 저장한다.
            if languageCodes.contains(deviceLanguageCode) {
                addLanguageStringAt(&with, languageCode: deviceLanguageCode)
                
            } else {
                addLanguageStringAt(&with, languageCode: firstLanguageCode.lowercased())
                
            }
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



//MARK: - PreviewImageDelegate
extension AppDetailViewController: PreviewImageDelegate {
    func tappedImageView(image: UIImage) {
        let storyboard = UIStoryboard(name: "ImageViewer", bundle: nil)
        
        let imageViewerVC = storyboard.instantiateViewController(identifier: "ImageViewer") { coder in
            ImageViewerViewController(image: image, coder: coder)
        }
        
        imageViewerVC.modalPresentationStyle = .fullScreen
        
        self.present(imageViewerVC, animated: true)
    }
    
}



//MARK: - IntroduceDelegate
extension AppDetailViewController: IntroduceDelegate {
    func tappedMoreButton(_ indexPath: IndexPath) {
        self.isIntroduceMoreButton = !self.isIntroduceMoreButton
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}



//MARK: - OtherInformationDelegate
extension AppDetailViewController: OtherInformationDelegate {
    func tappedOtherInformationMoreButton(_ indexPath: IndexPath) {
        guard let isOtherInformationMoreButton = self.isOtherInformationMoreButton[indexPath] else {
            return
        }
        self.isOtherInformationMoreButton[indexPath] = !isOtherInformationMoreButton
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
