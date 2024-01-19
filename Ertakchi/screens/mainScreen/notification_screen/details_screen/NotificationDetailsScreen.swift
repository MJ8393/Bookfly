//
//  NotificationDetailsScreen.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 28/12/23.
//

import UIKit
import PanModal

class NotificationDetailsScreen: BaseViewController {
    
    var contentHeight = 250.0
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "new_year")!
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .label
        label.text = "happy_new".translate()
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        label.text = "happy_new_desc".translate()
        return label
    }()
    
    lazy var dissmissButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("dismiss".translate(), for: .normal)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContentHeight()
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(dissmissButton)
        dissmissButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(descLabel.snp.bottom).offset(5)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContentHeight()
    }
    
    private func setContentHeight() {
        DispatchQueue.main.async {
            let height = 200 + self.titleLabel.frame.height + self.descLabel.frame.height
            self.contentHeight = height + 70
            self.panModalSetNeedsLayoutUpdate()
            self.panModalTransition(to: .shortForm)
        }
    }
    
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension NotificationDetailsScreen: PanModalPresentable {

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
