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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 145))
        tableView.tableHeaderView = headerView
        headerView.backgroundColor = UIColor(red: 0.12, green: 0.73, blue: 0.94, alpha: 1.00)

//        let backgroundImage = UIImage(named: "backgroundImage")
//        let backgroundImageView = UIImageView(image: backgroundImage)
//        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.addSubview(backgroundImageView)
//
//        NSLayoutConstraint.activate([
//            backgroundImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
//            backgroundImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
//            backgroundImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
//            backgroundImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
//        ])
        
        let logoImageView = UIImageView(image: UIImage(named: "4inshield logo blanc"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        
        tableView.tableHeaderView = headerView
        
        // Set up footer view
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        let footerImageView = UIImageView(image: UIImage(named: "footer"))
        footerImageView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(footerImageView)
        
//        NSLayoutConstraint.activate([
//            footerImageView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
//            footerImageView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
//            footerImageView.topAnchor.constraint(equalTo: footerView.topAnchor),
//            footerImageView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
//        ])
        
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
