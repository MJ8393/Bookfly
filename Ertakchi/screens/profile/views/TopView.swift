//
//  TopView.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 09/01/24.
//

import UIKit

protocol TopViewDelegate: AnyObject {
    func profileTapped()
}

class TopView: UIView {
    
    weak var delegate: TopViewDelegate?
    
    lazy var personView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 60
        view.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(personViewTapped))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")!
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var hasImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.image = UIImage(systemName: "person")!
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        imageView.isHidden = true
        return imageView
    }()


    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.text = "username".translate()
        label.textColor = .label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(personView)
        personView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.5)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        personView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
        self.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(personView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        personView.addSubview(hasImageView)
        hasImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func personViewTapped() {
        delegate?.profileTapped()
    }
    
    func setImage(image: UIImage) {
        hasImageView.setImage(image: image)
        hasImageView.isHidden = false
        mainImageView.isHidden = true
    }
    
    func setImageWith(url: String) {
        hasImageView.isHidden = false
        mainImageView.isHidden = true
        hasImageView.loadImage(url: url)
    }
}
