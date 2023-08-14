//
//  ToxicPersonCollectionViewCell.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 7/6/2023.
//

import UIKit

class ToxicPersonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardLogo: UIImageView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make the cardLogo circular with a white background
        //        let backgroundSize: CGFloat = max(cardLogo.bounds.width, cardLogo.bounds.height)
        //        cardLogo.backgroundColor = .white
        //        cardLogo.layer.cornerRadius = backgroundSize / 2
        //        cardLogo.clipsToBounds = true
        //        cardLogo.contentMode = .scaleAspectFit
        
    }
    func setData(text: String, image: String){
        self.cardTitle.text = text
        //        self.cardLogo.image = UIImage(data: image)
        
        var photoUrl = image
        // Concaténation de l'URL de base avec la partie de l'URL de la photo
        let fullPhotoUrl = BuildConfiguration.shared.WEBERVSER_BASE_URL + photoUrl
        print("URL complète : \(fullPhotoUrl)")
        
        if let url = URL(string: fullPhotoUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.cardLogo.image =  UIImage(data: data)
                        //                        imageView.contentMode = .scaleAspectFill
                        //                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        //                        imageView.layer.cornerRadius = imageView.frame.height / 2 // half of 36
                        //                        imageView.clipsToBounds = true
                    }
                }
            }
        }
    }
}
