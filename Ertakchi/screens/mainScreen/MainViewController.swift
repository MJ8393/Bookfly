//
//  MainViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 27/12/23.
//

// Sections: Bestsellers, continue to read, authers

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    var bestSellers = [Book]()
    
    var bestPopular = [Book]()
    
    var authers = [Auther]()
    
    var genres = [Genre]()
    
    var isLoading: Bool = false
    
    var requestOneFinished: Bool = false
    var requestTwoFinished: Bool = false
    var requestThreeFinished: Bool = false
    var requestFourFinished: Bool = false
    var isReloadPageOpened: Bool = false


    weak var delegate: MainTapControllerDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: String.init(describing: MainTableViewCell.self))
        tableView.register(AuthersTableViewCell.self, forCellReuseIdentifier: String.init(describing: AuthersTableViewCell.self))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "read_now".translate()
        title = "read_now".translate()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let likeButton = CustomBarButtonView(image: UIImage(systemName: "bell")!)
        
        likeButton.buttonAction = { [weak self] in
            let vc = NotificationViewController()
            self?.navigationItem.title = ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        NetworkMonitor.shared.delegate = self
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: likeButton), UIBarButtonItem(customView: likeButton)]
        self.showLoadingView()
        isLoading = true
        getBestSellers()
        getgetPopular()
        getAuthers()
        getGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startMonitoring()
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "read_now".translate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopMonitoring()
    }
    
    
    func animateTable() {
        tableView.reloadData()

        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height

        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            cell.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            })
        }
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
    
    @objc func dismissRegisterViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func languageDidChange() {
        getBestSellers()
        getgetPopular()
        getAuthers()
        getGenres()
        self.navigationItem.title = "read_now".translate()
        title = "read_now".translate()
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: MainTableViewCell.self), for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            if indexPath.section == 0 {
                cell.setBook(books: bestSellers)
                cell.sectionIndex = indexPath.section
            } else if indexPath.section == 2 {
                cell.setBook(books: bestPopular)
                cell.sectionIndex = indexPath.section
            } else {
                cell.sectionIndex = indexPath.section
            }
            cell.delegate = self
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: AuthersTableViewCell.self), for: indexPath) as? AuthersTableViewCell else { return UITableViewCell() }
            cell.setAuther(atherss: self.authers)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.sectionIndex = indexPath.section
            cell.delegate = self
            cell.isGenre = false
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: AuthersTableViewCell.self), for: indexPath) as? AuthersTableViewCell else { return UITableViewCell() }
            cell.isGenre = true
            cell.setGenres(genres: genres)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.delegate = self
            cell.sectionIndex = indexPath.section
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        if section == 0 {
            label.text = "best_sellers".translate()
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-8)
                make.height.equalTo(25)
            }
        } else {
            if section == 1 {
                label.text = "genres".translate()
            } else if section == 2 {
                label.text = "currently_popular".translate()
            } else {
                label.text = "authers".translate()
            }
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-8)
                make.height.equalTo(25)
            }
        }
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension MainViewController {
    func getBestSellers() {
        API.shared.getBestSellers { [weak self] bestBooks, error in
            guard let self = self else { return }
            if let books = bestBooks {
                self.bestSellers = books
//                self.animateTable()
//                self.tableView.reloadData()
                self.requestOneFinished = true
                self.checkToReload()
            } else if error != nil {
                self.requestOneFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_getting_best".translate())
            } else {
                self.requestOneFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_getting_best".translate())
            }
        }
    }
    
    func getgetPopular() {
        API.shared.getPopular { [weak self] bestBooks, error in
            guard let self = self else { return }
            if let books = bestBooks {
                self.bestPopular = books
//                self.tableView.reloadData()
                self.requestTwoFinished = true
                self.checkToReload()
            } else if error != nil {
                self.requestTwoFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_get_popular".translate())
            } else {
                self.requestTwoFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_get_popular".translate())
            }
        }
    }
    
    func getAuthers() {
        API.shared.getAuthers { [weak self] authers, error in
            guard let self = self else { return }
            if let authers = authers {
                self.authers = authers
//                self.tableView.reloadData()
                self.requestThreeFinished = true
                self.checkToReload()
            } else if error != nil {
                self.requestThreeFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_get_auther".translate())
            } else {
                self.requestThreeFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_get_auther".translate())
            }
        }
    }
    
    func getGenres() {
        API.shared.getGenres { [weak self] genres, error in
            guard let self = self else { return }
            if let genres = genres {
                self.genres = genres
//                self.tableView.reloadData()
                self.requestFourFinished = true
                self.checkToReload()
            } else if error != nil {
                self.requestFourFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_get_genres".translate())
            } else {
                self.requestFourFinished = false
//                self.showAlert(title: "failure".translate(), message: "face_error_get_genres".translate().translate())
            }
        }
    }
    
    func checkToReload() {
        if requestOneFinished && requestTwoFinished && requestThreeFinished && requestFourFinished {
            self.dissmissLoadingView()
            animateTable()
            if isLoading {
                self.dissmissLoadingView()
                isLoading = false
            }
        }
    }
}

