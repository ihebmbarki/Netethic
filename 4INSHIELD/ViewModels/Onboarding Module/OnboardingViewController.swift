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
    
    func goToScreen(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if currentPage == slides.count - 1 {
            // Proceed to wizard screen
            if let username = UserDefaults.standard.string(forKey: "username") {
                APIManager.shareInstance.getUserWizardStep(withUserName: username) { wizardStep in
                    print("Retrieved wizard step from server: \(String(describing: wizardStep))")
                    // Update the user defaults with the new wizard step value
                    UserDefaults.standard.set(wizardStep, forKey: "wizardStep")
                    if let wizardStep = UserDefaults.standard.object(forKey: "wizardStep") as? Int {
                        print("Retrieved wizard step from user defaults: \(wizardStep)")
                        switch wizardStep {
                        case 1:
                            self.goToScreen(withId: "childInfos")
                        case 2:
                            self.goToScreen(withId: "ChildSocialMedia")
                        case 3:
                            self.goToScreen(withId: "ChildProfileAdded")
                        case 4:
                            self.goToScreen(withId: "ChildDevice")
                        case 5:
                            self.goToScreen(withId: "Congrats")
                        default:
                            // The wizard step value is not set in the user defaults
                            // Redirect to the onboarding screen
                            self.goToScreen(withId: "OnboardingSB")
                        }
                    } else {
                        // The wizard step value is not set in the user defaults
                        // Redirect to the onboarding screen
                        self.goToScreen(withId: "OnboardingSB")
                    }
                }
                let onboardingSimple = UserDefaults.standard.bool(forKey: "onboardingSimple")
                if onboardingSimple == false, let username = UserDefaults.standard.string(forKey: "username") {
                    APIManager.shareInstance.setOnboardingSimpleTrue(forUsername: username) { result in
                        switch result {
                        case .success(let value):
                            print("Response: \(String(describing: value))")
                            // Update user default value for onboardingSimple to true
                            UserDefaults.standard.set(true, forKey: "onboardingSimple")
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
        }else {
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
