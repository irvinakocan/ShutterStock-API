//
//  Models.swift
//  Shutterstock API
//
//  Created by Macbook Air 2017 on 27. 2. 2024..
//

import Foundation

struct ShutterstockResponse: Codable {
    let data: [ShutterstockData]
}

struct ShutterstockData: Codable {
    let assets: Assets
    let description: String
}

struct Assets: Codable {
    let preview: Preview
}

struct Preview: Codable {
    let url: String
}
