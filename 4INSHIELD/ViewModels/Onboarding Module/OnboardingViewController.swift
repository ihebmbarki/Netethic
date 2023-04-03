//
//  OnboardingViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 31/3/2023.
//
import Foundation
import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var onboardingView: UICollectionView!
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("C'est parti !", for: .normal)
            } else {
                nextBtn.setTitle("Suivant", for: .normal)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateScrollView()

        nextBtn.applyGradient()
        // Do any additional setup after loading the view.
    }

    func populateScrollView() {
        slides = [
            OnboardingSlide(title: "Protégez vos enfants en ligne", description: "4INSHIELD vous garantie que l’activité en ligne de vos enfants soit sereine et sans danger",bgimage: #imageLiteral(resourceName: "Ellipse 174") , image: #imageLiteral(resourceName: "image 8")),
            OnboardingSlide(title: "Choisissez votre niveau d’engagement", description: "4INSHIELD vous permet d’être alerté sur la publication des messages haineux et toxiques sur les réseaux sociaux de vos enfants",bgimage: #imageLiteral(resourceName: "Ellipse 174"), image: #imageLiteral(resourceName: "image 8")),
            OnboardingSlide(title: "Développez de bonnes habitudes numériques", description: "4INSHIELD aide à vos enfants à développer une relation responsable à la technologie", bgimage: #imageLiteral(resourceName: "Ellipse 174"), image: #imageLiteral(resourceName: "image 9"))
        ]
        
        pageControl.numberOfPages = slides.count
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if currentPage == slides.count - 1 {
            UserDefaults.standard.hasOnboarded = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "childInfos")
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()

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

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
