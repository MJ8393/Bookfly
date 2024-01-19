//
//  BookDetailScreen.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 06/01/24.
//

import UIKit
import MapKit

protocol BookDetailViewControllerDelegate: AnyObject {
    func likeChanged(id: Int64, isLiked: Bool)
    func updateBook(book: Book)
    func buyBook(id: Int64, isPurchased: Bool)
}

class BookDetailViewController: UIViewController {
    
    var book: Book?
    
    var price: Double = 0.0
    
    weak var delegate: BookDetailViewControllerDelegate?
    
    var lastUpdatedHeight: CGFloat = 0
    
    let likeButton = CustomBarButtonView(image: UIImage(systemName: "heart")!)

    var isLiked: Bool = false {
        didSet {
            if isLiked == true {
                likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!, for: .normal)
                likeButton.customButton.tintColor = UIColor.label
            } else {
                likeButton.customButton.setImage(UIImage(systemName: "heart")!, for: .normal)
                likeButton.customButton.tintColor = UIColor.label
            }
        }
    }
    
    var isPurchased: Bool = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: String.init(describing: DetailTableViewCell.self))
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: String.init(describing: CommentsTableViewCell.self))
        tableView.register(MyCommentTableViewCell.self, forCellReuseIdentifier: String.init(describing: MyCommentTableViewCell.self))
        tableView.register(AddReviewTableViewCell.self, forCellReuseIdentifier: String.init(describing: AddReviewTableViewCell.self))
        tableView.register(OhMyGodTableViewCell.self, forCellReuseIdentifier: String.init(describing: OhMyGodTableViewCell.self))
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        return tableView
    }()
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        price = book?.price ?? 0.0
        view.backgroundColor = .systemBackground
        initViews()
        setupNavigation()
        if let book = book {
            isLiked = book.isFavorite ?? false
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let book = book, let isFavorite = book.isFavorite {
            if !isFavorite == isLiked {
                DispatchQueue.global(qos: .background).async {
                    API.shared.likeBook(id: book.id, isLiked: self.isLiked) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .some(_):
                                print("error")
                            case .none:
                                self.delegate?.likeChanged(id: book.id, isLiked: self.isLiked)
                            }
                        }
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
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    let reviewButton = CustomBuyButtonView()
    
    private func setupNavigation() {
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        reviewButton.buttonAction = { [weak self] in
            guard let self = self else { return }
            if let id = book?.id {
                self.buyBook(id: id)
            }
        }
        
        if let isPurchased = book?.isPurchased {
            if isPurchased {
                self.isPurchased = isPurchased
                reviewButton.customButton.setTitle("buyed_top".translate(), for: .normal)
                reviewButton.customButton.isUserInteractionEnabled = false
                reviewButton.customButton.backgroundColor = .gray
            }
        }
        
        likeButton.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.isLiked = !self.isLiked
            Vibration.light.vibrate()
            if isLiked == true {
                likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!, for: .normal)
                likeButton.customButton.tintColor = UIColor.label
            } else {
                likeButton.customButton.setImage(UIImage(systemName: "heart")!, for: .normal)
                likeButton.customButton.tintColor = UIColor.label
            }
        }
        
        if price == 0.0 {
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: likeButton)]
        } else {
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: reviewButton), UIBarButtonItem(customView: likeButton)]
        }
    }
    
    func buyBook(id: Int64) {
        self.showLoadingView()
        API.shared.buyBook(id: id) { [weak self] result in
            self?.dissmissLoadingView()
            DispatchQueue.main.async {
                switch result {
                case .some(_):
                    self?.showAlert(title: "failure".translate(), message: "fail_to_buy".translate()) {
                        self?.dismiss(animated: true)
                    }
                case .none:
                    Vibration.heavy.vibrate()
                    self?.reviewButton.customButton.setTitle("buyed_top".translate(), for: .normal)
                    self?.reviewButton.customButton.isUserInteractionEnabled = false
                    self?.reviewButton.customButton.backgroundColor = .gray
                    let seconds = 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        self?.showAlert(title: "success".translate(), message: "success_to_purchase".translate()) {
                            self?.dismiss(animated: true)
                        }
                    }
                    self?.isPurchased = true
                    if self?.isPurchased != self?.book?.isPurchased {
                        if let id = self?.book?.id, let isPurchased = self?.isPurchased {
                            self?.delegate?.buyBook(id: id, isPurchased: isPurchased)
                        }
                    }
                }
            }
        }
    }
}

extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: DetailTableViewCell.self), for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            if let book = book {
                cell.setBook(book: book)
            }
            cell.price = self.price
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: CommentsTableViewCell.self), for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
            cell.reViewtableView.delegatex = self
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if let reviews = book?.reviews {
                if reviews.count == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: OhMyGodTableViewCell.self), for: indexPath) as? OhMyGodTableViewCell else { return UITableViewCell() }
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                }
                if reviews.count <= 3 {
                    cell.setReviews(reviews: reviews)
                } else {
                    cell.setReviews(reviews: [reviews[0], reviews[1], reviews[2]])
                }
            }
            cell.delegate = self
            return cell
        } else {
            if let review = book?.yourReview {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: MyCommentTableViewCell.self), for: indexPath) as? MyCommentTableViewCell else { return UITableViewCell() }
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.setReview(review: review)
                cell.delegate = self
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: AddReviewTableViewCell.self), for: indexPath) as? AddReviewTableViewCell else { return UITableViewCell() }
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            }
        }
    }
}

extension BookDetailViewController: ContentTableViewCellDelegate {
    func reloadTapleView(_ height: CGFloat) {
        if height != lastUpdatedHeight {
            tableView.reloadData()
        }
        lastUpdatedHeight = height
    }
}

// Actions
extension BookDetailViewController: DetailTableViewCellDelegate, CommentsTableViewCellDelegate, MyCommentTableViewCellDelegate, AddReviewTableViewCellDelegate {
    func openMaps() {
        if let book = book {
            let latitude: CLLocationDegrees = book.latitude ?? 0.0
            let longitude: CLLocationDegrees = book.longitude ?? 0.0
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Inha university in Tashkent"
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
    func playVideoTapped() {
        
    }
    
    func openPDFTapped() {
        let defaultURL = "https://deriv.nls.uk/dcn23/1086/8138/108681385.23.pdf"
        var link = defaultURL
        let language = LanguageManager.getAppLang()
        switch language {
        case .English:
            link = book?.links?.en ?? defaultURL
        case .Uzbek:
            link = book?.links?.uz ?? defaultURL
        case .lanDesc:
            link = book?.links?.en ?? defaultURL
        }
        
        let remotePDFDocumentURLPath = link
        let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
        guard var document = PDFDocument(url: remotePDFDocumentURL) else {
            return
        }
        
        document.delegate = self
        let readerController = PDFViewController.createNew(with: document, title: book?.title)
        
        readerController.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.pushViewController(readerController, animated: true)
    }
    
    func editButtonTapped() {
        let vc = AddReviewViewController()
        vc.isEdit = true
        vc.delegate = self
        if let book = book {
            vc.id = book.id
            vc.starRatingView.value = CGFloat(book.yourReview?.rank ?? 0)
            vc.textView.text = book.yourReview?.message
        }
        navigationController?.presentPanModal(vc)
    }
    
    func seeAllTapped() {
        if let reviews = book?.reviews {
            let vc = SeeAllViewController()
            vc.reviews = reviews
            self.present(UINavigationController(rootViewController: vc), animated: true)
        }
    }
    
    func addReviewTapped() {
        let vc = AddReviewViewController()
        vc.delegate = self
        if let book = book {
            vc.id = book.id
            vc.starRatingView.value = 0.0
        }
        navigationController?.presentPanModal(vc)
    }
}

extension BookDetailViewController: AddReviewViewControllerDelegate, PDFDocumentDelegate {
    func addReview(book: Book) {
        self.book = book
        self.delegate?.updateBook(book: book)
        tableView.reloadData()
    }
    
    func showLoading() {
//        self.showLoadingView()
    }
    
    func dismissLoading() {
//        self.dissmissLoadingView()
    }
}

extension BookDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
