//
//  UICollectionView.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 6/12/2568 BE.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func dequeueCell<cell: UICollectionViewCell>(indexPath: IndexPath) -> cell {
        let identifier: String = String(describing: cell.self)
        return self.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as! cell
    }
    
    func registerCell<cell: UICollectionViewCell>(
        _ type: cell.Type,
        bundle: Bundle = .main
    )
    {
        let identifier: String = String(describing: cell.self)
        self.register(
            UINib(nibName: identifier, bundle: bundle),
            forCellWithReuseIdentifier: identifier
        )
    }
}
