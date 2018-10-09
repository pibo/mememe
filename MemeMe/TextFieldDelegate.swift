//
//  UITextFieldDelegate.swift
//  MemeMe
//
//  Created by Felipe Ribeiro on 15/10/18.
//  Copyright © 2018 Felipe Ribeiro. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: Properties
    
    let defaultText: String
    
    // MARK: Initializer
    
    init(defaultText: String) {
        self.defaultText = defaultText
        super.init()
    }
    
    // MARK: Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == defaultText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = defaultText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
