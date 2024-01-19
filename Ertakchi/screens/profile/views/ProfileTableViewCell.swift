//
//  ProfileTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 09/01/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")!
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "profile".translate()
        label.textColor = .label
        return label
    }()
    
    lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .label
        return imageView
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
        
        subView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(12.5)
            make.bottom.equalToSuperview().offset(-12.5)
            make.height.width.equalTo(23)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-60)
            make.centerY.equalToSuperview()
        }
        
        subView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(16)
        }
    }
    
    func setProfile(profile: Profile) {
        iconImageView.image = profile.image
        nameLabel.text = profile.name
    }
}
