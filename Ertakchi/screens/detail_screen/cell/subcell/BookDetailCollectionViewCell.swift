//
//  BookDetailCollectionViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 06/01/24.
//

import UIKit

class BookDetailCollectionViewCell: UICollectionViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "4,5"
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")!
        imageView.contentMode = .right
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "453 ratings"
        return label
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        topStackView.addArrangedSubview(topImageView)
        topStackView.addArrangedSubview(topLabel)
        topImageView.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
        
        subView.addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-1.0)
        }
        
        subView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.right.equalToSuperview().offset(-1.0)
        }
        
        subView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(1.0)
        }
    }
}
