//
//  Storyboarded.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation
import UIKit

protocol Storyboarded: AnyObject {
    static func instantiate(bundle: Bundle) -> Self
}

extension Storyboarded {
    static func instantiate(bundle: Bundle = .main) -> Self {
        let identifier: String = String(describing: self)
        let storyboard = UIStoryboard(
            name: identifier.replacingOccurrences(of: "VC", with: ""),
            bundle: bundle
        )
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
