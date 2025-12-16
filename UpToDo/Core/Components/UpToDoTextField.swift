//
//  UpToDoTextField.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 13/12/2568 BE.
//

import UIKit

@IBDesignable
final class UpToDoTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
    
    let textInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
