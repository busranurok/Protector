//
//  SignUpViewController.swift
//  Protector
//
//  Created by BusranurOK on 14.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var textfieldMail: GmailFloating!
    @IBOutlet weak var textfieldPassword: GmailFloating!
    @IBOutlet weak var textfieldPasswordAgain: GmailFloating!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var imageViewLock1: UIImageView!
    @IBOutlet weak var imageViewLock2: UIImageView!
    
    let managementContext = appDelegate.persistentContainer.viewContext
    
    var usersList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSignUp.layer.cornerRadius = 30
        
        /*self.navigationItem.title = "Kayıt"
        
        // Renk paletindeki renklere daha yakın olması adına bu işlemi gerçekleştiriyoruz.
        //navigationController?.navigationBar.isTranslucent = true
        // Açıklama satırı ve yukarıdaki kısmı rengini değiştirdim
        //navigationController?.navigationBar.barStyle = .black
    
        
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .systemBlue
        //Küçük başlıkta başlık rengini değiştirdim.
        appearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.backItem?.title = " "
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence*/
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        fetchAllUser()
        
        if usersList.count > 0 {
            
            let user = usersList[0]
            textfieldMail.txtfld.text = user.mail
            textfieldMail.textFieldDidBeginEditing(textfieldMail.txtfld)
            
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imageViewLock1.addGestureRecognizer(tapGestureRecognizer)
        imageViewLock1.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.image2Tapped))
        imageViewLock2.addGestureRecognizer(tapGestureRecognizer2)
        imageViewLock2.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if let mail = textfieldMail.txtfld.text, let password = textfieldPassword.txtfld.text, let passwordAgain = textfieldPasswordAgain.txtfld.text {
            
            if mail != "" && password != "" && passwordAgain != "" {
                
                if password == passwordAgain {
                    
                    if usersList.count > 0 {
                        
                        // Güncelleme işlemi
                        usersList[0].mail = textfieldMail.txtfld.text
                        usersList[0].password = textfieldPassword.txtfld.text
                        
                    }else {
                        
                        // Insert işlemi
                        let user = User(context: managementContext)
                        user.mail = mail
                        user.password = password
                        
                    }
                    
                    appDelegate.saveContext()
                    
                    let alertController = UIAlertController.init(title: "", message: "Kayıt işleminiz başarıyla gerçekleşmiştir.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction.init(title: "Tamam", style: .default) { action in
                        
                        self.textfieldMail.txtfld.text = ""
                        self.textfieldPassword.txtfld.text = ""
                        self.textfieldPasswordAgain.txtfld.text = ""
                        
                        self.performSegue(withIdentifier: "goFromSignUpToSignIn", sender: nil)
                        
                    }
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true)
                    
                }else {
                    
                    let alertController = UIAlertController.init(title: "", message: "Girdiğiniz şifreler uyuşmuyor.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction.init(title: "Tamam", style: .default) { action in
                        
                        self.textfieldPassword.txtfld.text = ""
                        self.textfieldPasswordAgain.txtfld.text = ""
                        
                    }
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true)
                    
                }
                
            }else {
                
                let alertController = UIAlertController.init(title: "", message: "Alanlar boş geçilemez!", preferredStyle: .alert)
                
                let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true)
                
            }
            
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
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        
        if let textfieldPassword = textfieldPassword.txtfld.text {
            
            if textfieldPassword != "" {
                
                if sender.state == .ended {
                    
                    // Aşağıdaki kod ile aynı anlama gelir.
                    /*if textfieldPassword.secureText {
                     
                     textfieldPassword.secureText = false
                     
                     }else {
                     
                     textfieldPassword.secureText = true
                     
                     }*/
                    
                    self.textfieldPassword.secureText = !self.textfieldPassword.secureText
                    
                }
                
            }
            
        }
        
    }
    
    @objc func image2Tapped(sender: UITapGestureRecognizer) {
        
        if let textfieldPasswordAgain = textfieldPassword.txtfld.text {
            
            if textfieldPasswordAgain != "" {
                
                if sender.state == .ended {
                    
                    // Aşağıdaki kod ile aynı anlama gelir.
                    /*if textfieldPassword.secureText {
                     
                     textfieldPassword.secureText = false
                     
                     }else {
                     
                     textfieldPassword.secureText = true
                     
                     }*/
                    
                    self.textfieldPasswordAgain.secureText = !self.textfieldPasswordAgain.secureText
                    
                }
                
            }
            
        }
        
    }
    
    func fetchAllUser() {
        
        do {
            // Veritabanındaki bütün verileri aldım
            usersList = try managementContext.fetch(User.fetchRequest())
            
        }catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    }
}
