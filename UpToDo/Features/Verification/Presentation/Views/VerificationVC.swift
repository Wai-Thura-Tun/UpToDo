//
//  VerificationVC.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 18/12/2568 BE.
//

import UIKit

@MainActor
class VerificationVC: UIViewController, Storyboarded, Alertable {

    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblVerifyEmail: UILabel!
    @IBOutlet weak var lblSentEmail: UILabel!
    @IBOutlet weak var btnVerified: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblDidNotReceive: UILabel!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    private var vm: VerificationVM!
    private weak var coordinator: AuthCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(self.vm != nil, "VerificationVM must be configured before viewDidLoad")
        
        setUpViews()
        setUpBindings()
    }
    
    private func setUpViews() {
        imgEmail.tintColor = .primary
        lblVerifyEmail.font = .popB32
        lblSentEmail.font = .popR16
        lblDidNotReceive.font = .popR14
        
        btnVerified.layer.cornerRadius = 8.0
        btnVerified.backgroundColor = .primary
        btnVerified.titleLabel?.font = .popR16
        btnVerified.tintColor = .white
        
        btnResend.titleLabel?.attributedText = NSAttributedString(
            string: "Resend",
            attributes: [
                .font : UIFont.popR16,
                .foregroundColor: UIColor.primary,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]
        )
        self.navigationController?.navigationBar.isHidden = false
        self.isModalInPresentation = true
        self.stopLoading()
    }
    
    private func setUpBindings() {
        btnVerified.addTarget(self, action: #selector(onTapVerified), for: .touchUpInside)
        btnResend.addTarget(self, action: #selector(onTapResend), for: .touchUpInside)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onTapClose))
        
    }
    
    func configure(with vm: VerificationVM, coordinator: AuthCoordinator) {
        self.vm = vm
        self.vm.setDelegate(self)
        self.coordinator = coordinator
    }
    
    @objc private func onTapVerified() {
        self.startLoading()
        self.vm.checkVerification()
    }
    
    @objc private func onTapResend() {
        self.startLoading()
        self.vm.resendVerification()
    }
    
    @objc private func onTapClose() {
        self.startLoading()
        self.vm.deleteUser()
    }
    
    private func startLoading() {
        self.viewActivityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        self.viewActivityIndicator.stopAnimating()
    }
}

extension VerificationVC: VerificationViewDelegate {
    func didFinishVerification() {
        self.stopLoading()
        self.coordinator?.didFinishVerification()
    }
    
    func onFailed(message: String) {
        self.stopLoading()
        self.showAlert(title: nil, message: message)
    }
    
    func onResendVerificationSuccess(title: String, message: String) {
        self.stopLoading()
        self.showAlert(title: title, message: message)
    }
    
    func onCancelVerification() {
        self.stopLoading()
        self.coordinator?.didFinishVerification()
    }
}
