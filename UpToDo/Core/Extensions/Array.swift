//
//  Array.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 13/12/2568 BE.
//

import Foundation
import UIKit

extension Array where Element == UIButton {
    func addBorderWithCorner(color: UIColor = .primary, width: CGFloat = 1.0, cornerRaidus: CGFloat = 8.0) {
        self.forEach { button in
            button.layer.borderColor = color.cgColor
            button.layer.borderWidth = width
            button.layer.cornerRadius = cornerRaidus
        }
    }
}

extension Array where Element == UILabel {
    func makeAdjustableFont() {
        self.forEach { label in
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    func setFonts(_ font: UIFont) {
        self.forEach { label in
            label.font = font
        }
    }
}
