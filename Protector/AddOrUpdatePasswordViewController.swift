//
//  AddOrUpdatePasswordViewController.swift
//  Protector
//
//  Created by BusranurOK on 14.10.2022.
//

import UIKit
import CoreData

class AddOrUpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var textfieldCategory: GmailFloating!
    @IBOutlet weak var textfieldSiteName: GmailFloating!
    @IBOutlet weak var textfieldMail: GmailFloating!
    @IBOutlet weak var textfieldPassword: GmailFloating!
    @IBOutlet weak var buttonAddOrUpdate: UIButton!
    @IBOutlet weak var imageViewLock: UIImageView!
    
    var pickerView: UIPickerView?
    
    var categories = [String]()
    
    // Veriler üzerinde işlemler yapmak için
    let managamentContext = appDelegate.persistentContainer.viewContext
    
    var informationsList = [Information]()
    
    // Diğer sayfadan veri almak için
    var information: Information?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .gray
        
        buttonAddOrUpdate.layer.cornerRadius = 30
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        let toolbar = UIToolbar()
        // Ekran boyutuna göre yayılması
        toolbar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(AddOrUpdatePasswordViewController.okClick))
        okButton.tintColor = UIColor(named: "AccentColor")
        
        let blankButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(self.cancelButton))
        cancelButton.tintColor = UIColor.red
        
        toolbar.setItems([cancelButton, blankButton, okButton], animated: true)
        
        // Textfield ile toolbar ı etkinleştirmek için:
        textfieldCategory.txtfld.inputAccessoryView = toolbar
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        
        imageViewLock.addGestureRecognizer(tapGestureRecognizer)
        imageViewLock.isUserInteractionEnabled = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        categories = ["Kategori Seçiniz","Banka","E-posta","Alışveriş","Diğer"]
        
        // Textfield' e tıkladığım zaman pickerview tetiklendi.
        textfieldCategory.txtfld.inputView = pickerView
        textfieldCategory.txtfld.text = categories[0]
        
        // Güncelleme işleminde verilerin dolu gelmesini sağladım
        if let information = information {
            
            textfieldCategory.txtfld.text = information.categoryName
            textfieldSiteName.txtfld.text = information.siteName
            textfieldMail.txtfld.text = information.username
            textfieldPassword.txtfld.text = information.password
            
            textfieldSiteName.textFieldDidBeginEditing(textfieldSiteName.txtfld)
            textfieldMail.textFieldDidBeginEditing(textfieldMail.txtfld)
            textfieldPassword.textFieldDidBeginEditing(textfieldPassword.txtfld)
            textfieldPassword.secureText = false
            
        }
        
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
    
    @objc func okClick() {
        
        view.endEditing(true)
        
    }
    
    @objc func cancelButton() {
        
        textfieldCategory.txtfld.text = categories[0]
        // Klavye vb. gibi yapıları kapatmak için kullandım.
        view.endEditing(true)
        
    }
    
    
    @IBAction func saveOrUpdatePassword(_ sender: Any) {
        
        // textfield' lar boş olduğunda ya da herhangi bir sıkıntı olduğunda if let yapısı bizi korur
        if let siteName = textfieldSiteName.txtfld.text, let categoryName = textfieldCategory.txtfld.text, let username = textfieldMail.txtfld.text, let password = textfieldPassword.txtfld.text {
            
            if siteName != "" && categoryName != "" && username != "" && password != "" {
                
                if textfieldCategory.txtfld.text == categories[0] {
                    
                    let alertController = UIAlertController.init(title: "", message: "Kategori boş geçilemez!", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction.init(title: "Tamam", style: .default, handler: nil)
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true)
                    
                    // Direkt fonksiyondan çıkacak, aşağıdaki kodu okumayacak
                    return
                    
                }
                
                // Güncelleme işlemi yaptım.
                if information != nil {
                    
                    information!.siteName = siteName
                    information!.categoryName = categoryName
                    information!.username = username
                    information!.password = password
                    
                }else {
                    
                    // Bu nesne ile veritabanına eriştim.
                    let newInformation = Information(context: managamentContext)
                    newInformation.siteName = siteName
                    newInformation.categoryName = categoryName
                    newInformation.username = username
                    newInformation.password = password
                    
                }
                
                // veritabanına kaydettim
                appDelegate.saveContext()
                
                let alertController = UIAlertController.init(title: "", message: "Kayıt işleminiz başarıyla gerçekleşmiştir.", preferredStyle: .alert)
                
                let okAction = UIAlertAction.init(title: "Tamam", style: .default) { action in
                    
                    self.textfieldCategory.txtfld.text = ""
                    self.textfieldSiteName.txtfld.text = ""
                    self.textfieldMail.txtfld.text = ""
                    self.textfieldPassword.txtfld.text = ""
                    
                    self.performSegue(withIdentifier: "goFromAddOrUpdateToHome", sender: nil)
                    
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true)
                
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
    
    func fetchAllInformation() {
        
        do {
            // Veritabanındaki bütün verileri aldım
            informationsList = try managamentContext.fetch(Information.fetchRequest())
            
        }catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    }
}

extension AddOrUpdatePasswordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categories.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categories[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        textfieldCategory.txtfld.text = categories[row]
        
    }
    
}
