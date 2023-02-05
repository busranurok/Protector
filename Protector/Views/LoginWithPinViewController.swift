//
//  LoginWithPinViewController.swift
//  Protector
//
//  Created by BusranurOK on 5.02.2023.
//

import UIKit

class LoginWithPinViewController: UIViewController {
    
    @IBOutlet weak var pinTextfield: UITextField!
    
    let managementContext = appDelegate.persistentContainer.viewContext
    
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPin()
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        if pinTextfield.text == "" {
            
            let alertController = UIAlertController.init(title: "", message: "Pin boş geçilemez!", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            
        }
        
        if pins.first!.pin == pinTextfield.text {
            
            let controller = storyboard?.instantiateViewController(identifier: "HomeNavigationView") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true)
            
        }else {
            
            let alertController = UIAlertController.init(title: "", message: "Girmiş olduğunuz pin yanlıştır.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            
        }
        
    }
    
    func fetchPin() {
        
        do {
            // Veritabanındaki bütün verileri aldım
            pins = try managementContext.fetch(Pin.fetchRequest())
            
        }catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    }
    
}
