//
//  OnboardingViewController.swift
//  Protector
//
//  Created by BusranurOK on 29.01.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides : [OnboardingSlide] = []
    var currentPage = 0 {
        
        didSet {
            
            pageControl.currentPage = currentPage
            
            if currentPage == slides.count - 1 {
                
                buttonNext.setTitle("Haydi Başla!", for: .normal)
                
            }else {
                
                buttonNext.setTitle("İleri", for: .normal)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        /*buttonNext.titleLabel?.font =  UIFont(name: "System", size: 20.0)
        buttonNext.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)*/
       
        slides = [
            OnboardingSlide(title: "Şifre unutma derdine son!", description: "Tek bir şifre ile tüm şifrelerinizi kaydedin.", image: UIImage(named: "password")!),
            OnboardingSlide(title: "Güvenliğinizi önemsiyoruz!", description: "Şifrelerinizi yalnızca sizin telefonunuzda tutuyor ve hiç kimse ile paylaşmıyoruz!", image: UIImage(named: "hacker")!),
            OnboardingSlide(title: "İstediğiniz şekilde paylaşma imkanı!", description: "İster mail, ister sms, ister farklı uygulamalar aracılığıyla şifrelerinizi dilediğiniz ile paylaşabilirsiniz.", image: UIImage(named: "send")!)
             ]
       
    }
    
    @IBAction func clickedNextButton(_ sender: Any) {
        
        buttonNext.titleLabel?.font =  UIFont(name: "System", size: 20.0)
        buttonNext.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        
        if currentPage == slides.count - 1 {
            
            let controller = storyboard?.instantiateViewController(identifier: "SignInNavigationController") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true)
            
        }else {
            
            currentPage += 1
            
            let indextPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indextPath, at: .centeredHorizontally, animated: true)
            
        }
       
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return slides.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
    }
    
}
