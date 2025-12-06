//
//  UIFont.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 6/12/2568 BE.
//

import Foundation
import UIKit

enum FontFamily: String {
    case light = "Poppins-Light"
    case regular = "Poppins-Regular"
    case italic = "Poppins-Italic"
    case medium = "Poppins-Medium"
    case semibold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
    case extrabold = "Poppins-ExtraBold"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UIFont {
    // MARK: - Light
    
    // MARK: - Regular
    static var popR16: UIFont { FontFamily.regular.of(size: 16) }
    
    // MARK: - Italic
    
    // MARK: - Medium
    
    // MARK: - SemiBold
    
    // MARK: - Bold
    static var popB32: UIFont { FontFamily.bold.of(size: 32) }
    
    // MARK: - ExtraBold
    
    
}
