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
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.register(FooterCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterCollectionReusableView.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        
        getPhotos()
        setCollectionView()
    }
    
    private func getPhotos() {
        APICaller.getPhotos(completion: {[weak self] response in
            self?.photos.append(contentsOf: response?.data ?? [])
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
    }
    
    private func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = photos[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(photo: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterCollectionReusableView.identifier,
            for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width,
                      height: 50)
    }
}

// Checking scroll position
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height - scrollView.frame.size.height) {
            
            guard APICaller.isPaginating == false else {
                return
            }
                                        
            APICaller.getPhotos(pagination: true, completion: { [weak self] response in
                self?.photos.append(contentsOf: response?.data ?? [])
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            })
        }
    }
}
