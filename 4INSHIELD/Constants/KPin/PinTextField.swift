//
//  PinTextField.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 10/4/2023.
//

import UIKit

protocol OTPTextFieldDelegate {
    func OTPTextFieldDidPressBackspace(textfield: PinTextField)
}

class PinTextField: UITextField {

    var delegateOTP:OTPTextFieldDelegate!
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if delegateOTP != nil {
            delegateOTP.OTPTextFieldDidPressBackspace(textfield: self)
        }
    }
    
}