extension MainViewController: MainTableViewCellDelegate {
    func cellTapped(section: Int, index: Int) {
        if section == 0 {
            let vc = BookDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            let book = bestSellers[index]
            vc.book = book
            self.navigationItem.title = ""
            navigationController?.pushViewController(vc, animated: true)
        } else if section == 2 {
            let vc = BookDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            let book = bestPopular[index]
            vc.book = book
            self.navigationItem.title = ""
            navigationController?.pushViewController(vc, animated: true)
        } else if section == 1 {
            let vc = GerneListViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.title = genres[index].title
            if let books = genres[index].books {
                vc.books = books
            }
            navigationController?.pushViewController(vc, animated: true)
        } else if section == 3 {
            let vc = GerneListViewController()
            vc.title = authers[index].name
            vc.hidesBottomBarWhenPushed = true
            if let books = authers[index].bookList {
                vc.books = books
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: BookDetailViewControllerDelegate {
    func buyBook(id: Int64, isPurchased: Bool) {
        delegate?.buyChanged(id: id, isPurchased: isPurchased)
    }
    
    func buyBookTab(id: Int64, isPurchased: Bool) {
        for (index, book) in bestSellers.enumerated() {
            if book.id == id {
                bestSellers[index].isPurchased = isPurchased
            }
        }
        
        for (index, book) in bestPopular.enumerated() {
            if book.id == id {
                bestPopular[index].isPurchased = isPurchased
            }
        }
    }
    
    func updateBook(book: Book) {
        delegate?.updateBook(book: book)
    }
    
    func updateBookTab(book: Book) {
        for (index, bookSearching) in bestSellers.enumerated() {
            if bookSearching.id == book.id {
                bestSellers[index] = book
            }
        }
        
        for (index, bookSearching) in bestPopular.enumerated() {
            if bookSearching.id == book.id {
                bestPopular[index] = book
            }
        }
    }
    
    func likeChanged(id: Int64, isLiked: Bool) {
        delegate?.likeChanged(id: id, isLiked: isLiked)
    }
    
    func likeChangedTab(id: Int64, isLiked: Bool) {
        for (index, book) in bestSellers.enumerated() {
            if book.id == id {
                bestSellers[index].isFavorite = isLiked
            }
        }
        
        for (index, book) in bestPopular.enumerated() {
            if book.id == id {
                bestPopular[index].isFavorite = isLiked
            }
        }
    }
}

extension MainViewController: NetworkMonitorDelegate {
    func checkInternetConnection(isOnline: Bool) {
        if !isOnline && !requestOneFinished && !requestTwoFinished && !requestThreeFinished && !requestFourFinished && !isReloadPageOpened {
            let vc = NoInternetViewController()
            vc.noInternetView.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            Vibration.heavy.vibrate()
            self.present(vc, animated: true)
            isReloadPageOpened = true
        }
        
        if isOnline && isReloadPageOpened {
            isReloadPageOpened = false
            self.dismiss(animated: true)
            if !isLoading {
                showLoadingView()
                isLoading = true
            }
            getBestSellers()
            getGenres()
            getgetPopular()
            getAuthers()
        }
    }
}

extension MainViewController: NoInternetViewDelegate {
    func reloadTapped() {
        isReloadPageOpened = false
        self.dismiss(animated: true)
        if !isLoading {
            showLoadingView()
            isLoading = true
        }
        getBestSellers()
        getGenres()
        getgetPopular()
        getAuthers()
    }
}
