//
//  AutherTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 10/01/24.
//

import UIKit

class AutherCollectionViewCell: UICollectionViewCell {
    
    var isGenre: Bool = false {
        didSet {
            if isGenre {
                mainImageView.image = UIImage(systemName: "books.vertical.fill")!
            } else {
                mainImageView.image = UIImage(systemName: "person.fill")!
            }
        }
    }
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var atherView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 80.0 / 2
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")!
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Lev Tolstoy"
        return label
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
        
        subView.addSubview(atherView)
        atherView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.height.width.equalTo(80)
        }
        
        atherView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(36)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(atherView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setAuther(ather: Auther) {
        titleLabel.text = ather.name
    }
    
    func setGenre(genre: Genre) {
        titleLabel.text = genre.title
    }
    
}
