//
//  CustomTextField.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 31/12/23.
//

import UIKit

class CustomizedTextField: UITextField {
    
    let placeholderInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    let textInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
}
