//
//  NoInternetView.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 06/12/23.
//

import UIKit
import Lottie

protocol NoInternetViewDelegate: AnyObject {
    func reloadTapped()
}

class NoInternetView: UIView {
    
    weak var delegate: NoInternetViewDelegate?
    
    private var animationView = LottieAnimationView()
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "check_netwrok".translate()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    lazy var reloadAccount: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 45.0 / 2
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("reload".translate(), for: .normal)
        logInButton.setTitleColor(.systemBackground, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(reloadAccountTarget), for: .touchUpInside)
        logInButton.layer.borderWidth = 1.7
        logInButton.layer.borderColor = UIColor.clear.cgColor
        return logInButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupLottieAnimation()
        
        subView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(-30)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
        }
        
        subView.addSubview(reloadAccount)
        reloadAccount.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
    }
    
    @objc func reloadAccountTarget(sender: UIButton) {
        sender.showAnimation { [weak self] in
            self?.delegate?.reloadTapped()
        }
    }
    
    private func setupLottieAnimation() {
        animationView = .init(name: "Animation - 1705347023055.json")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        subView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 8)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(UIScreen.main.bounds.width - 50)
        }
        animationView.play()
    }
    
}
