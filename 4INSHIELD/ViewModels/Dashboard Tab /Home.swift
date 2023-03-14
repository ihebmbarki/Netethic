//
//  Home.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 10/3/2023.
//

import UIKit
import SideMenu

class Home: UIViewController {
    
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn

        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)

        // Store the menu variable as a property of your view controller
        self.menu = menu

    }
    
    @IBAction func showSidebar(_ sender: Any) {
        guard let menu = menu else {
            return // Exit early if menu is nil
        }
        present(menu, animated: true)
    }
}

class MenuListController: UITableViewController {
    var items = ["Paramètres","Autorisation d’accés aux données","Nous contacter","Mentions légales","À propos","Déconnexion"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Set up header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        let backgroundImage = UIImageView(frame: headerView.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleToFill // Set content mode
        headerView.addSubview(backgroundImage)
        let logoImage = UIImageView(frame: CGRect(x: (headerView.frame.width - 100) / 2, y: 50, width: 100, height: 100))
        logoImage.image = UIImage(named: "4inshield logo blanc")
        logoImage.contentMode = .scaleToFill // Set content mode
        headerView.addSubview(logoImage)
        tableView.tableHeaderView = headerView

        // Set up footer view
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        let footerImage = UIImageView(frame: footerView.bounds)
        footerImage.image = UIImage(named: "footer")
        footerImage.contentMode = .scaleToFill // Set content mode
        footerView.addSubview(footerImage)
        let footerLabel = UILabel(frame: CGRect(x: 0, y: 10, width: tableView.frame.width, height: 30))
        footerLabel.text = "© 2023 All Rights Reserved Made by 4INDATA"
        footerLabel.textColor = .white
        footerLabel.textAlignment = .center
        footerLabel.backgroundColor = .blue // Set background color
        footerView.addSubview(footerLabel)
        tableView.tableFooterView = footerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 0.14, green: 0.20, blue: 0.33, alpha: 1.00)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //do something
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.tableHeaderView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.tableHeaderView?.frame.height ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.tableFooterView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.tableFooterView?.frame.height ?? 0
    }
}
