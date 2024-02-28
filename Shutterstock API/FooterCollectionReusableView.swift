//
//  FooterCollectionReusableView.swift
//  Shutterstock API
//
//  Created by Macbook Air 2017 on 28. 2. 2024..
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "FooterCollectionReusableView"
    
    public let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .green
        spinner.startAnimating()
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
