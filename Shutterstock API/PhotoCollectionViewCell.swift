//
//  PhotoCollectionViewCell.swift
//  Shutterstock API
//
//  Created by Macbook Air 2017 on 27. 2. 2024..
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photoView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(photo: ShutterstockData) {
        APICaller.getPhotoData(url: photo.assets.preview.url, completion: { [weak self] data in
            if let data = data {
                DispatchQueue.main.async {
                    self?.photoView.image = UIImage(data: data)
                }
            } 
        })
    }
}
