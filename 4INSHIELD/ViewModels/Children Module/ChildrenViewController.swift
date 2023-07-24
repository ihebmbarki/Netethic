//
//  ChildrenViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 5/4/2023.
//

import UIKit
import Foundation

class ChildrenViewController: UIViewController {
    @IBOutlet weak var exitBtnLbl: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var changeLanguageBtn: UIButton!

    var childrenArray = [Child]()
    var decodedChildrenArray = [Childd]()
    var selectedChild: Childd?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        getCurrentUserChildren()
        configureTableView()
    }
    //MARK: Translation
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
            }
        }
    }
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)
        
        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
                }
                
                self.updateLocalizedStrings()
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)
        
        present(languageAlert, animated: true, completion: nil)
    }
    
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
        listLabel.text = NSLocalizedString("list_child_item", tableName: nil, bundle: bundle, value: "", comment: "children's list")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.getCurrentUserChildren()
            guard let userIDString = UserDefaults.standard.string(forKey: "userID"),
                  let userID = Int(userIDString) else {
                print("User ID not found")
                return
            }
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateString = df.string(from: date)
            
            let x = [
                "user": userID,
                "wizard_step": 6,
                "platform": "mobile",
                "date": dateString
            ] as [String : Any]
            let journey = UserJourney(dictionary: x)
            
            APIManager.shareInstance.saveUserJourney(journeyData: journey) { userJourney in
                print(userJourney)
            }
        }
    }
    
    func getCurrentUserChildren() {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        APIManager.shareInstance.fetchCurrentUserChildren(username: username) { children in
            self.decodedChildrenArray = children
            self.tableView.reloadData()
            self.verifyChildList(childrenList: children)
        }
    }
    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func verifyChildList(childrenList: [Childd]) {
        if childrenList.count > 0 {
            // Children list is not empty, do nothing.
        } else {
            let alertController = UIAlertController(title: "4INSHIELD", message: "Your children list is empty!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //register tableView Cell
    func configureTableView(){
        //        tableView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ChildTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildCell")
        tableView.separatorStyle = .none
    }
    
    
    @IBAction func infoBtnTapped(_ sender: Any) {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
        let message = NSLocalizedString("alert_message", tableName: nil, bundle: bundle, value: "", comment: "Alert message")
        let alertController = UIAlertController(title: "4INSHIELD", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

extension ChildrenViewController:  UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decodedChildrenArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath) as! ChildTableViewCell
        
        let child = decodedChildrenArray[indexPath.row]
        let user = child.user
        
        if let photo = user?.photo, !photo.isEmpty {
            cell.childAvatar.loadImage(photo)
        } else {
            if user?.gender == "M" {
                cell.childAvatar.image = UIImage(imageLiteralResourceName: "malePic")
            } else {
                cell.childAvatar.image = UIImage(imageLiteralResourceName: "femalePic")
            }
        }
        
        cell.childFullName.text = (user?.first_name.uppercased() ?? "") + " " + (user?.last_name.uppercased() ?? "")
        
        return cell
    }

    func goToScreen(withId identifier: String) {

          let storyboard = UIStoryboard(name: "Main", bundle: nil)

          let VC = storyboard.instantiateViewController(withIdentifier: identifier)
          navigationController?.pushViewController(VC, animated: true)

      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedChild = decodedChildrenArray[indexPath.row]
        UserDefaults.standard.set(selectedChild.id, forKey: "childID")
        
        // Go to dashboard
        self.goToScreen(withId: "TabBarController")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        if let homeNav = vc.viewControllers?.first as? UINavigationController,
            let homeVC = homeNav.viewControllers.first as? homeVC {
            homeVC.selectedChild = selectedChild
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let child = self.decodedChildrenArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            let user = self.selectedChild?.user
            let alert = UIAlertController(title: nil, message: "Are you sure, you want remove this child from your list?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes, sure", style: .destructive, handler: { _ in
                self.decodedChildrenArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                APIManager.shareInstance.deleteChild(withID: child.id)
                print("You have deleted element \(user?.first_name)")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel ,handler: { _ in self.tableView.reloadData()}))
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, handler) in
            UserDefaults.standard.set(child.id, forKey: "childID")
            print(child.id)

            let storyboard = UIStoryboard(name: "UpdateChild", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "updateChild") as? UpdateChild {
                // Set the selected child property in UpdateChildViewController
                vc.selectedChild = self.decodedChildrenArray[indexPath.row]

                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                print("Error: Failed to instantiate UpdateChildViewController.")
            }
        }

        
        updateAction.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        updateAction.backgroundColor = Colrs.default_color
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

extension UIButton {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        self.imageView?.anchor(top: top, left: left, bottom: bottom, right: right, paddingTop: paddingTop, paddingLeft: paddingLeft, paddingBottom: paddingBottom, paddingRight: paddingRight, width: width, height: height)
    }
}
