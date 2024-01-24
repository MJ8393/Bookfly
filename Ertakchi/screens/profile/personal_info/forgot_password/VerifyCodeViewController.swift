//
//  VerifyCodeViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 14/01/24.
//

import UIKit


class VerifyCodeViewController: UIViewController {
    
    var token: String = ""
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
//    lazy var registerLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.text = "verify_passw".translate()
//        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        return label
//    }()

    private let textField1: CustomizedTextField = {
        let textField = CustomizedTextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "verify_coodde".translate(), attributes: placeholderAttributes)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = UIColor.label
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 20
        textField.backgroundColor = UIColor.grayColor
        textField.tintColor = .label
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("verify".translate(), for: .normal)
        logInButton.setTitleColor(.systemBackground, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
        
        title = "verify_passw".translate()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showAlert(title: "alert".translate(), message: "alert_email".translate())
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
//        
        subView.addSubview(textField1)
        textField1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subView.addSubview(logInButton)
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func loginButtonTapped(sender: UIButton) {
        view.endEditing(true)
        sender.showAnimation {
            if let username = self.textField1.text {
                if username.contains(" ") || username == "" {
                    self.showAlert(title: "failure".translate(), message: "error_ver_code".translate())
                }
                self.sendRevoryEmail(code: username)
            }
        }
    }
    
    private func sendRevoryEmail(code: String) {
        showLoadingView()
        API.shared.verify_code(token: token, code: code) { loginModel, error in
            self.dissmissLoadingView()
                if !code.isEmpty {
                    if let model = loginModel {
                        let vc = ResetNewViewController()
                        if let token = model.token {
                            vc.token = token
                        }
                        self.present(UINavigationController(rootViewController: vc), animated: true)
                    } else if let error = error {
                        self.showAlert(title: "failure".translate(), message: "ver_code_niot_correct".translate())
                    } else {
                        self.showAlert(title: "failure".translate(), message: "ver_code_niot_correct".translate())
                    }
                } else {
                    self.showAlert(title: "failure".translate(), message: "ver_code_niot_correct".translate())
                }
            }
    }

}
