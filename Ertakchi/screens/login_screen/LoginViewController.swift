//
//  LoginViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 31/12/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
//    lazy var registerLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.text = "login".translate()
//        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        return label
//    }()
//    
    private let textField1: CustomizedTextField = {
        let textField = CustomizedTextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "username".translate(), attributes: placeholderAttributes)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = UIColor.label
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 20
        textField.backgroundColor = UIColor.grayColor
        textField.tintColor = .label
        textField.autocorrectionType = .no
        return textField
    }()

    private let textField2: CustomizedTextField = {
        let textField = CustomizedTextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "password".translate(), attributes: placeholderAttributes)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = UIColor.label
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 20
        textField.backgroundColor = UIColor.grayColor
        textField.tintColor = .label
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("sign_in".translate(), for: .normal)
        logInButton.setTitleColor(.systemBackground, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return logInButton
    }()
    
    lazy var forgetPasswordButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.clear
        logInButton.setTitle("Forget password", for: .normal)
        logInButton.setTitleColor(.label, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(forgetButtonTapped), for: .touchUpInside)
        return logInButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        let backButton = UIBarButtonItem(title: "back".translate(), style: .done, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .label
        navigationItem.rightBarButtonItem = backButton
        
        title = "login".translate()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
              make.left.equalToSuperview().offset(20)
              make.right.equalToSuperview().offset(-20)
            make.top.equalTo((navigationController?.navigationBar.frame.maxY ?? 0) + (navigationController?.navigationBar.frame.height ?? 0))
          }
        
//        subView.addSubview(registerLabel)
//        registerLabel.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalToSuperview().offset(15)
//        }
        
        subView.addSubview(textField1)
        textField1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subView.addSubview(textField2)
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subView.addSubview(logInButton)
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subView.addSubview(forgetPasswordButton)
        forgetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func loginButtonTapped(sender: UIButton) {
        view.endEditing(true)
        sender.showAnimation {
            self.loginToApp()
        }
    }
    
    @objc func forgetButtonTapped(sender: UIButton) {
        view.endEditing(true)
        let vc = ForgotPasswordViewController()
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func loginToApp() {
        if let username =  textField1.text, let password = textField2.text {
            if username.replacingOccurrences(of: " ", with: "") == "" || password.replacingOccurrences(of: " ", with: "") == "" {
                self.showAlert(title: "failure".translate(), message: "user_name_pass_not_empty".translate())
            } else {
                showLoadingView()
                API.shared.login(username: username, password: password) { loginModel, error in
                    self.dissmissLoadingView()
                        if !username.isEmpty, !password.isEmpty {
                            if let model = loginModel {
                                UD.token = model.token
                                let vc = MainTabBarController()
                                self.setNewRootViewController()
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else if let error = error {
                                self.showAlert(title: "failure".translate(), message: "no_user_logged".translate())
                            } else {
                                self.showAlert(title: "failure".translate(), message: "somethin_error".translate())
                            }
                        } else {
                            self.showAlert(title: "failure".translate(), message: "enter_valid".translate())
                        }
                    }
            }
        }
    }
}

