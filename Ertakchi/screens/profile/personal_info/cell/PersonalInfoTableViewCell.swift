//
//  PersonalInfoTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 13/01/24.
//

import UIKit

protocol PersonalInfoTableViewCellDelegate: AnyObject {
    func resetButtonTapped()
    func deleteButtonTapped()
    func textFieldDidChange()
}

class PersonalInfoTableViewCell: UITableViewCell {
    
    var info: ProfileInfo?
    
    weak var delegate: PersonalInfoTableViewCellDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "fullname".translate()
        return label
    }()
    
    lazy var fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 45.0 / 2
        textField.backgroundColor = .systemGray6
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        
        let placeholderText = "fullname".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedText = NSAttributedString(string: "fullname".translate(), attributes: attributes2)
        textField.attributedText = attributedText
        textField.tintColor = UIColor.label
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "username".translate()
        return label
    }()
    
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 45.0 / 2
        textField.backgroundColor = .systemGray6
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        
        let placeholderText = "username".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedText = NSAttributedString(string:"username".translate(), attributes: attributes2)
        textField.attributedText = attributedText
        textField.tintColor = UIColor.label
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "email".translate()
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 45.0 / 2
        textField.backgroundColor = .systemGray6
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        
        let placeholderText = "email".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedText = NSAttributedString(string: "email".translate(), attributes: attributes2)
        textField.attributedText = attributedText
        textField.tintColor = UIColor.label
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    lazy var watchButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 45.0 / 2
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("delete_accunt".translate(), for: .normal)
        logInButton.setTitleColor(.systemBackground, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        logInButton.layer.borderWidth = 1.7
        logInButton.layer.borderColor = UIColor.clear.cgColor
        logInButton.isUserInteractionEnabled = true
        return logInButton
    }()
    
    lazy var readButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 45.0 / 2
        logInButton.backgroundColor = UIColor.clear
        logInButton.setTitle("reset_password".translate(), for: .normal)
        logInButton.setTitleColor(.label, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        logInButton.layer.borderWidth = 1.7
        logInButton.layer.borderColor = UIColor(named: "buttonColor")?.cgColor
        logInButton.isUserInteractionEnabled = true
        return logInButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        subView.addSubview(fullnameTextField)
        fullnameTextField.snp.makeConstraints { make in
            make.left.right.equalTo(fullNameLabel)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(5)
            make.height.equalTo(45.0)
        }
        
        subView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(fullnameTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        subView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { make in
            make.left.right.equalTo(fullNameLabel)
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.height.equalTo(45.0)
        }
        
        subView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        subView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalTo(fullNameLabel)
            make.top.equalTo(emailLabel.snp.bottom).offset(5)
            make.height.equalTo(45.0)
        }
        
        subView.addSubview(readButton)
        readButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
        
        subView.addSubview(watchButton)
        watchButton.snp.makeConstraints { make in
            make.top.equalTo(readButton.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
            make.bottom.equalToSuperview()
        }
    }
    
    func setData(info: ProfileInfo) {
        self.info = info
        fullnameTextField.text = info.name
        userNameTextField.text = info.username
        emailTextField.text = info.email
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldDidChange()
    }
    
    func getFullname() -> String {
        if let fullname = fullnameTextField.text {
            return fullname
        }
        return ""
    }
    
    func getUsername() -> String {
        if let username = userNameTextField.text {
            return username
        }
        return ""
    }
    
    func getEmail() -> String {
        if let email = emailTextField.text {
            return email
        }
        return ""
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        sender.showAnimation { [weak self] in
            self?.delegate?.deleteButtonTapped()
        }
    }
    
    @objc func resetButtonTapped(sender: UIButton) {
        sender.showAnimation { [weak self] in
            self?.delegate?.resetButtonTapped()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               self.readButton.layer.borderColor = UIColor(named: "buttonColor")?.cgColor
           }
       }
    }
}
