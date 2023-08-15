//
//  SideBar.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 15/3/2023.
//

import UIKit

protocol SideBarDelegate {
    func selectedCell(_ row: Int)
}

import UIKit

class SideBar: UIViewController, UITableViewDelegate, UITableViewDataSource, SideBarDelegate {

    @IBOutlet weak var sideMenuTableView: UITableView!

    var delegate: SideBarDelegate?
    var defaultHighlightedCell: Int = 0
    let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
 
    let bonjourString = NSLocalizedString("hello", tableName: nil, bundle: Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main , value: "", comment: "Bonjour greeting")
    
    var menu = ["Paramétres", "Contactez-nous", "Mentions légales", "À propos de nous", "Aide & support", "Déconnexion"]
    var menuImages = ["param", "contact", "mention", "apropos", "aide", "deconnexion"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
      
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.separatorStyle = .none

        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let imageName = menuImages[indexPath.row]
        let image = UIImage(named: imageName)

        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10, y: 10, width: 24, height: 24)
        cell.contentView.addSubview(imageView)

        let label = UILabel()
        label.text = menu[indexPath.row]
        label.textColor = UIColor(red: 0.14, green: 0.20, blue: 0.33, alpha: 1.00)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.frame = CGRect(x: 40, y: 10, width: cell.contentView.bounds.width - 50, height: 24)
        cell.contentView.addSubview(label)

        let separatorView = UIView(frame: CGRect(x: 0, y: cell.contentView.bounds.height - 1, width: cell.contentView.bounds.width, height: 1))
        separatorView.backgroundColor = UIColor.white
        cell.contentView.addSubview(separatorView)

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
}
