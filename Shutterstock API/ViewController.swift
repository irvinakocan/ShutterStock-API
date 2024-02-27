//
//  ViewController.swift
//  Shutterstock API
//
//  Created by Macbook Air 2017 on 27. 2. 2024..
//

import UIKit

class ViewController: UIViewController {
    
    var photos = [ShutterstockData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPurple
        
        getPhotos()
    }
    
    private func getPhotos() {
        APICaller.getPhotos(completion: {[weak self] response in
            self?.photos.append(contentsOf: response?.data ?? [])
        })
    }
}

