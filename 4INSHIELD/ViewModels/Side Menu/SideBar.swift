//
//  SideBar.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 15/3/2023.
//

import UIKit

protocol SideBarDelegate: AnyObject {
    func selectedCell(_ row: Int)
    func changeLangage(langue: String)
}

import UIKit

class SideBar: UIViewController, UITableViewDelegate, UITableViewDataSource, SideBarDelegate {
 
    

    @IBOutlet weak var sideMenuTableView: UITableView!

    var delegate: SideBarDelegate?
    var defaultHighlightedCell: Int = 0
    let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
 
    let bonjourString = NSLocalizedString("hello", tableName: nil, bundle: Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main , value: "", comment: "Bonjour greeting")
//    var menufr = ["Paramétres", "Contactez-nous", "Mentions légales", "À propos de nous", "Aide & support", "Déconnexion"]
    var menufr = ["1", "2", "3 ", "4", "5", "6"]
    var menuang = ["7", "8", "9 ", "10", "11", "12"]
    var menuImages = ["param", "contact", "mention", "apropos", "aide", "deconnexion"]
    var langue = String()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: NSNotification.Name("NotificationFromB"), object: nil)
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.separatorStyle = .none
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
                 }
//        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        sideMenuTableView.register(UINib.init(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        sideMenuTableView.separatorStyle = .none
    }
    
    @objc func receiveNotification(_ notification: Notification) {
            if let message = notification.userInfo?["message"] as? String {
                // Gérer la notification venant de ViewControllerB
                print("Received notification: \(message)")
                print(message)
                langue = message
                menufr.removeAll()
                menuang.removeAll()
                menuImages.removeAll()
                sideMenuTableView.reloadData()
                menufr = ["1", "2", "3 ", "4", "5", "6"]
                menuang = ["7", "8", "9 ", "10", "11", "12"]
                menuImages = ["param", "contact", "mention", "apropos", "aide", "deconnexion"]
                sideMenuTableView.reloadData()

//                if message == "fr"{
//                    print("france")
//                    menu.removeAll()
//                    menu = ["Paramétres", "Contactez-nous", "Mentions légales", "À propos de nous", "Aide & support", "Déconnexion"]
////                    menuImages.removeAll()
////                     menuImages = ["param", "contact", "mention", "apropos", "aide", "deconnexion"]
//                    sideMenuTableView.reloadData()
//
//                }
//                else if message == "en"{
//                    print("anglais")
//                    menu.removeAll()
//                    menu = ["d", "dd-nous", "Mentions légales", "À propos de nous", "Aide & support", "Déconnexion"]
////                    menuImages.removeAll()
////                     menuImages = ["param", "contact", "mention", "apropos", "aide", "deconnexion"]
//
//                    sideMenuTableView.reloadData()
//                }
            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        print("sidebar")
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if langue == "fr"{
            return menufr.count
        }else if langue == "en"{
            return menuang.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        
        
//        let imageName = menuImages[indexPath.row]
//        let image = UIImage(named: imageName)

        cell.iconImage.image = UIImage(named: menuImages[indexPath.row])

        if langue == "fr"{
            cell.titleLabel.text = menufr[indexPath.row]
   
        }else
        if langue == "en"{
            cell.titleLabel.text = menuang[indexPath.row]
        }




        return cell
    }
   

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 { // If the first cell is selected
            showSubSideBarViewController()
        } else {
            self.delegate?.selectedCell(indexPath.row)
        }
    }

    // Show SubSideBarViewController

    func showSubSideBarViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let subSideBarViewController = storyboard.instantiateViewController(withIdentifier: "SubSideBarViewController") as? SubSideBarViewController {
            subSideBarViewController.delegate = self
            subSideBarViewController.preferredWidth = self.view.frame.width * 1.0 // Adjust the fraction as needed
            let subSidebarNav = UINavigationController(rootViewController: subSideBarViewController)
            subSidebarNav.modalPresentationStyle = .overCurrentContext
            present(subSidebarNav, animated: true, completion: nil)
        }
    }


    // MARK: - SideBarDelegate

    func selectedCell(_ row: Int) {
        // Handle the selected cell from SubSideBarViewController if needed
    }
    func changeLangage(langue: String) {
 
        
    }
}
