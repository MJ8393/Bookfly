//
//  MainTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 27/12/23.
//

import UIKit

protocol MainTableViewCellDelegate: AnyObject {
    func cellTapped(section: Int, index: Int)
}

class MainTableViewCell: UITableViewCell {
    
    var books = [Book]()
    
    weak var delegate: MainTableViewCellDelegate?
    
    var sectionIndex: Int = 0
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: MainCollectionViewCell.self))
        return collectionView
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
        
        subView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-7)
            make.height.equalTo(240)
        }
    }
    
    func setBook(books: [Book]) {
        self.books = books
        collectionView.reloadData()
    }
}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainCollectionViewCell.self), for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        cell.setBook(book: books[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellTapped(section: sectionIndex, index: indexPath.item)
    }
}
