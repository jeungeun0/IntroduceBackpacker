//
//  ViewController.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import UIKit

class SearchViewController: UIViewController {
    
    //APP_ID를 입력받을 TextField
    let appIDTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: textField.frame.height)))
        textField.leftViewMode = .always
        textField.placeholder = "App ID를 입력해주세요."
        textField.keyboardType = .numbersAndPunctuation
        //TODO: 제출 전 꼭 지우기
        textField.text = "544007664"
        return textField
    }()
    //검색 버튼
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    //APP_ID를 입력받을 TextField와 검색 버튼을 위치시킬 뷰
    let containerView: UIView = .init()
    //사용자에게 안내할 가이드 문구 라벨
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "※ 위의 입력 필드에 App ID를 입력하고 검색 버튼을 누르면 해당 앱 소개 페이지로 이동합니다."
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set UI
        setUI()
        
        //Set Gesture
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        view.addGestureRecognizer(tapGuesture)
        
        //Set Button Target
        searchButton.addTarget(self, action: #selector(selectedSearchButton(_:)), for: .touchUpInside)
        
        
        self.navigationController?.navigationBar.topItem?.title = "검색"
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    /// 화면에서 보이는 UI를 설정합니다.
    func setUI() {
        containerView.addSubview(appIDTextField)
        containerView.addSubview(searchButton)
        view.addSubview(containerView)
        view.addSubview(guideLabel)
        
        appIDTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = Util.shared.getSafeArea()
        let navigationHeight: CGFloat = self.navigationController?.navigationBar.frame.size.height ?? 0
        let screenWidth = UIScreen.main.bounds.size.width
        let containerHeight: CGFloat = 50
        let margin: CGFloat = 24
        
        NSLayoutConstraint.activate([appIDTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                                     appIDTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
                                     appIDTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                                     appIDTextField.widthAnchor.constraint(equalToConstant: screenWidth * 0.6),
                                    
                                     searchButton.leadingAnchor.constraint(equalTo: appIDTextField.trailingAnchor, constant: 10),
                                     searchButton.topAnchor.constraint(equalTo: containerView.topAnchor),
                                     searchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                                     searchButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                                     searchButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.3),
                                    
                                     containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeArea.top + navigationHeight + margin),
                                     containerView.heightAnchor.constraint(equalToConstant: containerHeight),
                                    
                                     guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
                                     guideLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: margin),
                                     guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)])
        
        guideLabel.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: margin).priority = UILayoutPriority(Float(250))
    }
    
    
    /// 화면을 Touch했을 때 키보드가 내려가도록 합니다.
    /// - Parameter gesture: tap gesture object
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @objc func selectedSearchButton(_ sender: UIButton) {
        
        guard let inputText = appIDTextField.text, inputText != "", inputText != " " else {
            let alert = Util.shared.getAlert(message: "입력 필드에 값을 입력하신 후,\n다시 시도해주세요.", okTitle: "확인")
            present(alert, animated: true)
            return
        }
//        print(inputText)
        requestGetAppInfomation(inputText)
    }
    
    var isCommunicating: Bool = false
    
    func requestGetAppInfomation(_ inputText: String) {
        guard false == isCommunicating else {
            let alert = Util.shared.getAlert(message: "앱 소개 데이터를 요청하는 중입니다.\n잠시 후 다시 시도해주세요.", okTitle: "확인")
            present(alert, animated: true)
            return
        }
        
        isCommunicating = true
        
        var urlComponent = URLComponents(string: "http://itunes.apple.com/lookup?")
        let queryItem = URLQueryItem(name: "id", value: inputText)
        urlComponent?.queryItems?.append(queryItem)
        
        API.shared.reqeust(urlComponent: urlComponent) { [weak self] error in
            var errorMessage: String = ""
            switch error {
            case .urlDoesntExist:
                errorMessage = "잘못된 App ID입니다.\n입력한 App ID를 다시 한번 확인 후 다시 시도해주세요."
            case .errorExist(let error):
                errorMessage = "죄송합니다.\n데이터 요청에 실패하였습니다.\n\n입력한 App ID를 다시 한번 확인 후 다시 시도해주세요.\n\n문제가 반복된다면, 개발자에게 문의해주세요.\n\n오류 상세: \(error.localizedDescription)\n\n개발자 이메일: \(Global.shared.developerEmail)"
            case .statusCodeNotGood(let statusCode):
                errorMessage = "죄송합니다.\n데이터 요청에 실패하였습니다.\n\n입력한 App ID를 다시 한번 확인 후 다시 시도해주세요.\n\n문제가 반복된다면, 개발자에게 문의해주세요.\n\n오류 코드: \(statusCode)\n\n개발자 이메일: \(Global.shared.developerEmail)"
            case .unowned:
                errorMessage = "죄송합니다.\n데이터 요청에 실패하였습니다.\n\n입력한 App ID를 다시 한번 확인 후 다시 시도해주세요.\n\n문제가 반복된다면, 개발자에게 문의해주세요.\n\n개발자 이메일: \(Global.shared.developerEmail)"
            case .dataNotAvailable:
                errorMessage = "죄송합니다.\n데이터 요청에 실패하였습니다.\n\n문제가 반복된다면, 개발자에게 문의해주세요.\n\n오류 상세: data is not available.\n\n개발자 이메일: \(Global.shared.developerEmail)"
            }
            
            let alert = Util.shared.getAlert(message: errorMessage, okTitle: "확인")
            self?.present(alert, animated: true)
            
        } completion: { [weak self] response in
            
            self?.isCommunicating = false
            do {
                let responseData = try JSONDecoder().decode(Response.self, from: response)
//                print("---Data : ---\n\(response)")
                //화면이동
                self?.routeToAppDetailViewController(data: responseData)
                
            } catch let error {
                print("---error : \(error.localizedDescription)---")
                let errorMessage = "죄송합니다.\n데이터 요청에 실패하였습니다.\n\n입력한 App ID를 다시 한번 확인 후 다시 시도해주세요.\n\n문제가 반복된다면, 개발자에게 문의해주세요.\n\n오류 상세: \(error.localizedDescription)\n\n개발자 이메일: \(Global.shared.developerEmail)"
                let alert = Util.shared.getAlert(message: errorMessage, okTitle: "확인")
                self?.present(alert, animated: true)
            }
        }
        
    }
    
    func routeToAppDetailViewController(data: Response) {
        DispatchQueue.main.async {
            guard let storyboard = self.storyboard, let navigationController = self.navigationController else {
                return
            }
            let appDetailViewController = storyboard.instantiateViewController(identifier: "AppDetailViewController") { coder in
                AppDetailViewController(responseData: data, coder: coder)
            }
            navigationController.show(appDetailViewController, sender: data)
        }
    }
    
}


