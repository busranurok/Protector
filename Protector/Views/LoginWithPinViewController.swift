//
//  LoginWithPinViewController.swift
//  Protector
//
//  Created by BusranurOK on 5.02.2023.
//

import UIKit

class LoginWithPinViewController: UIViewController {
    
    @IBOutlet weak var pinTextfield: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    let managementContext = appDelegate.persistentContainer.viewContext
    
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .gray
        
        signInButton.layer.cornerRadius = 30
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)

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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
                
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            
            self.view.frame.origin.y = 0
        }
        
    }
    
    @objc func hideKeyboard() {
        
        view.endEditing(true)
        
    }
    
}
