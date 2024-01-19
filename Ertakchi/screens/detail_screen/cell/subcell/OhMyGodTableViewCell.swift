//
//  OhMyGodTableViewCell.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 07/01/24.
//

import UIKit

class OhMyGodTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(5)
        }
    }

}
