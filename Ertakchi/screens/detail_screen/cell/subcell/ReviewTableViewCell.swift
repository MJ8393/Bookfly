//
//  ReviewTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 07/01/24.
//

import UIKit
import SwiftyStarRatingView

let smallColors = [UIColor(hex: "CE5A67"), UIColor(hex: "6C5F5B"), UIColor(hex: "9A4444"), UIColor(hex: "3085C3"), UIColor(hex: "004225"), UIColor(hex: "E55604"), UIColor(hex: "0F2C59"), UIColor(hex: "57375D")]

class ReviewTableViewCell: UITableViewCell {
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var avatarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = smallColors.randomElement()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var avarImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "X"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mekhriddin Jumaev"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    let starRatingView = SwiftyStarRatingView()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "October 16, 2022"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "I have literally opened a portal to another dimension and though it will rend my flesh and contort my very psyche, I'm going to enter."
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 4
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
        
        subView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(5)
            make.height.width.equalTo(30)
        }
        
        avatarView.addSubview(avarImageView)
        avarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalTo(avatarView)
        }
        configureStarView()
        
        subView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(starRatingView.snp.right).offset(5)
            make.right.equalToSuperview().offset(0)
            make.centerY.equalTo(starRatingView)
        }
        
        subView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.left.equalToSuperview()
            make.top.equalTo(starRatingView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureStarView() {
        starRatingView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 0
        starRatingView.backgroundColor = .clear
        starRatingView.value = 3
        starRatingView.isHidden = false
        starRatingView.tintColor = UIColor.mainColor
        starRatingView.allowsHalfStars = false
        starRatingView.isUserInteractionEnabled = false
        subView.addSubview(starRatingView)
        starRatingView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(7.5)
            make.height.equalTo(12.5)
            make.width.equalTo(100)
        }
    }
    
    func setReview(review: BookReviews) {
        if let first = review.username?.first {
            mainLabel.text = "\(String(first).capitalized)"
        }
        nameLabel.text = review.username
        if let rank = review.rank {
            starRatingView.value = CGFloat(rank)
        } else {
            starRatingView.value = 0
        }
        if let date = review.date {
            setData(dateString: date)
        }
        descriptionLabel.text = review.message
        
        if let imageURL = review.userPhoto {
            avarImageView.isHidden = false
            avarImageView.loadImage(url: imageURL)
            mainLabel.isHidden = true
        } else {
            avarImageView.isHidden = true
            mainLabel.isHidden = false
        }
    }
    
    func setData(dateString: String) {
        if let formattedDate = Helper1.formatDate(dateString) {
            dateLabel.text = formattedDate
        } else {
        }
    }
}

class Helper1 {
    static func formatDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
}
