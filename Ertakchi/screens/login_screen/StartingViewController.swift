//
//  StartingViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 05/01/24.
//

import UIKit


// image starting

class StartingViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topView: HeroHeaderView = {
        let view = HeroHeaderView()
        return view
    }()
    
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.text = "BookFly"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "A new era of reading books"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.white
        logInButton.setTitle("Register", for: .normal)
        logInButton.setTitleColor(UIColor.black, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return logInButton
    }()
    
    lazy var logInButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.layer.cornerRadius = 20
        logInButton.backgroundColor = UIColor.clear
        logInButton.setTitle("Login to your account", for: .normal)
        logInButton.tintColor = .white
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return logInButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(UIScreen.main.bounds.height / 4)
        }
    
        subView.addSubview(logInButton)
        logInButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-getBottomMargin() - 50)
            make.height.equalTo(50)
        }
        
        subView.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(logInButton.snp.top).offset(-10)
            make.height.equalTo(50)
        }
        
        subView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(registerButton.snp.top).offset(-50)
        }
        
        subView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(descLabel.snp.top).offset(-5)
        }
    }
    
    @objc func registerTapped(sender: UIButton) {
        sender.showAnimation {
            let vc = RegisterViewController()
            self.present(UINavigationController(rootViewController: vc), animated: true)
        }
    }
    
    @objc func loginTapped() {
        let vc = LoginViewController()
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
}
