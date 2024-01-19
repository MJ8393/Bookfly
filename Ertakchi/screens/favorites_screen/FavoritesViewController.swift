//
//  FavoritesViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 28/12/23.
//

import UIKit

protocol FavoritesViewControllerDelegate: AnyObject {
    func cellTapped(vc: UIViewController)
}

class FavoritesViewController: BaseViewController {
    
    var isFavorites: Bool = false
    
    var isAnimated: Bool = false
    
    let refreshControl = UIRefreshControl()
    
    weak var delegate: MainTapControllerDelegate?
    
    weak var pageDelegate: FavoritesViewControllerDelegate?
        
    var bought = [Book]() {
        didSet  {
            if !isFavorites {
                if bought.count == 0 {
                    noSearchLabel.isHidden = false
                } else {
                    noSearchLabel.isHidden = true
                }
            }
        }
    }
    var favorites = [Book]() {
        didSet {
            if isFavorites {
                if favorites.count == 0 {
                    noSearchLabel.isHidden = false
                } else {
                    noSearchLabel.isHidden = true
                }
            }
        }
    }

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: String.init(describing: FavoritesTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 50, right: 0)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Empty"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    lazy var noSearchLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13.5, weight: .regular)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        view.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "favorites".translate()
        title = "favorites".translate()
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        setupLottieAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    override func languageDidChange() {
        noSearchLabel.text = isFavorites ? "no_favorites".translate() : "no_bought".translate()
        navigationItem.title = "favorites".translate()
        title = "favorites".translate()
        getFavorites()
//        getBoughtBooks()
    }
    
    private func setupLottieAnimation() {
        
        noSearchLabel.isHidden = false
        view.addSubview(noSearchLabel)
        noSearchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.left.right.equalToSuperview()
        }
    }
    
    private func initViews() {
        noSearchLabel.text = isFavorites ? "no_favorites".translate() : "no_bought".translate()
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func refresh(){
        if isFavorites {
            getFavorites()
        } else {
//            getBoughtBooks()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavorites {
            return favorites.count
        }
        return bought.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: FavoritesTableViewCell.self), for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if isFavorites {
            cell.setBook(book: favorites[indexPath.row])
        } else {
            cell.setBook(book: bought[indexPath.row])
        }
        return cell
    }
    
    func getFavorites() {
        self.refreshControl.beginRefreshing()
//        DispatchQueue.global().async { [weak self] in
            API.shared.getFavorites { bestBooks, error in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.refreshControl.endRefreshing()
                    if let books = bestBooks {
                        self.favorites = books
//                        self.tableView.reloadData()
                        self.animateTable()
                    } else {
                        self.showAlert(title: "failure".translate(), message: error?.localizedDescription ?? "face_error_favro".translate())
                    }
                }
            }
        
    }
    
    func getBoughtBooks() {
        self.refreshControl.beginRefreshing()
//        DispatchQueue.global().async { [weak self] in
            API.shared.getPurchasedBooks { bestBooks, error in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let books = bestBooks {
                        self.bought = books
//                        self.tableView.reloadData()
                        self.animateTable()
                    } else {
                        self.showAlert(title: "failure".translate(), message: error?.localizedDescription ?? "face_error_bought".translate())
                    }

                    self.refreshControl.endRefreshing()
                }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookDetailViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        if isFavorites {
            let book = favorites[indexPath.row]
            vc.book = book
            navigationController?.pushViewController(vc, animated: true)
//            pageDelegate?.cellTapped(vc: vc)
        } else {
            let book = bought[indexPath.row]
            vc.book = book
            pageDelegate?.cellTapped(vc: vc)
        }
    }
}

extension FavoritesViewController: BookDetailViewControllerDelegate {

    func buyBook(id: Int64, isPurchased: Bool) {
        delegate?.buyChanged(id: id, isPurchased: isPurchased)
    }
    
    func buyBookTab(id: Int64, isPurchased: Bool) {
        if isFavorites {
            for (index, book) in favorites.enumerated() {
                if book.id == id {
                    favorites[index].isPurchased = isPurchased
                }
            }
        } else {
            for (index, book) in bought.enumerated() {
                if book.id == id {
                    bought[index].isPurchased = isPurchased
                }
            }
        }
    }
    
    func likeChanged(id: Int64, isLiked: Bool) {
        delegate?.likeChanged(id: id, isLiked: isLiked)
    }
    
    func updateBook(book: Book) {
        delegate?.updateBook(book: book)
    }
    
    func likeChangesTab(id: Int64, isLiked: Bool) {
        if isFavorites {
            for (index, book) in favorites.enumerated() {
                if book.id == id {
                    favorites[index].isFavorite = isLiked
                }
            }
        } else {
            for (index, book) in bought.enumerated() {
                if book.id == id {
                    bought[index].isFavorite = isLiked
                }
            }
        }
    }
    
    func updateBookTab(book: Book) {
        if isFavorites {
            for (index, bookSearching) in favorites.enumerated() {
                if bookSearching.id == book.id {
                    favorites[index] = book
                }
            }
        } else {
            for (index, bookSearching) in bought.enumerated() {
                if bookSearching.id == book.id {
                    bought[index] = book
                }
            }
        }
    }
    
    func animateTable() {
        if isAnimated {
            tableView.reloadData()
        } else {
            isAnimated = true
            tableView.reloadData()
            let cells = tableView.visibleCells
            let tableViewHeight = tableView.bounds.size.height
            
            for (index, cell) in cells.enumerated() {
                cell.alpha = 0
                
                UIView.animate(withDuration: 0.4, delay: 0.05 * Double(index), options: [.curveEaseInOut], animations: {
                    cell.alpha = 1
                })
            }
        }
    }
}
