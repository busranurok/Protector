//
//  ViewController.swift
//  Protector
//
//  Created by BusranurOK on 14.10.2022.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    // Kullanıcı giriş bilgilerini depolamak için kullanıyorum.
    let userDefault = UserDefaults.standard
    
    let managementContext = appDelegate.persistentContainer.viewContext
    
    var usersList = [User]()
    
    @IBOutlet weak var viewSignIn: UIView!
    @IBOutlet weak var textfieldMail: GmailFloating!
    @IBOutlet weak var textfieldPassword: GmailFloating!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonUserInformation: UIButton!
    @IBOutlet weak var labelDoNotHaveAnAccount: UILabel!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var imageviewLock: UIImageView!
    
    var centerXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textfieldPassword.myDelegate = self
        //textfieldMail.myDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        buttonSignIn.layer.cornerRadius = 30
        
        // Veri okuma işlemi
        let mail = userDefault.string(forKey: "Mail") ?? "Empty"
        let password = userDefault.string(forKey: "Password") ?? "Empty"
        
        if mail != "Empty" && password != "Empty" {
            
            performSegue(withIdentifier: "goFromSignInToHome", sender: nil)
            
        }else {
            
            fetchAllUser()
            
            if usersList.count > 0 {
                
                buttonUserInformation.isHidden = false
                labelDoNotHaveAnAccount.isHidden = true
                buttonSignUp.isHidden = true
                
            }else{
                
                buttonUserInformation.isHidden = true
                labelDoNotHaveAnAccount.isHidden = false
                buttonSignUp.isHidden = false
                
            }
            
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imageviewLock.addGestureRecognizer(tapGestureRecognizer)
        imageviewLock.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        if let mail = textfieldMail.txtfld.text, let password = textfieldPassword.txtfld.text {
            
            if mail != "" && password != "" {
                
                fetchAllUser()
                
                if usersList.count == 0 {
                    
                    let alertController = UIAlertController.init(title: "", message: "Sistemde kayıtlı herhangi bir kullanıcı bulunamamıştır.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
                    
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                    return
                    
                }
                
                if mail == usersList[0].mail && password == usersList[0].password {
                    
                    // Userdefauls a veri kaydı gerçekleştirdim.
                    userDefault.set(mail, forKey: "Mail")
                    userDefault.set(password, forKey: "Password")
                    
                    // Seque' yi aktif edecek kottur.
                    // Storyboard da genel geçiş gerçekleştirdim.
                    // Yani butona basıldığında değil de belirli koşullar dahilinde sayfa değişsin dedim.
                    // Sender ile de veri gönderme işlemi gerçekleştiririz.
                    performSegue(withIdentifier: "goFromSignInToHome", sender: nil)
                    
                }else {
                    
                    let alertController = UIAlertController.init(title: "", message: "E-posta(Kullanıcı adı) ya da şifre yanlıştır.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
                    
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                }
                
            }else {
                
                let alertController = UIAlertController.init(title: "", message: "Alanlar boş geçilemez!", preferredStyle: .alert)
                
                let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true)
                
            }
            
        }else {
            
            let alertController = UIAlertController.init(title: "", message: "Alanlar boş geçilemez!", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            
        }
        
    }
    
    // Sign In butonuna tıklandığı zaman önce performseque metodu çalışacak. O da prepare metodunu tetikleyecek.
    // Prepare metodunu geçiş öncesi verilerin hazırlanma süreci olarak da düşünebiliriz.
    // Prepare metodu çalıştıktan sonra da geçiş gerçekleşir.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //print("Sign In sayfasından Home sayfasına geçiş işlemi")
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        //print("\(usersList[0].mail) , \(usersList[0].password)")
        performSegue(withIdentifier: "goFromSignInToSignUp", sender: nil)
        
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
    
    // Textfield lara tıklandığında içerideki view ın hareket etmesini sağlamak amacı ile protocol çalışması
    func scrollUpContent() {
        
        /*centerXConstraint = viewSignIn.bottomAnchor.constraint(equalTo: super.view.bottomAnchor, constant: -200)
         centerXConstraint.isActive = true*/
        
    }
    
    func scrollDownContent() {
        
        /*centerXConstraint = viewSignIn.bottomAnchor.constraint(equalTo: super.view.topAnchor, constant: 600)
         centerXConstraint.isActive = true*/
        
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
        scrollDownContent()
        
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

extension SignInViewController : childViewControllerOneDelegate {
    
    func lostFocusTextField() {
        
        scrollDownContent()
        
    }
    
    func focusedTextField() {
        
        scrollUpContent()
        
    }
    
}


