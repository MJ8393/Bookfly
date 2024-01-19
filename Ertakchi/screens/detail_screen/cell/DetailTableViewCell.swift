//
//  DetailTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 06/01/24.
//

import UIKit
import GoogleMaps

protocol DetailTableViewCellDelegate: AnyObject {
    func playVideoTapped()
    func openPDFTapped()
    func openMaps()
}

class DetailTableViewCell: UITableViewCell {
    
    var book: Book?
    
    var price: Double = 0.0
    
    lazy var mapContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var mapView = GMSMapView()
    
    var detailTitles = [String]()
    var detailDescriptions = [String]()
    var detailImages = [UIImage?]()

    weak var delegate: DetailTableViewCellDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "sample")!
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Harry Potter"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "J.K. Rowling"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var watchButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 45.0 / 2
        logInButton.backgroundColor = UIColor.label
        logInButton.setTitle("watch_book".translate(), for: .normal)
        logInButton.setTitleColor(.systemBackground, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        logInButton.layer.borderWidth = 1.7
        logInButton.layer.borderColor = UIColor.clear.cgColor
        return logInButton
    }()
    
    lazy var readButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 45.0 / 2
        logInButton.backgroundColor = UIColor.clear
        logInButton.setTitle("read_button".translate(), for: .normal)
        logInButton.setTitleColor(.label, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)
        logInButton.layer.borderWidth = 1.7
        logInButton.layer.borderColor = UIColor(named: "buttonColor")?.cgColor
        return logInButton
    }()
    
    lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    lazy var bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    lazy var detailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 115, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(BookDetailCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: BookDetailCollectionViewCell.self))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    lazy var desciptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "our_lib".translate()
        label.numberOfLines = 1
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    lazy var mapCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.5, weight: .regular)
        label.text = "our_lib_descrip".translate()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
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
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 100)
            make.top.equalToSuperview().offset(7.5)
            make.height.equalTo(mainImageView.snp.width).multipliedBy(4.6/4.0)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(watchButton)
        subView.addSubview(readButton)
        
        readButton.isHidden = true
        watchButton.isHidden = true
        readButton.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            //            make.right.equalTo(subView.snp.centerX).offset(-10)
            make.height.equalTo(0)
        }
        
        watchButton.snp.makeConstraints { make in
            make.top.equalTo(readButton.snp.bottom).offset(0) // 15
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(30)
//            make.left.equalTo(subView.snp.centerX).offset(10)
            make.height.equalTo(0)  // 45
        }
        
        subView.addSubview(detailCollectionView)
        detailCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(watchButton.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        
        subView.addSubview(topSeparatorView)
        topSeparatorView.snp.makeConstraints { make in
            make.bottom.equalTo(detailCollectionView.snp.top).offset(-5)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(1.0)
        }
        
        subView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(detailCollectionView.snp.bottom).offset(11)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(1.0)
        }
        
        subView.addSubview(desciptionLabel)
        desciptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(bottomSeparatorView.snp.bottom).offset(15)
