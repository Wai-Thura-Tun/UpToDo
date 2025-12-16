//
//  String.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 14/12/2568 BE.
//

import Foundation

extension String {
    var isEmail: Bool {
        return self.wholeMatch(of: ValidationRules.emailRegex) != nil
    }
}
