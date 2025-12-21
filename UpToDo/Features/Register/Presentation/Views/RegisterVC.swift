//
//  RegisterVC.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 16/12/2568 BE.
//

import UIKit
import IQKeyboardCore
import IQKeyboardToolbar

@MainActor
class RegisterVC: UIViewController, Storyboarded, Alertable {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var tfEmail: UpToDoTextField!
    @IBOutlet weak var tfPassword: UpToDoTextField!
    @IBOutlet weak var tfConfirmPassword: UpToDoTextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblApple: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!

    private weak var coordinator: AuthCoordinator?
    
    private var vm: RegisterVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpViews()
        self.setUpBindings()
    }
    
    private func setUpViews() {
        self.lblEmailError.isHidden = true
        self.lblPasswordError.isHidden = true
        self.lblConfirmPasswordError.isHidden = true
        
        [self.lblEmail, self.lblPassword, self.lblConfirmPassword].setFonts(.popR16)
        [self.lblEmailError, self.lblPasswordError, self.lblConfirmPasswordError].setFonts(.popR13)
        
        [self.btnApple, self.btnGoogle].addBorderWithCorner()
        [self.lblApple, self.lblGoogle].setFonts(.popR16)
        
        self.btnRegister.layer.cornerRadius = 8
        self.btnRegister.layer.backgroundColor = UIColor.primary.cgColor
        self.btnRegister.titleLabel?.font = .popR16
        
        self.title = "Register"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.stopLoading()
    }
    
    private func setUpBindings() {
        self.btnLogin.addTarget(self, action: #selector(onTapLogin), for: .touchUpInside)
        self.btnRegister.addTarget(self, action: #selector(onTapRegister), for: .touchUpInside)
        
        self.tfEmail.iq.toolbar.doneBarButton.setTarget(self, action: #selector(onChangeEmail))
        self.tfPassword.iq.toolbar.doneBarButton.setTarget(self, action: #selector(onChangePassword))
        self.tfConfirmPassword.iq.toolbar.doneBarButton.setTarget(self, action: #selector(onChangeConfirmPassword))
    }

    func configure(with vm: RegisterVM, coordinator: AuthCoordinator) {
        self.vm = vm
        self.vm.setDelegate(self)
        self.coordinator = coordinator
    }
    
    @objc private func onTapRegister() {
        self.vm.setEmail(self.tfEmail.text)
        self.vm.setPassword(self.tfPassword.text)
        self.vm.setConfirmPassword(self.tfConfirmPassword.text)
        
        self.vm.validateForm()
    }
    
    @objc private func onTapLogin() {
        self.coordinator?.didCancelRegister()
    }
    
    @objc private func onChangeEmail() {
        self.vm.setEmail(self.tfEmail.text)
    }
    
    @objc private func onChangePassword() {
        self.vm.setPassword(self.tfPassword.text)
    }
    
    @objc private func onChangeConfirmPassword() {
        self.vm.setConfirmPassword(self.tfConfirmPassword.text)
    }
    
    private func clearError() {
        self.lblEmailError.isHidden = true
        self.lblPasswordError.isHidden = true
        self.lblConfirmPasswordError.isHidden = true
    }
    
    private func startLoading() {
        self.viewActivityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        self.viewActivityIndicator.stopAnimating()
    }
}

extension RegisterVC: RegisterViewDelegate {
    
    func onValidate(validationErrors: [RegisterVM.ValidationError]) {
        self.startLoading()
        self.clearError()
        
        if validationErrors.isEmpty {
            self.vm.register()
        }
        else {
            validationErrors.forEach { form in
                switch form {
                case .EmailTextField(let message):
                    self.lblEmailError.setError(message)
                case .PasswordTextField(let message):
                    self.lblPasswordError.setError(message)
                case .ConfirmPasswordTextField(let message):
                    self.lblConfirmPasswordError.setError(message)
                }
            }
        }
    }
    
    func onRegisterSuccess() {
        self.stopLoading()
        self.coordinator?.didFinishRegister()
    }
    
    func onLoginSuccess() {
        self.stopLoading()
        self.coordinator?.didFinishLogin()
    }
    
    func onFailed(message: String?, validationErrors: [String : String]?) {
        self.stopLoading()
        self.clearError()
        
        if let message = message {
            self.showAlert(title: nil, message: message)
        }
        else if let validationErrors = validationErrors {
            if let emailErrorMessage = validationErrors["email"] {
                self.lblEmailError.setError(emailErrorMessage)
            }
            
            if let passwordErrorMessage = validationErrors["password"] {
                self.lblPasswordError.setError(passwordErrorMessage)
            }
        }
    }
}