//            make.bottom.equalToSuperview()
        }
        
        subView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(desciptionLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        subView.addSubview(mapContainerView)
        mapContainerView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(220)
//            make.bottom.equalToSuperview()
        }
        
        subView.addSubview(mapView)
        mapView.layer.cornerRadius = 20
        mapView.isUserInteractionEnabled = false
        
        mapContainerView.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapContainerView.addGestureRecognizer(tap)
        
        subView.addSubview(mapCommentLabel)
        mapCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview()
        }
    }
    
    func showMarker(position: CLLocationCoordinate2D, title: String, Snippet: String){
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        marker.snippet = Snippet
        marker.map = mapView
    }
   
    func setMap(latitude: Double, longitude: Double, title: String, Snippet: String) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12.0)
        mapView.camera = camera
        showMarker(position: camera.target, title: title, Snippet: Snippet)
    }
    
    @objc func mapViewTapped() {
        delegate?.openMaps()
    }
    
    @objc func watchButtonTapped(sender: UIButton) {
        sender.showAnimation {
            self.openVideo()
        }
    }
    
    private func openVideo() {
        delegate?.playVideoTapped()
    }
    
    @objc func readButtonTapped(sender: UIButton) {
        sender.showAnimation {
            self.openPDF()
        }
    }
    
    private func openPDF() {
        delegate?.openPDFTapped()
    }
    
    func setBook(book: Book) {
        self.book = book
        mainImageView.loadImage(url: book.imageLink)
        titleLabel.text = book.title
        authorLabel.text = book.author
        desciptionLabel.text = book.description
        if detailTitles != [] && detailDescriptions != [] && detailImages != [] {
            return
        }
        
        if let overallRank = book.overallRank, let reviews = book.reviews {
            detailTitles.append("\(overallRank)")
            detailDescriptions.append("\(reviews.count) \("review_small".translate())")
            detailImages.append(UIImage(named: "star")!)
        }
        
        if let pageLength = book.pageLength {
            detailTitles.append("\(pageLength)")
            detailDescriptions.append("pages".translate())
            detailImages.append(UIImage(named: "book-open")!)
        }
        
        if price == 0.0 {
//            if let price = book.price {
//                detailTitles.append("free".translate())
//                detailDescriptions.append("price".translate())
//                detailImages.append(nil)
//            }
        } else {
            if let price = book.price {
                detailTitles.append("$\(price)")
                detailDescriptions.append("price".translate())
                detailImages.append(nil)
            }
        }
       
        if let genre = book.genre {
            detailTitles.append(genre.title ?? "")
            detailDescriptions.append("gerne".translate())
            detailImages.append(nil)
        }
        
        detailCollectionView.reloadData()
        
        setMap(latitude: book.latitude ?? 41.338525, longitude: book.longitude ?? 69.3319551, title: "our_lib".translate(), Snippet: "Inha university in Tashkent")
        
        if let available = book.availableEformat {
            if available {
                readButton.snp.updateConstraints { make in
                    make.top.equalTo(authorLabel.snp.bottom).offset(30)
                    make.left.equalToSuperview().offset(30)
                    make.right.equalToSuperview().offset(-30)
                    make.height.equalTo(45)
                }
                readButton.isHidden = false
            } else {
                readButton.isHidden = true
            }
        }
        
        if let available = book.availableVideo {
            if available {
                watchButton.snp.updateConstraints { make in
                    make.top.equalTo(readButton.snp.bottom).offset(15)
                    make.right.equalToSuperview().offset(-30)
                    make.left.equalToSuperview().offset(30)
                    make.height.equalTo(45)
                }
                watchButton.isHidden = false
            } else {
                watchButton.isHidden = true
            }
        }
        
        if let available = book.availableVideo {
            if available {
                subView.addSubview(reviewLabel)
                reviewLabel.snp.updateConstraints { make in
                    make.top.equalTo(desciptionLabel.snp.bottom).offset(0)
                }
                reviewLabel.text = ""
                
                mapContainerView.snp.makeConstraints { make in
                    make.top.equalTo(reviewLabel.snp.bottom).offset(0)
                    make.height.equalTo(0)
                }
                
                subView.addSubview(mapCommentLabel)
                mapCommentLabel.snp.makeConstraints { make in
                    make.top.equalTo(mapContainerView.snp.bottom).offset(0)
                }
                mapCommentLabel.text = ""
                
                reviewLabel.isHidden = true
                mapContainerView.isHidden = true
                mapCommentLabel.isHidden = true
            } else {
                reviewLabel.isHidden = false
                mapContainerView.isHidden = false
                mapCommentLabel.isHidden = false
            }
        }
                
        
    }
}

extension DetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: BookDetailCollectionViewCell.self), for: indexPath) as? BookDetailCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        cell.bottomLabel.text = detailDescriptions[indexPath.item]
        cell.topLabel.text = detailTitles[indexPath.item]
        if let detailImages = detailImages[indexPath.item] {
            cell.topImageView.image = detailImages
            cell.topLabel.textAlignment = .left
            cell.topImageView.isHidden = false
        } else {
            cell.topStackView.removeArrangedSubview(cell.topImageView)
            cell.topLabel.textAlignment = .center
            cell.topImageView.isHidden = true
        }
        if indexPath.row == detailImages.count - 1 {
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        return cell
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               self.readButton.layer.borderColor = UIColor(named: "buttonColor")?.cgColor
           }
       }
    }
}
