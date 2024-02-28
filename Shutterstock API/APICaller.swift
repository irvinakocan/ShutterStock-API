//
//  APICaller.swift
//  Shutterstock API
//
//  Created by Macbook Air 2017 on 27. 2. 2024..
//

import Foundation

class APICaller {
    
    private static var page: Int = 1
    
    static var isPaginating = false 
    
    static func getPhotos(pagination: Bool = false, completion: @escaping (ShutterstockResponse?) -> Void) {
        
        if pagination {
            isPaginating = true 
        }
        
        var urlComponents = URLComponents(string: SHUTTERSTOCK_API + GET_IMAGES_ENDPOINT)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: "black cat"),
            URLQueryItem(name: "orientation", value: "horizontal"),
            URLQueryItem(name: "sort", value: "popular"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = urlComponents?.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer " + SHUTTERSTOCK_API_TOKEN, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, response, error in
            
            if error != nil {
                print("Error occured.")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Invalid status code.")
                return
            }
            
            if let data = data {
                guard let decodedData = try? JSONDecoder().decode(ShutterstockResponse.self, from: data) else {
                    print("Decoding error.")
                    return
                }
                completion(decodedData)
                isPaginating = false 
            }
        })
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2), execute: {
            task.resume()
        })
        page += 1
    }
    
    static func getPhotoData(url: String, completion: @escaping (Data?) -> Void) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            completion(data)
        })
        task.resume()
    }
}
