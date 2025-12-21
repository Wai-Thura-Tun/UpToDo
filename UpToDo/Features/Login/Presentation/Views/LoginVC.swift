//
//  LoginVC.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 9/12/2568 BE.
//

import UIKit
import IQKeyboardCore
import IQKeyboardToolbar

@MainActor
class LoginVC: UIViewController, Storyboarded, Alertable {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword:UILabel!
    @IBOutlet weak var tfEmail: UpToDoTextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblApple: UILabel!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    private var vm: LoginVM!
    
    weak var coordinator: AuthCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(self.vm != nil, "VM must be configured before viewDidLoad")

        self.setUpViews()
        self.setUpBindings()
    }

    private func setUpViews() {
        self.lblEmailError.isHidden = true
        self.lblPasswordError.isHidden = true
        [self.lblEmail, self.lblPassword].setFonts(.popR16)
        [self.lblEmailError, self.lblPasswordError].setFonts(.popR13)
        
        [self.btnGoogle, self.btnApple].addBorderWithCorner()
        [self.lblGoogle, self.lblApple].setFonts(.popR16)
        
        self.btnLogin.layer.cornerRadius = 8.0
        self.btnLogin.layer.backgroundColor = UIColor.primary.cgColor
        self.btnLogin.titleLabel?.font = .popR16
        
        self.title = "Login"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.stopLoading()
    }
    
    private func setUpBindings() {
        self.tfEmail.iq.toolbar.doneBarButton.setTarget(self, action: #selector(onChangeEmail))
        self.tfPassword.iq.toolbar.doneBarButton.setTarget(self, action: #selector(onChangePassword))
        self.btnLogin.addTarget(self, action: #selector(onTapLogin), for: .touchUpInside)
        self.btnRegister.addTarget(self, action: #selector(onTapRegister), for: .touchUpInside)
        self.btnApple.addTarget(self, action: #selector(onTapApple), for: .touchUpInside)
        self.btnGoogle.addTarget(self, action: #selector(onTapGoogle), for: .touchUpInside)
    }
    
    func configure(
        with vm: LoginVM, coordinator:
        AuthCoordinator
    )
    {
        self.vm = vm
        self.vm.setDelegate(self)
        self.coordinator = coordinator
    }
    
    @objc private func onChangeEmail() {
        self.vm.setEmail(tfEmail.text)
    }
    
    @objc private func onChangePassword() {
        self.vm.setPassword(tfPassword.text)
    }
    
    @objc private func onTapLogin() {
        self.vm.setEmail(tfEmail.text)
        self.vm.setPassword(tfPassword.text)
        self.vm.validateForm()
    }
    
    @objc private func onTapRegister() {
        self.coordinator?.showRegister()
    }
    
    @objc private func onTapGoogle() {
        self.vm.loginWithGoogle(in: self.view.window)
    }
    
    @objc private func onTapApple() {
        self.vm.loginWithApple(in: self.view.window)
    }
    
    private func clearError() {
        self.lblEmailError.isHidden = true
        self.lblPasswordError.isHidden = true
    }
    
    private func startLoading() {
        self.viewActivityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        self.viewActivityIndicator.stopAnimating()
    }
}

extension LoginVC: LoginViewDelegate {
    
    func onValidate(valiationErrors: [LoginVM.ValidationError]) {
        self.startLoading()
        self.clearError()
        
        if valiationErrors.isEmpty {
            self.vm.login()
        }
        else {
            valiationErrors.forEach { form in
                switch form {
                case .EmailTextField(let message):
                    lblEmailError.setError(message)
                case .PasswordTextField(let message):
                    lblPasswordError.setError(message)
                }
            }
        }
    }
    
    func onLoginSuccess() {
        self.stopLoading()
        self.coordinator?.didFinishLogin()
    }
    
    func onFailed(message: String?, validationErrors: [String : String]?) {
        self.stopLoading()
        
        if message != nil {
            self.showAlert(title: nil, message: message)
        }
        else if let validationErrors = validationErrors, !validationErrors.isEmpty {
            if let emailError = validationErrors["email"] {
                self.lblEmailError.setError(emailError)
            }
            
            if let passwordError = validationErrors["password"] {
                self.lblPasswordError.setError(passwordError)
            }
        }
    }
}
