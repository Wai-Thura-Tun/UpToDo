//
//  Alertable.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation
import UIKit

protocol Alertable: AnyObject {}

extension Alertable where Self: UIViewController {
    func showAlert(title: String?, message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
