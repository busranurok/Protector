//
//  HomeViewController.swift
//  Protector
//
//  Created by BusranurOK on 14.10.2022.
//

import UIKit
import CoreData
import MessageUI

// Veritabanına eriştim
let appDelegate = UIApplication.shared.delegate as! AppDelegate

class HomeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var passwordsTableView: UITableView!
    
    // Veritabanına veri kayıt işlemlerini gerçekleştirdim
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let userDefault = UserDefaults.standard
    
    var informationsList = [Information]()
    
    var isSearchBarWorking = false
    var searchingWord: String?
    var scopeButtonClicked: Bool = false
    
    var imagesList: [String: String] = ["Banka": "bank-icon", "E-posta":"mail-icon","Alışveriş":"shopping-icon","Diğer":"other-icon"]
    
    var scopeList : [String] = ["Hepsi","Banka","E-Posta","Alışveriş","Diğer"]
    
    var informationString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        passwordsTableView.delegate = self
        // Metodlarına erişim
        passwordsTableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        
        //let mail = userDefault.string(forKey: "Mail") ?? "Empty"
        //navigationItem.title = "Selam \(mail)"
        
        let userDefault = UserDefaults.standard
        let firstPageState = userDefault.string(forKey: "firstPageState") ?? "Empty"
        
        if firstPageState == "Empty" {
            
            userDefault.set("launchScreenPresented", forKey: "firstPageState")
            
        }
        
    }
    
    // Sayfalar arası geçişte geri döndüğümde arayüz yebilenebilmesi için viewWillAppear metodu çalışır. viewDidLoad metodu sadece 1 defa çalışır.
    // Kayıt etme işlemini yaparız fakat bu kayıt etmeden sonra tüm verileri getir dediğimiz yer viewdidload olur ise ekranda verileri göremeyiz.
    // Bu yüzden bütün verileri getir fonksiyonunu viewWillAppear metodunun içerisinde çağırmam gerekir.
    // Ayrıca network başlatma gibi işlemlerimizi de bunun içerisinde gerçekleştiririz.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBlue
        
        if isSearchBarWorking {
            
            doSearchWithSiteName(siteName: searchingWord!)
            
        }else {
            
            // Uygulama ilk açıldığında çalışır
            fetchAllInformation()
            
        }
        
        // ViewDidload gibi arayüz oluşturma işlemlerinde sadece 1 defa çalışır.
        // Bunu dedikten sonra tableview metodlarını tekrar çalıştırıyor ve arayüz güncelleniyor.
        passwordsTableView.reloadData()
        
    }
    
    // performseque bu metodu tetikler.
    // Bir sayfadan birden fazla seque olduğu için, sayfa geçişlerinde bunu kontrol ettim
    // ve her geçişte parametre olarak indexpath.row gönderiliyor.
    // Önce gelecek indeks i aldım
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        let indeks = sender as? Int
        
        if segue.identifier == "goFromHomeToPasswordDetail" {
            
            let destinationViewController = segue.destination as! PasswordDetailViewController
            destinationViewController.information = informationsList[indeks!]
            
        }
        
        // Güncelle butonuna bastığım zaman indeks' in nil gelmemesi gerekiyor.
        // Çünkü tableviewcell inden veri gidiyor.
        // Ama  + butonuna bastığımda nil gelmesi gerekiyor.
        if segue.identifier == "goFromHomeToAddOrUpdate" && indeks != nil {
            
            let destinationViewController = segue.destination as! AddOrUpdatePasswordViewController
            destinationViewController.information = informationsList[indeks!]
            
        }
        
    }
    
    @IBAction func sendWithMail(_ sender: Any) {
        
        let firstActivityItem = "Protector şifrelerim"
        informationString = ""
        
        for information in informationsList {
            
            informationString += "Site Adınız: \(information.siteName!)\nKullanıcı Adınız(Ya da E-postanız): \(information.username!)\nŞifreniz: \(information.password!)\n\n"
            
        }
        
        let secondActivityItem = informationString
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Hariç tutmak istediklerimi yazdım.
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func openPinScreen(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goFromHomeToPin", sender: nil)
        
    }
    
    //@IBAction func exitApp(_ sender: Any) {
        
        /*let alertController = UIAlertController.init(title: "", message: "Çıkmak istediğinizden emin misiniz?", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction.init(title: "Evet", style: .destructive) { action in
            
            //self.userDefault.removeObject(forKey: "Mail")
            //self.userDefault.removeObject(forKey: "Password")
            
            exit(-1)
            
        }
        
        let cancelAction = UIAlertAction.init(title: "Vazgeç", style: .cancel) { action in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)*/
        
    //}
    
    func fetchAllInformation() {
        
        do {
            // Veritabanındaki bütün verileri aldım
            informationsList = try managedContext.fetch(Information.fetchRequest())
            
        }catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    }
    
    func doSearchWithSiteName(siteName: String) {
        
        informationsList = informationsList.filter({$0.siteName!.lowercased().contains(siteName.lowercased())
            
        })
        
        passwordsTableView.reloadData()
        
    }
    
    func doSearchWithCategoryName(categoryName: String) {
        
        informationsList = informationsList.filter({$0.categoryName!.lowercased().contains(categoryName.lowercased())
            
        })
        
        passwordsTableView.reloadData()
        
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Kaç bölüm olacağını belirttim
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    // Kaç tane veri olacağını belirttim
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return informationsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Userlistesinin içerisindeki veriyi aldım
        let information = informationsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordRow", for: indexPath) as! PasswordRowTableViewCell
        
        cell.labelCategoryName.text = information.categoryName
        cell.labelSiteName.text = information.siteName
        
        let imageName = imagesList[information.categoryName!]
        cell.imageViewCategoryImage.image = UIImage(named: imageName!)
        cell.imageView?.layer.borderWidth = 5
        cell.imageView?.layer.borderColor = CGColor(red: 10, green: 40, blue: 70, alpha: 1)
        cell.layer.masksToBounds = true
        
        return cell
        
    }
    
    // Satır seçildiğinde yapılacak işlemler
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "goFromHomeToPasswordDetail", sender: indexPath.row)
        
    }
    
    // Satırı sağdan kaydırdığımızda yapılacak işlemler
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { contextualAction, view, boolValue in
            
            let alertController = UIAlertController.init(title: "", message: "Silmek istediğinizden emin misiniz?", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction.init(title: "Sil", style: .destructive) { action in
                
                // Hangi satırı sileceğimi ele aldım
                let information = self.informationsList[indexPath.row]
                // Aldığım satırı sildim
                self.managedContext.delete(information)
                // Veritabanını kaydettim
                appDelegate.saveContext()
                
                // Silme işlemini arayüzde güncelleyebilmek için:
                if self.isSearchBarWorking {
                    
                    self.doSearchWithSiteName(siteName: self.searchingWord!)
                    
                }else {
                    
                    // Uygulama ilk açıldığında çalışır
                    self.fetchAllInformation()
                    
                }
                
                self.passwordsTableView.reloadData()
                
            }
            
            let cancelAction = UIAlertAction.init(title: "Vazgeç", style: .cancel) { action in
                
                self.passwordsTableView.reloadData()
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
            
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "Güncelle") { contextualAction, view, boolValue in
            
            self.performSegue(withIdentifier: "goFromHomeToAddOrUpdate", sender: indexPath.row)
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchingWord =  searchText
        
        // arama işlemi yaptığımda ekran arayüzünü güncellemek istediğimde bu kodlar çalışacaktır
        if searchText == "" {
            
            isSearchBarWorking = false
            fetchAllInformation()
            
        }else {
            
            isSearchBarWorking = true
            // Burada veriyi aldım.
            doSearchWithSiteName(siteName: searchingWord!)
            
        }
        
        // Veriyi aldıktan sonra arayüzü güncelledim.
        passwordsTableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        fetchAllInformation()
        
        if(selectedScope != 0){
            
            let selectedCategory = scopeList[selectedScope]
            
            doSearchWithCategoryName(categoryName: selectedCategory)
            
        }
        
        passwordsTableView.reloadData()
        
    }
    
}
