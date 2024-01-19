//
//  HeaderView.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 09/01/24.
//

import UIKit

class HeaderView: UIView {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Popular searches"
        label.textColor = .label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(7.5)
            make.bottom.equalToSuperview().offset(0)
        }
    }
}
