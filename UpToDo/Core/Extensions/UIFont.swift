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
    
    func of(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
        let customFont = UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        let fontMetrics = UIFontMetrics(forTextStyle: style)
        return fontMetrics.scaledFont(for: customFont)
    }
}

extension UIFont {
    // MARK: - Light
    
    // MARK: - Regular
    static var popR16: UIFont { FontFamily.regular.of(size: 16) }
    static var popR13: UIFont { FontFamily.regular.of(size: 13) }
    
    // MARK: - Italic
    
    // MARK: - Medium
    
    // MARK: - SemiBold
    
    // MARK: - Bold
    static var popB32: UIFont { FontFamily.bold.of(size: 32) }
    
    // MARK: - ExtraBold
    
    
}
