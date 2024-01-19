//
//  CommentsTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 07/01/24.
//

import UIKit

protocol CommentsTableViewCellDelegate: AnyObject {
    func seeAllTapped()
}

class CommentsTableViewCell: UITableViewCell {
    
    var reviews = [BookReviews]()
    
    weak var delegate: CommentsTableViewCellDelegate?

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "review_large".translate()
        label.numberOfLines = 1
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("see_all".translate(), for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    lazy var reViewtableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: String.init(describing: ReviewTableViewCell.self))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        return tableView
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
        
        subView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(20)
        }
        
        subView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(11.5)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        subView.addSubview(reViewtableView)
        reViewtableView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview()
        }
    }
    
    func setReviews(reviews: [BookReviews]) {
        self.reviews = reviews
        reViewtableView.reloadData()
    }
    
    @objc func moreButtonTapped() {
        delegate?.seeAllTapped()
    }
    
}

extension CommentsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ReviewTableViewCell.self), for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.setReview(review: reviews[indexPath.row])
        return cell
    }
}


protocol ContentTableViewCellDelegate: AnyObject {
    func reloadTapleView(_ height: CGFloat)
}

final class ContentSizedTableView: UITableView {
    
    weak var delegatex: ContentTableViewCellDelegate?
        
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize ()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        delegatex?.reloadTapleView(contentSize.height)
        return CGSize(width: UIView.noIntrinsicMetric, height:
                        contentSize.height)
    }
}
