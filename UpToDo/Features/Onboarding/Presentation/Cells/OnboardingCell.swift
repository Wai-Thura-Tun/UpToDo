//
//  OnboardingCell.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 6/12/2568 BE.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    @IBOutlet weak var imgOnboarding: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    var data: Onboarding? {
        didSet {
            if let data = self.data {
                self.imgOnboarding.image = UIImage(named: data.image)
                self.lblTitle.text = data.title
                self.lblSubtitle.text = data.subtitle
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        MainActor.assumeIsolated {
            self.setUpViews()
        }
    }
    
    private func setUpViews() {
        self.lblTitle.font = .popB32
        self.lblSubtitle.font = .popR16
    }
}
