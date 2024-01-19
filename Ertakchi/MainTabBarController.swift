//
//  MainTabBarController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 27/12/23.
//

import UIKit

protocol MainTapControllerDelegate: AnyObject {
    func likeChanged(id: Int64, isLiked: Bool)
    func updateBook(book: Book)
    func buyChanged(id: Int64, isPurchased: Bool)
}

extension Notification.Name {
    static let likeDidChange = Notification.Name("likeDidChange")
    static let reviewDidChange = Notification.Name("reviewDidChange")
    static let purchaseDidChange = Notification.Name("purchaseDidChange")
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var shapeLayer: CAShapeLayer?
    
    let vc1 = MainViewController()
    let vc2 = SearchViewController()
    let vc3 = FavoritesViewController()
    let vc4 = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        vc2.delegate = self
        vc1.delegate = self
        
        vc3.delegate = self
        vc3.isFavorites = true
//        vc3.viewController1.delegate = self
//        vc3.viewController2.delegate = self
//        
        let nc1 = UINavigationController(rootViewController: vc1)
        let nc2 = UINavigationController(rootViewController: vc2)
        let nc3 = UINavigationController(rootViewController: vc3)
        let nc4 = UINavigationController(rootViewController: vc4)

        nc2.title = "search".translate()
        nc3.title = "favorites".translate()
        nc4.title = "profile".translate()
        
        nc1.tabBarItem.image = UIImage(systemName: "book")
        nc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        nc3.tabBarItem.image = UIImage(systemName: "heart")
        nc4.tabBarItem.image = UIImage(systemName: "person")
        tabBar.tintColor = UIColor.mainColor
        self.delegate = self
        setViewControllers([nc1, nc2, nc3, nc4], animated: true)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ChangeTabBar"), object: nil, queue: nil) { _ in
            nc2.title = "search".translate()
            nc3.title = "favorites".translate()
            nc4.title = "profile".translate()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(likeDidChange(_:)), name: .likeDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reviewDidChange(_:)), name: .reviewDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(buyBookChange(_:)), name: .purchaseDidChange, object: nil)
    }
    
    @objc func likeDidChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let id = userInfo["id"] as? Int64,
           let isLiked = userInfo["isLiked"] as? Bool {
            likeChanged(id: id, isLiked: isLiked)
        }
    }
    
    @objc func buyBookChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let id = userInfo["id"] as? Int64,
           let isLiked = userInfo["isPurchased"] as? Bool {
            likeChanged(id: id, isLiked: isLiked)
        }
    }
    
    @objc func reviewDidChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let book = userInfo["book"] as? Book {
            updateBook(book: book)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .likeDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .reviewDidChange, object: nil)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.backgroundColor = UIColor(named: "tabbar")!
        tabBar.unselectedItemTintColor = UIColor.label
        UITabBar.appearance().layer.borderColor = UIColor.black.cgColor
        UITabBar.appearance().layer.borderWidth = 1
        addTabBarShadowBG()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.clipsToBounds = false
    }

    
    private func addTabBarShadowBG() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.systemBackground.cgColor
        shapeLayer.strokeColor = UIColor.systemGray6.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.shouldRasterize = true
        shapeLayer.rasterizationScale = UIScreen.main.scale
        if let oldShapeLayer = self.shapeLayer {
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer

    }
    
    func createPath() -> CGPath {
           let height: CGFloat = 74
           let path = UIBezierPath()
           let centerWidth = tabBar.frame.width / 2
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x: (centerWidth - height), y: 0))
           path.addLine(to: CGPoint(x: tabBar.frame.width, y: 0))
           path.addLine(to: CGPoint(x: tabBar.frame.width, y: tabBar.frame.height))
           path.addLine(to: CGPoint(x: 0, y: tabBar.frame.height))
           path.close()
           return path.cgPath
       }
    
    @objc func dismissRegisterViewController() {
        self.dismiss(animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tagValue = viewController.tabBarItem.tag
        if tagValue == 2 {
            return false
        }
        return true
    }
}

extension MainTabBarController: MainTapControllerDelegate {
    func buyChanged(id: Int64, isPurchased: Bool) {
        vc1.buyBookTab(id: id, isPurchased: isPurchased)
        vc2.buyBookTab(id: id, isPurchased: isPurchased)
        vc3.buyBookTab(id: id, isPurchased: isPurchased)
//        vc3.viewController2.buyBookTab(id: id, isPurchased: isPurchased)
    }
    
    func likeChanged(id: Int64, isLiked: Bool) {
        vc1.likeChangedTab(id: id, isLiked: isLiked)
        vc2.likeChangesTab(id: id, isLiked: isLiked)
        vc3.likeChangesTab(id: id, isLiked: isLiked)
//        vc3.viewController2.likeChangesTab(id: id, isLiked: isLiked)
    }
    
    func updateBook(book: Book) {
        vc1.updateBookTab(book: book)
        vc2.updateBookTab(book: book)
        vc3.updateBookTab(book: book)
//        vc3.viewController2.updateBookTab(book: book)
    }
}

extension UINavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            if viewControllers.count > 1 {
                interactivePopGestureRecognizer?.isEnabled = true
            } else {
                interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }
}
