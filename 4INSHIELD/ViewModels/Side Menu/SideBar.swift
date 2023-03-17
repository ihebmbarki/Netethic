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

class SideBar: UIViewController {
    
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    var delegate: SideBarDelegate?
    var defaultHighlightedCell: Int = 0
    
    var menu = ["Paramètres","Autorisation d’accés","Nous contacter","Mentions légales","À propos","Déconnexion"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.separatorStyle = .none
        
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
}

// MARK: - UITableViewDelegate
extension SideBar: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension SideBar: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = menu[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 0.14, green: 0.20, blue: 0.33, alpha: 1.00)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.selectedCell(indexPath.row)
        
    }
}
