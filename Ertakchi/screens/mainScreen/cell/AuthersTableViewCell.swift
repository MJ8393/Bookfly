//
//  AuthersTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 10/01/24.
//

import UIKit

class AuthersTableViewCell: UITableViewCell {
    
    var isGenre: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var sectionIndex = 0
    
    var authers = [Auther]()
    
    var genres = [Genre]()

    weak var delegate: MainTableViewCellDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
        collectionView.register(AutherCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: AutherCollectionViewCell.self))
        return collectionView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(130 - 7.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAuther(atherss: [Auther]) {
        self.authers = atherss
        collectionView.reloadData()
    }
    
    func setGenres(genres: [Genre]) {
        self.genres = genres
        collectionView.reloadData()
    }
}


extension AuthersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: AutherCollectionViewCell.self), for: indexPath) as? AutherCollectionViewCell else { return UICollectionViewCell() }
        if isGenre {
            cell.setGenre(genre: genres[indexPath.item])
        } else {
            cell.setAuther(ather: authers[indexPath.item])
        }
        cell.backgroundColor = .clear
        cell.isGenre = isGenre
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isGenre {
            return genres.count
        }
        return authers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 130 - 7.5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellTapped(section: sectionIndex, index: indexPath.item)
    }
}
