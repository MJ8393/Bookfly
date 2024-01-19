//
//  CustomSegmentControl.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 29/12/23.
//

import Foundation

import UIKit

typealias IndexCallback = (Int, Int) -> Void

class CustomSegmentControl: UIView {
    
    var callback: IndexCallback?
        
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.mainColor,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let attributedString = NSAttributedString(string: "liked".translate(), attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let attributedString = NSAttributedString(string: "buyed".translate(), attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
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
        
        subView.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 2)
        }
        
        subView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(leftButton.snp.right)
            make.right.equalToSuperview()
        }
    }
    
    @objc func leftButtonTapped() {
        callback?(0, 1)
    }
    
    @objc func rightButtonTapped() {
        callback?(1, 0)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.mainColor,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let attributedString = NSAttributedString(string: "buyed".translate(), attributes: attributes)
        rightButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func changeAttributes(c1: UIColor, c2: UIColor) {
        
        let attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: c1,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let attributedString1 = NSAttributedString(string: "Liked", attributes: attributes1)
        leftButton.setAttributedTitle(attributedString1, for: .normal)
        
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: c2,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let attributedString2 = NSAttributedString(string: "Bought", attributes: attributes2)
        rightButton.setAttributedTitle(attributedString2, for: .normal)
        
    }
}
