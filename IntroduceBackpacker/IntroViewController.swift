//
//  IntroViewController.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "MainNavigation")
//
//        UIApplication.shared.windows.first?.rootViewController = viewController
//        guard let firstWindow = UIApplication.shared.windows.first else { return }
//        UIView.transition(with: firstWindow, duration: 0.3, options: .transitionCrossDissolve) { } completion: { isCompleted in
//            if isCompleted == true {
//                self.dismiss(animated: false)
//            }
//        }
        
        changeRootViewController()
    }
    
    deinit {
        print("Intro ViewController 없어짐...")
    }
    
    
    func changeRootViewController() {
        guard let storyboard = self.storyboard else { return }
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigation") as? UINavigationController else { return }
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
