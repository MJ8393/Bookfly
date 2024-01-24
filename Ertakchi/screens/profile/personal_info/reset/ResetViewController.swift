//
//  ResetViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 14/01/24.
//

import UIKit

class ResetViewController: UIViewController {
        
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
//    lazy var registerLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.text = "reset_password".translate()
//        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        return label
//    }()
    
    private let textField1: CustomizedTextField = {
        let textField = CustomizedTextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "old_password".translate(), attributes: placeholderAttributes)
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

    private let textField2: CustomizedTextField = {
        let textField = CustomizedTextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "new_pass".translate(), attributes: placeholderAttributes)
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
    
    lazy var logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("reset".translate(), for: .normal)
        logInButton.setTitleColor(.systemBackground, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return logInButton
    }()
    
    lazy var forgetPasswordButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.clear
        logInButton.setTitle("forgot_pass".translate(), for: .normal)
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
        
        title = "reset_password".translate()
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
//            make.bottom.equalToSuperview()
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
        sender.showAnimation {
            if let oldPassword = self.textField1.text, let newPassword = self.textField2.text {
                if oldPassword.contains(" ") || newPassword.contains(" ") {
                    self.showAlert(title: "failure".translate(), message: "password_empty_error".translate())
                } else if oldPassword == "" || newPassword == "" {
                    self.showAlert(title: "failure".translate(), message: "error_valid_pass".translate())
                } else if oldPassword == newPassword {
                    self.showAlert(title: "failure".translate(), message: "password_not_same".translate())
                } else {
                    self.resetPassword(oldPassword: oldPassword, newPassword: newPassword)
                }
            }
        }
    }
    
    @objc func forgetButtonTapped(sender: UIButton) {
        view.endEditing(true)
        let vc = ForgotPasswordViewController()
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func resetPassword(oldPassword: String, newPassword: String) {
        self.showLoadingView()
        API.shared.resetPassword(oldPassword: oldPassword, newPassword: newPassword) { result in
            self.dissmissLoadingView()
            switch result {
            case .some(_):
                self.showAlert(title: "failure".translate(), message: "old_not_correct".translate())
            case .none:
                self.showAlert(title: "success".translate(), message: "new_pass_set".translate()) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
