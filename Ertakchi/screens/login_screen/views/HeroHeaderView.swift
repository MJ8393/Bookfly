//
//  HeroHeaderView.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 05/01/24.
//

import UIKit

class HeroHeaderView: UIView {
    
    var isViewLoaded: Bool = false
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "starting")!
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isViewLoaded == false {
            imageView.frame = bounds
            addGradient()  // Move the call to addGradient here
            isViewLoaded = true
        }
    }
    
    
    private func applyConstraints() {
        // Add your constraints here if needed
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = bounds
//        gradientLayer.locations = [0.0, 1.2]
        layer.addSublayer(gradientLayer)
    }
}
