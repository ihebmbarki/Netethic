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
    
    var menu = ["Paramètres","Contactez-nous","Mentions légales"," À propos de nous","Aide & support","Déconnexion"]
    var menuImages = ["param", "contact", "mention", "apropos", "aide", "deconnexion"]
    
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
            
            let imageName = menuImages[indexPath.row] // Get the corresponding image name
            let image = UIImage(named: imageName)
            
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 10, y: 10, width: 24, height: 24) // Customize the frame as needed
            cell.contentView.addSubview(imageView)
            
        
            let label = UILabel()
                    label.text = menu[indexPath.row]
                    label.textColor = UIColor(red: 0.14, green: 0.20, blue: 0.33, alpha: 1.00)
                    label.font = UIFont.boldSystemFont(ofSize: 14) // Set the font to bold
                    label.frame = CGRect(x: 40, y: 10, width: cell.contentView.bounds.width - 50, height: 24) // Customize the frame as needed
                    cell.contentView.addSubview(label)
                    
                    let separatorView = UIView(frame: CGRect(x: 0, y: cell.contentView.bounds.height - 1, width: cell.contentView.bounds.width, height: 1))
                    separatorView.backgroundColor = UIColor.white // Customize the separator color as needed
                    cell.contentView.addSubview(separatorView)
            
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            self.delegate?.selectedCell(indexPath.row)
            
        }
    }

