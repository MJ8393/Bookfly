//
//  NotificationViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 28/12/23.
//

import UIKit

class NotificationViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: String.init(describing: NotificationTableViewCell.self))
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "notifications".translate()
        navigationController?.navigationBar.prefersLargeTitles = false
        initViews()
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: NotificationTableViewCell.self), for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NotificationDetailsScreen()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.presentPanModal(vc)
    }
}

extension NotificationViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
