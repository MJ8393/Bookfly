//
//  MainCollectionViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 27/12/23.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    var book: Book?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
//        imageView.image = UIImage(named: "sample")!
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Harry Potter"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "J.K. Rowling"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(190)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        subView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalTo(titleLabel)
        }
    }
    
    func setBook(book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        mainImageView.loadImage(url: book.imageLink)
    }
}
