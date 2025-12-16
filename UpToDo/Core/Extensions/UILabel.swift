//
//  UILabel.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation
import UIKit

extension UILabel {
    func setError(_ text: String) {
        self.isHidden = false
        self.text = text
    }
}
