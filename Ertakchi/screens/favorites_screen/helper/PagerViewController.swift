//
//  PagerViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 29/12/23.
//

import UIKit


class PagerController: DTPagerController {
    
    var is1RequestFinished: Bool = true
    var is2RequestFinished: Bool = true

    var buyBooks = [Book]()

    
    let viewController1 = FavoritesViewController()
    let viewController2 = FavoritesViewController()
    
    var hotelFilterData = [String]()
    var restaurantFilterData = [String]()

    var isFilterTapped: Bool = false

    
    init() {
        super.init(viewControllers: [])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func languageDidChange() {
        title = "favorites".translate()
        let attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.mainColor,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let attributedString1 = NSAttributedString(string: "liked".translate(), attributes: attributes1)
        pageSegmentedControl.leftButton.setAttributedTitle(attributedString1, for: .normal)
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let attributedString2 = NSAttributedString(string: "buyed".translate(), attributes: attributes2)
        pageSegmentedControl.rightButton.setAttributedTitle(attributedString2, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewController1.pageDelegate = self
        viewController2.pageDelegate = self
        title = "favorites".translate()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .label
        perferredScrollIndicatorHeight = 2.0
        viewController1.title = "liked".translate()
        viewController2.title = "buyed".translate()
        viewController1.isFavorites = true
        viewController2.isFavorites = false
        viewControllers = [viewController1, viewController2]
        scrollIndicator.backgroundColor = UIColor.mainColor
        scrollIndicator.layer.cornerRadius = 0
        setSelectedPageIndex(0, animated: false)
        textColor = UIColor.black
        pageScrollView.backgroundColor = .clear
        pageSegmentedControl.backgroundColor = .clear
        pageSegmentedControl.tintColor = .clear
        font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewController1.getFavorites()
        viewController2.getBoughtBooks()
    }
}

extension PagerController: FavoritesViewControllerDelegate {
    func cellTapped(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
