//
//  PinViewController.swift
//  Protector
//
//  Created by BusranurOK on 31.01.2023.
//

import UIKit
import CHIOTPField
import CoreData

class PinViewController: UIViewController {
    
    @IBOutlet weak var pinTextfield: UITextField!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    let userDefault = UserDefaults.standard
    
    let managementContext = appDelegate.persistentContainer.viewContext
    
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .gray
        
        // ileri sayfalarından sonra pin ekranı geliyordu. O yüzden burada tanımlamıştım.
        //userDefault.set("true", forKey: "isPinCreated")
        
        fetchPin()
        
        if pins.count == 0 || pins.first?.pin == nil || pins.first?.pin == "" {
            
            signInButton.setTitle("Pin Oluştur", for: .normal)
            
        }else {
            
            signInButton.setTitle("Pin Güncelle", for: .normal)
            
        }
        
        self.privacyPolicyLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnLabel))
        tapGestureRecognizer3.numberOfTapsRequired = 1
        self.privacyPolicyLabel.addGestureRecognizer(tapGestureRecognizer3)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        if pins.count == 0 || pins.first?.pin == nil || pins.first?.pin == "" {
            
            if pinTextfield.text == "" {
                
                let alertController = UIAlertController.init(title: "", message: "Pin boş geçilemez!", preferredStyle: .alert)
                
                let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true)
                
            }
            
            // DB de kayıtlı bir pin yok, yeni pin oluşturulacak!
            // Insert işlemi
            let newPin = Pin(context: managementContext)
            newPin.pin = pinTextfield.text
            
            appDelegate.saveContext()
            
            userDefault.set("pinProtection", forKey: "firstPageState")
            
            pinTextfield.text = String(repeating: " ", count: 4)
            pinTextfield.text = ""
            
            let alertController = UIAlertController.init(title: "", message: "Girmiş olduğunuz pin başarıyla kaydedilmiştir.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Tamam", style: .default) { action in

                self.performSegue(withIdentifier: "goFromPinDetailToHome", sender: nil)
                
            }
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            
        }else {
            
            // DB de kayıtlı bir pin var kullanıcının girmiş olduğu pin ile DB deki kıyaslanacak!
            /*if pins.first!.pin == pinTextfield.text {
                
                performSegue(withIdentifier: "goFromSignInToHome", sender: nil)
                
            }else {
                
                let alertController = UIAlertController.init(title: "", message: "Girmiş olduğunuz pin yanlıştır.", preferredStyle: .alert)
                
                let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true)
                
            }*/
            
            pins.first?.pin = pinTextfield.text
            appDelegate.saveContext()
            
            let alertController = UIAlertController.init(title: "", message: "Girmiş olduğunuz pin başarıyla güncellenmiştir.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Tamam", style: .default) { action in

                self.performSegue(withIdentifier: "goFromPinDetailToHome", sender: nil)
                
            }
            
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
    
    // MARK: - tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        
        let urlString = "https://vakt-ihazar.com/gizliliksozlesmesiprotector.html"
        let url = URL(string: urlString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
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
