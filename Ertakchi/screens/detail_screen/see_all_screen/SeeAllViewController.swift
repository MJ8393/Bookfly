//
//  SeeAllViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 07/01/24.
//

import UIKit

class SeeAllViewController: UIViewController {
    
    var reviews = [BookReviews]()
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var reViewtableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: String.init(describing: ReviewTableViewCell.self))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "review_large".translate()
        view.backgroundColor = .systemBackground
        
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = {
            self.dismiss(animated: true)
        }
        
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        subView.addSubview(reViewtableView)
        reViewtableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.bottom.equalToSuperview()
        }
    }
}

extension SeeAllViewController: UITableViewDelegate, UITableViewDataSource {
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

