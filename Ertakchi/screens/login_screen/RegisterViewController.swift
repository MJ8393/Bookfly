//
//  RegisterViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 31/12/23.
//

import UIKit
import PanModal

class RegisterViewController: UIViewController {
    
    var contentHeight = 250.0
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
//    lazy var registerLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.text = "register".translate()
//        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        return label
//    }()
    
    private let textField1: CustomizedTextField = {
        let textField = CustomizedTextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "fullname".translate(), attributes: placeholderAttributes)
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
    
    private let textField3: CustomizedTextField = {
        let textField = CustomizedTextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "email".translate(), attributes: placeholderAttributes)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = UIColor.label
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 20
        textField.backgroundColor = UIColor.grayColor
        textField.tintColor = .label
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let textField4: CustomizedTextField = {
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
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("sign_up".translate(), for: .normal)
        logInButton.setTitleColor(.systemBackground, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
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
        
        title = "register".translate()
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContentHeight()
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
        
        subView.addSubview(textField2)
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subView.addSubview(textField3)
        textField3.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subView.addSubview(textField4)
        textField4.snp.makeConstraints { make in
            make.top.equalTo(textField3.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subView.addSubview(logInButton)
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(textField4.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func registerTapped(sender: UIButton) {
        view.endEditing(true)
        sender.showAnimation {
            self.registerToApp()
        }
    }
    
    private func registerToApp() {
        if let fullname = textField1.text, let username = textField2.text, let email = textField3.text, let password = textField4.text {
            if fullname.count != 0, username.count != 0, email.count != 0, password.count != 0 {
                if isValidEmail(email) {
                    API.shared.register(fullName: fullname, username: username, email: email, password: password) { loginModel, error in
                        self.dissmissLoadingView()
                            if !username.isEmpty, !password.isEmpty {
                                if let model = loginModel {
                                    UD.token = model.token
                                    let vc = MainTabBarController()
                                    self.setNewRootViewController()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else if let error = error {
                                    self.showAlert(title: "failure".translate(), message: "already_register".translate())
                                } else {
                                    self.showAlert(title: "failure".translate(), message: "somethin_error".translate())
                                }
                            } else {
                                self.showAlert(title: "failure".translate(), message: "enter_valid".translate())
                            }
                        }
                } else {
                    self.showAlert(title: "failure".translate(), message: "email_not_valid".translate())
                }
            } else {
                self.showAlert(title: "failure".translate(), message: "enter_valid".translate())
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func setContentHeight() {
        DispatchQueue.main.async {
            let height = self.subView.frame.height
            self.contentHeight = height + 70
            self.panModalSetNeedsLayoutUpdate()
            self.panModalTransition(to: .shortForm)
        }
    }
}

extension RegisterViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var shortFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var cornerRadius: CGFloat {
        return 22
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}
