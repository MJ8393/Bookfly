//
//  FavoritesTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 29/12/23.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
        imageView.image = UIImage(named: "sample")!
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.text = "Harry Potter"
        return label
    }()
    
    lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.text = "J.K. Rowling"
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
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(80)
            make.width.equalTo(60)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(mainImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(mainImageView)
        }
        
        subView.addSubview(publisherLabel)
        publisherLabel.snp.makeConstraints { make in
            make.left.equalTo(mainImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func setBook(book: Book) {
        mainImageView.loadImage(url: book.imageLink)
        nameLabel.text = book.title
        publisherLabel.text = book.author
    }
}
