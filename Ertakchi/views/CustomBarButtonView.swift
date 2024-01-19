//
//  File.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 06/01/24.
//

import UIKit

class CustomBarButtonView: UIView {
    
    var buttonAction: (() -> Void)?
    
    lazy var customButton: BaseButton = {
        let button = BaseButton()
        return button
    }()
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        customButton.backgroundColor = UIColor.clear
        customButton.layer.cornerRadius = 40 / 2
        customButton.setImage(image, for: .normal)
        customButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.tintColor = .label
        customButton.imageView!.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        self.addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        self.buttonAction?()
    }
}

class CustomBuyButtonView: UIView {
    
    var buttonAction: (() -> Void)?
    
    lazy var customButton: BaseButton = {
        let button = BaseButton()
        return button
    }()
    
    init(_ title: String = "buy".translate()) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        customButton.backgroundColor = UIColor.clear
        customButton.layer.cornerRadius = 40 / 2
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(.systemBackground, for: .normal)
        customButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        customButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.backgroundColor = .label
        customButton.layer.cornerRadius = 12.5
//        customButton.imageView!.snp.makeConstraints { make in
//            make.height.equalTo(25)
//            make.width.equalTo(50)
//        }
        
        self.addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(25)
            
            if LanguageManager.getAppLang() == .Uzbek {
                make.width.equalTo(100)
            } else {
                make.width.equalTo(60)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        self.buttonAction?()
    }
}


class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transform = .identity
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}

