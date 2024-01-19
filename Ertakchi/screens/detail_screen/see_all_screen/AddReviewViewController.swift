//
//  AddReviewViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 07/01/24.
//

import UIKit
import PanModal
import SwiftyStarRatingView

protocol AddReviewViewControllerDelegate: AnyObject {
    func addReview(book: Book)
}

class AddReviewViewController: UIViewController {
    
    var contentHeight = 250.0
    
    var isEdit: Bool = false
    
    weak var delegate: AddReviewViewControllerDelegate?
    
    var id: Int64 = 0
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "review_1".translate()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let starRatingView = SwiftyStarRatingView()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColor.label
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.tintColor = UIColor.label
        textView.autocorrectionType = .no
        return textView
    }()
    
    lazy var watchButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 45.0 / 2
        logInButton.backgroundColor = UIColor.label
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
        logInButton.setTitle("Edit", for: .normal)
        logInButton.setTitleColor(.label, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)
        logInButton.layer.borderWidth = 1.7
        logInButton.layer.borderColor = UIColor(named: "buttonColor")?.cgColor
        return logInButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gestureRecog)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContentHeight(initial: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContentHeight(initial: 0)
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        subView.addSubview(titLabel)
        titLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        configureStarView()
        
        subView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(starRatingView.snp.bottom).offset(25)
            make.height.equalTo(120)
        }
        
        subView.addSubview(watchButton)
        watchButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        if isEdit {
            watchButton.setTitle("Delete", for: .normal)
            watchButton.snp.updateConstraints { make in
                make.top.equalTo(textView.snp.bottom).offset(30 + 45 + 15)
            }
            
            subView.addSubview(readButton)
            readButton.snp.makeConstraints { make in
                make.top.equalTo(textView.snp.bottom).offset(30)
                make.right.equalToSuperview().offset(-30)
                make.left.equalToSuperview().offset(30) 
                make.height.equalTo(45)
            }
        } else {
            watchButton.setTitle("publish".translate(), for: .normal)
            
        }
    }
    
    private func setContentHeight(initial heightInitial: CGFloat) {
        DispatchQueue.main.async {
            let height = self.subView.frame.height
            self.contentHeight = UIScreen.main.bounds.height - 100
            self.panModalSetNeedsLayoutUpdate()
            self.panModalTransition(to: .shortForm)
        }
    }
    
    func configureStarView() {
        starRatingView.frame = CGRect(x: 0, y: 0, width: 180, height: 50)
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 0
        starRatingView.backgroundColor = UIColor.clear
        starRatingView.tintColor = UIColor.label
        starRatingView.allowsHalfStars = false
        //        starRatingView.addTarget(self, action: #selector(starValueChanged), for: .valueChanged)
        subView.addSubview(starRatingView)
        starRatingView.snp.makeConstraints { make in
            make.top.equalTo(titLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(180)
        }
    }
    
    @objc func readButtonTapped(sender: UIButton) {
        view.endEditing(true)
        sender.showAnimation { [weak self] in
            guard let self = self else { return }
            let rankingType = self.starRatingView.value
            if let message = self.textView.text {
                self.showLoadingView()
                API.shared.updateReview(id: id, message: message, rankingType: Int(rankingType)) { [weak self] bookk, error in
                    guard let self = self else { return }
                    self.dissmissLoadingView()
                    if let book = bookk {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.delegate?.addReview(book: book)
                    } else if error != nil {
                        self.showAlert(title: "failure".translate(), message: "can_not_delete_review".translate()) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        self.showAlert(title: "failure".translate(), message: "can_not_delete_review".translate()) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @objc func watchButtonTapped(sender: UIButton) {
        view.endEditing(true)
        if isEdit {
            
            sender.showAnimation { [weak self] in
                guard let self = self else { return }
                if self.textView.text != nil {
                    self.showLoadingView()
                    API.shared.removeFromFavorites(id: id) { [weak self] bookk, error in
                        guard let self = self else { return }
                        self.dissmissLoadingView()
                        if let book = bookk {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.delegate?.addReview(book: book)
                        } else if error != nil {
                            self.showAlert(title: "failure".translate(), message: "can_not_delete_review".translate()) {
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            self.showAlert(title: "failure".translate(), message: "can_not_delete_review".translate()) {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        } else {
            sender.showAnimation { [weak self] in
                guard let self = self else { return }
                let rankingType = self.starRatingView.value
                if let message = self.textView.text {
                    self.showLoadingView()
                    API.shared.reviewBook(id: id, message: message, rankingType: Int(rankingType)) { [weak self] bookk, error in
                        guard let self = self else { return }
                        self.dissmissLoadingView()
                        if let book = bookk {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.delegate?.addReview(book: book)
                        } else if let error = error {
                            self.showAlert(title: "failure".translate(), message: "have_a_review_error".translate()) {
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            self.showAlert(title: "failure".translate(), message: "have_a_review_error".translate()) {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        
    }
}


extension AddReviewViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var shortFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var cornerRadius: CGFloat {
        return 22
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}
