//
//  SearchViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 09/01/24.
//

import UIKit
import Lottie

class SearchViewController: BaseViewController, UITextFieldDelegate, BookDetailViewControllerDelegate {
    
    var searches = [Book]()
    
    var popularSearches = [Book]()
    
    var isSearching: Bool = false
    
    weak var delegate: MainTapControllerDelegate?
    
    private var animationView: LottieAnimationView?
    
    var cancelWidthEn: CGFloat = 60
    var cancelWidthUz: CGFloat = 100
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: String.init(describing: FavoritesTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 50, right: 0)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 7, y: 4, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "magnifyingglass")
        return imageView
    }()
    
    lazy var largeTitlesLabel: UILabel = {
        let label = UILabel()
        label.text = "search".translate()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    lazy var searchtextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 40 / 2
        textField.backgroundColor = .systemGray6
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftView.addSubview(searchIconImageView)
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        
        let placeholderText = "seach_des".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedText = NSAttributedString(string: "", attributes: attributes2)
        textField.attributedText = attributedText
        textField.tintColor = UIColor.label
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("cancel".translate(), for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    lazy var noSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "search_no".translate()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13.5, weight: .regular)
        return label
    }()
    
    let headerView = HeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = true
        initViews()
        getPopularSearches()
        setupLottieAnimation()
    }
    
    private func setupLottieAnimation() {
        animationView = .init(name: "Animation - 1705207516385.json")
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView?.isHidden = true
        animationView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        animationView!.play()
        
        noSearchLabel.isHidden = true
        view.addSubview(noSearchLabel)
        noSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView!.snp.bottom).offset(-30)
            make.left.right.equalToSuperview()
        }
    }
    
    override func languageDidChange() {
        getPopularSearchesOnBack()
        largeTitlesLabel.text = "search".translate()
        let placeholderText = "seach_des".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        searchtextField.attributedPlaceholder = attributedPlaceholder
        cancelButton.setTitle("cancel".translate(), for: .normal)
        noSearchLabel.text = "search_no".translate()
     
        if LanguageManager.getAppLang() == .Uzbek {
            cancelButton.snp.updateConstraints { make in
                make.width.equalTo(cancelWidthUz)
            }
        } else {
            cancelButton.snp.updateConstraints { make in
                make.width.equalTo(cancelWidthEn)
            }
        }
    }
    
    private func getPopularSearches() {
        self.showLoadingView()
        API.shared.getPopularSearches { [weak self] bestBooks, error in
            guard let self = self else { return }
            self.dissmissLoadingView()
            if let books = bestBooks {
                self.popularSearches = books
                self.animateTable()
            } else if let error = error {
                self.showAlert(title: "failure".translate(), message: "faulure_popular".translate())
            } else {
                self.showAlert(title: "failure".translate(), message: "faulure_popular".translate())
            }
        }
    }
    
    private func getPopularSearchesOnBack() {
        DispatchQueue.global(qos: .background).async {
            API.shared.getPopularSearches { [weak self] bestBooks, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let books = bestBooks {
                        self.popularSearches = books
                        self.tableView.reloadData()
                    } else if let error = error {
                        self.showAlert(title: "failure".translate(), message: "faulure_popular".translate())
                    } else {
                        self.showAlert(title: "failure".translate(), message: "faulure_popular".translate())
                    }
                }
            }
        }
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(largeTitlesLabel)
        largeTitlesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        subView.addSubview(searchtextField)
        searchtextField.delegate = self
        searchtextField.snp.makeConstraints { make in
            make.top.equalTo(largeTitlesLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        subView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(LanguageManager.getAppLang() == .Uzbek ? 100 : 60)
            make.left.equalTo(view.snp.right)
            make.centerY.equalTo(searchtextField)
            make.height.equalTo(40)
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchtextField.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.replacingOccurrences(of: " ", with: "") != "" {
            self.isSearching = true
            API.shared.search(keyword: text) { [weak self] bestBooks, error in
                guard let self = self else { return }
                if let books = bestBooks {
                    self.searches = books
                    self.tableView.reloadData()
                } else if let error = error {
                    self.showAlert(title: "failure".translate(), message: "failure_search".translate())
                } else {
                    self.showAlert(title: "failure".translate(), message: "failure_search".translate())
                }
            }
        } else {
            isSearching = false
            tableView.reloadData()
            animationView?.isHidden = true
            noSearchLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
        isSearching = false
        tableView.reloadData()
    }
    
    @objc func cancelButtonTapped() {
        view.endEditing(true)
        isSearching = false
        searches = []
        searchtextField.text = ""
        animationView?.isHidden = true
        noSearchLabel.isHidden = true
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searches.count
        } else {
            return popularSearches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: FavoritesTableViewCell.self), for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if isSearching {
            cell.setBook(book: searches[indexPath.row])
        } else {
            cell.setBook(book: popularSearches[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching {
            if searches.count == 0 {
                animationView?.isHidden = false
                noSearchLabel.isHidden = false
                headerView.titleLabel.isHidden = true
            } else {
                animationView?.isHidden = true
                noSearchLabel.isHidden = true
                headerView.titleLabel.isHidden = false
            }
            headerView.titleLabel.text = "search_results".translate()
        } else {
            if popularSearches.count == 0 {
                headerView.titleLabel.isHidden = true
            } else {
                headerView.titleLabel.isHidden = false
            }
            headerView.titleLabel.text = "search_popular".translate()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let index = indexPath.row
        if isSearching {
            let vc = BookDetailViewController()
            vc.delegate = self
            vc.hidesBottomBarWhenPushed = true
            let book = searches[index]
            vc.book = book
            addToSearchHistory(id: book.id)
            self.navigationItem.title = ""
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = BookDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            let book = popularSearches[index]
            vc.book = book
            self.navigationItem.title = ""
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addToSearchHistory(id: Int64) {
        DispatchQueue.global(qos: .background).async {
            API.shared.addToSearch(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .some(_):
                        print("rtt")
                    case .none:
                        self?.getPopularSearchesOnBack()
                    }
                }
            }
        }
    }
}

extension SearchViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.largeTitlesLabel.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-40)
            }
            self.largeTitlesLabel.alpha = 0
            
            if LanguageManager.getAppLang() == .Uzbek {
                self.cancelButton.snp.updateConstraints { make in
                    
                    self.searchtextField.snp.updateConstraints { make in
                        make.right.equalToSuperview().offset(-CGFloat(self.cancelWidthUz + 30))
                    }
                    
                    make.left.equalTo(self.view.snp.right).offset(-CGFloat(self.cancelWidthUz + 20))
                }
            } else {
                
                self.searchtextField.snp.updateConstraints { make in
                    make.right.equalToSuperview().offset(-CGFloat(self.cancelWidthEn + 30))
                }
            
                self.cancelButton.snp.updateConstraints { make in
                    make.left.equalTo(self.view.snp.right).offset(-CGFloat(self.cancelWidthEn + 20))
                }
                
            }

            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.largeTitlesLabel.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            }
            self.largeTitlesLabel.alpha = 1
            
            self.searchtextField.snp.updateConstraints { make in
                make.right.equalToSuperview().offset(-20)
                
            }
            
            self.cancelButton.snp.updateConstraints { make in
                make.left.equalTo(self.view.snp.right)
            }

            self.view.layoutIfNeeded()
        }
    }
    
    func likeChanged(id: Int64, isLiked: Bool) {
        delegate?.likeChanged(id: id, isLiked: isLiked)
    }
    
    func likeChangesTab(id: Int64, isLiked: Bool) {
        for (index, book) in popularSearches.enumerated() {
            if book.id == id {
                popularSearches[index].isFavorite = isLiked
            }
        }
        
        for (index, book) in searches.enumerated() {
            if book.id == id {
                searches[index].isFavorite = isLiked
            }
        }
    }
    
    func updateBook(book: Book) {
        delegate?.updateBook(book: book)
    }
    
    func updateBookTab(book: Book) {
        for (index, bookSearching) in popularSearches.enumerated() {
            if bookSearching.id == book.id {
                popularSearches[index] = book
            }
        }
        
        for (index, bookSearching) in searches.enumerated() {
            if bookSearching.id == book.id {
                searches[index] = book
            }
        }
    }
    
    func buyBook(id: Int64, isPurchased: Bool) {
        delegate?.buyChanged(id: id, isPurchased: isPurchased)
    }
    
    func buyBookTab(id: Int64, isPurchased: Bool) {
        for (index, book) in popularSearches.enumerated() {
            if book.id == id {
                popularSearches[index].isPurchased = isPurchased
            }
        }
        
        for (index, book) in searches.enumerated() {
            if book.id == id {
                searches[index].isPurchased = isPurchased
            }
        }
    }
    
    func animateTable() {
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
