//
//  NotificationTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 28/12/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 0.06).cgColor
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 1
        view.backgroundColor = UIColor(named: "tabbar")
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.image = UIImage(named: "new_year")!
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .label
        label.text = "happy_new".translate()
        return label
    }()

    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .gray
        label.text = "happy_new_desc".translate()
        return label
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
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(150)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        subView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-12)
        }
        
    }
    
}
