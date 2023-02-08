//
//  LaunchScreen3ViewController.swift
//  Protector
//
//  Created by BusranurOK on 8.02.2023.
//

import UIKit

class LaunchScreen3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let delay : Double = 2.0    // 5 seconds here
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            let controller = self.storyboard?.instantiateViewController(identifier: "HomeNavigationView") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            self.present(controller, animated: true)
            
        }
    }

}
