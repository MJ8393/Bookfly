//
//  AddReviewTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 07/01/24.
//

import UIKit

protocol AddReviewTableViewCellDelegate: AnyObject {
    func addReviewTapped()
}

class AddReviewTableViewCell: UITableViewCell {
    
    weak var delegate: AddReviewTableViewCellDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var readButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 45.0 / 2
        logInButton.backgroundColor = UIColor.clear
        logInButton.setTitle("add_review".translate(), for: .normal)
        logInButton.setTitleColor(.label, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)
        logInButton.layer.borderWidth = 1.7
        logInButton.layer.borderColor = UIColor(named: "buttonColor")?.cgColor
        return logInButton
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
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.bottom.equalToSuperview()
        }
        
        subView.addSubview(readButton)
        readButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    @objc func readButtonTapped(sender: UIButton) {
        sender.showAnimation { [weak self] in
            self?.delegate?.addReviewTapped()
        }
    }
}
