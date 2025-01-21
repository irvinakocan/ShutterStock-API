//
//  ViewController.swift
//  Shutterstock API
//
//  Created by Macbook Air 2017 on 27. 2. 2024..
//

import UIKit

class ViewController: UIViewController {
    
    private var photos = [ShutterstockData]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 10,
                                 height: UIScreen.main.bounds.width/2 - 10)
        layout.sectionInset = UIEdgeInsets(top: 5,
                                           left: 5,
                                           bottom: 5,
                                           right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setCollectionView()
    }
    
    private func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame = view.bounds
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(photo: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter, APICaller.isPaginating {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: FooterCollectionReusableView.identifier,
                for: indexPath)
            return footer
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if APICaller.isPaginating {
            // Show the footer with a height of 60 when paginating
            return CGSize(width: view.frame.size.width, height: 60)
        } else {
            // Remove the footer by setting its height to 0
            return CGSize(width: 0, height: 0)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        
        guard APICaller.isPaginating == false else {
            return
        }
        
        // Reloading the layout to reload the footer
        collectionView.collectionViewLayout.invalidateLayout()
        
        if position >= collectionView.contentSize.height - scrollView.frame.size.height {
            
            APICaller.getPhotos(completion: { [weak self] response in
                if let response = response {
                    self?.photos.append(contentsOf: response.data)
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        self?.collectionView.collectionViewLayout.invalidateLayout()
                    }
                }
            })
        }
    }
}
