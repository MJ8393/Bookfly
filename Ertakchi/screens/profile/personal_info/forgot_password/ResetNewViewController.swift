//
//  ResetNewViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 14/01/24.
//

import UIKit

class ResetNewViewController: UIViewController {
    
    var token: String = ""
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
//    lazy var registerLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.text = "set_new_pass".translate()
//        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        return label
//    }()

    private let textField1: CustomizedTextField = {
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
        return textField
    }()
    
    private let logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("set".translate(), for: .normal)
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
        
        title = "set_new_pass".translate()
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
                    self.showAlert(title: "failure".translate(), message: "error_password_empty".translate())
                }
                self.sendRevoryEmail(username: username)
            }
        }
    }
    
    private func sendRevoryEmail(username: String) {
        self.showLoadingView()
        API.shared.reset_new_password(token: token, code: username) { result in
            self.dissmissLoadingView()
            switch result {
            case .some(_):
                self.showAlert(title: "failure".translate(), message: "somethin_error".translate())
            case .none:
                // Success
                self.showAlert(title: "success".translate(), message: "set_passowrd_succ".translate()) {
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

}
