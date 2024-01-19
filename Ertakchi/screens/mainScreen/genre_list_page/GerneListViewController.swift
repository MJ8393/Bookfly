//
//  GerneListViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 15/01/24.
//

import UIKit

class GerneListViewController: UIViewController {
    
    var books = [BookList]()
    
    weak var delegate: MainTapControllerDelegate?
        
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20)
        collectionView.alwaysBounceVertical = true
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: GenreCollectionViewCell.self))
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        initViews()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension GerneListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: GenreCollectionViewCell.self), for: indexPath) as? GenreCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        cell.setBook(book: books[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 40 - 20) / 3, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.item]
        if let id = book.id {
            getBookByID(id: id)
        }
    }
    
    func getBookByID(id: Int64) {
        self.showLoadingView()
        API.shared.getBookBy(id: id) { [weak self] book, error in
            guard let self = self else { return }
            self.dissmissLoadingView()
            if let book = book {
                let vc = BookDetailViewController()
                vc.book = book
                vc.delegate = self
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            } else if error != nil {
                self.showAlert(title: "failure".translate(), message: "somethin_error".translate())
            } else {
                self.showAlert(title: "failure".translate(), message: "somethin_error".translate())
            }
        }
    }
}

extension GerneListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension GerneListViewController: BookDetailViewControllerDelegate {
    func buyBook(id: Int64, isPurchased: Bool) {
        let notificationData: [String: Any] = ["id": id, "isPurchased": isPurchased]
        NotificationCenter.default.post(name: .purchaseDidChange, object: nil, userInfo: notificationData)
    }
    
    func likeChanged(id: Int64, isLiked: Bool) {
        let notificationData: [String: Any] = ["id": id, "isLiked": isLiked]
        NotificationCenter.default.post(name: .likeDidChange, object: nil, userInfo: notificationData)
    }
    
    func updateBook(book: Book) {
        let notificationData: [String: Any] = ["book": book]
        NotificationCenter.default.post(name: .reviewDidChange, object: nil, userInfo: notificationData)
    }
}
