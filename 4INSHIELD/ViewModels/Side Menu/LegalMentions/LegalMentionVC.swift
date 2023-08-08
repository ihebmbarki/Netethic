//
//  LegalMentionVC.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 26/7/2023.
//

import UIKit

class LegalMentionVC: UIViewController {

    @IBOutlet weak var expandButton1: UIButton!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var expandButton2: UIButton!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textViewHeightConstraint2: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton3: UIButton!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textViewHeightConstraint3: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton4: UIButton!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var textViewHeightConstraint4: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton5: UIButton!
    @IBOutlet weak var textView5: UITextView!
    @IBOutlet weak var textViewHeightConstraint5: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton6: UIButton!
    @IBOutlet weak var textView6: UITextView!
    @IBOutlet weak var textViewHeightConstraint6: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton7: UIButton!
    @IBOutlet weak var textView7: UITextView!
    @IBOutlet weak var textViewHeightConstraint7: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton8: UIButton!
    @IBOutlet weak var textView8: UITextView!
    @IBOutlet weak var textViewHeightConstraint8: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton9: UIButton!
    @IBOutlet weak var textView9: UITextView!
    @IBOutlet weak var textViewHeightConstraint9: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton10: UIButton!
    @IBOutlet weak var textView10: UITextView!
    @IBOutlet weak var textViewHeightConstraint10: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton11: UIButton!
    @IBOutlet weak var textView11: UITextView!
    @IBOutlet weak var textViewHeightConstraint11: NSLayoutConstraint!
    
    // Variables to hold the chevron images
    let chevronDownImage = UIImage(systemName: "chevron.down")
    let chevronUpImage = UIImage(systemName: "chevron.up")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDesign()
        
        // Create an array to hold the textViewHeightConstraint constants
         let textViewHeightConstraints: [NSLayoutConstraint] = [
             textViewHeightConstraint, textViewHeightConstraint2, textViewHeightConstraint3,
             textViewHeightConstraint4, textViewHeightConstraint5, textViewHeightConstraint6,
             textViewHeightConstraint7, textViewHeightConstraint8, textViewHeightConstraint9,
             textViewHeightConstraint10, textViewHeightConstraint11
         ]
         // Set all textViewHeightConstraint constants to 0 using a loop
         for constraint in textViewHeightConstraints {
             constraint.constant = 0
         }

    }
    
    func setUpDesign() {
        // Loop through the expandButtons and set the corner radius
        let expandButtons: [UIButton] = [
            expandButton1, expandButton2, expandButton3, expandButton4, expandButton5,
            expandButton6, expandButton7, expandButton8, expandButton9, expandButton10,
            expandButton11
        ]
        let cornerRadius: CGFloat = 5.0
        for button in expandButtons {
            button.layer.cornerRadius = cornerRadius
            button.clipsToBounds = true
        }
    }
  
    @IBAction func toggleTextView(_ sender: UIButton) {
        // Find the appropriate text view and height constraint based on the button tapped
        var textView: UITextView
        var heightConstraint: NSLayoutConstraint
        
        switch sender {
        case expandButton1:
            textView = textView1
            heightConstraint = textViewHeightConstraint
        case expandButton2:
            textView = textView2
            heightConstraint = textViewHeightConstraint2
        case expandButton3:
            textView = textView3
            heightConstraint = textViewHeightConstraint3
        case expandButton4:
            textView = textView4
            heightConstraint = textViewHeightConstraint4
        case expandButton5:
            textView = textView5
            heightConstraint = textViewHeightConstraint5
        case expandButton6:
            textView = textView6
            heightConstraint = textViewHeightConstraint6
        case expandButton7:
            textView = textView7
            heightConstraint = textViewHeightConstraint7
        case expandButton8:
            textView = textView8
            heightConstraint = textViewHeightConstraint8
        case expandButton9:
            textView = textView9
            heightConstraint = textViewHeightConstraint9
        case expandButton10:
            textView = textView10
            heightConstraint = textViewHeightConstraint10
        case expandButton11:
            textView = textView11
            heightConstraint = textViewHeightConstraint11
        default:
            return
        }
        
        // Toggle the visibility of the text view by changing its height constraint
        if heightConstraint.constant == 0 {
            // Expand the text view
            textView.sizeToFit() // Resize the text view to fit its content
            heightConstraint.constant = textView.contentSize.height // Set the height constraint to the content size
            sender.setImage(chevronUpImage, for: .normal) // Set the chevron up image
        } else {
            // Collapse the text view
            heightConstraint.constant = 0
            sender.setImage(chevronDownImage, for: .normal) // Set the chevron down image
        }
        
        // Animate the changes
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
