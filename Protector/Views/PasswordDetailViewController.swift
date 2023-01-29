//
//  PasswordDetailViewController.swift
//  Protector
//
//  Created by BusranurOK on 14.10.2022.
//

import UIKit

class PasswordDetailViewController: UIViewController {
    
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelSiteName: UILabel!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    
    // Diğer sayfadan veri almak için
    var information: Information?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .gray
        
        if let information = information {
            
            labelCategoryName.text = information.categoryName
            labelSiteName.text = information.siteName
            labelMail.text = information.username
            labelPassword.text = information.password
            
            
        }
        
    }
    
}
