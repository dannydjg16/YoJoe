//
//  MikesAPIClient.swift
//  MoJoe
//
//  Created by Daniel Grant on 7/8/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//


import Foundation

// MARK: Typealias
typealias ResultHandler = (Result<Any, StandardError>) -> Void

class APIClient {
    
    // MARK: Static Variables
     static let shared: APIClient = APIClient()
    
    
    // MARK: Result
    private init() { }

}


// MARK: Networking
extension APIClient {
    
    
    
    func GET(endpoint: String, resultHander: @escaping ResultHandler) {
       
        let baseEndpoint = "https://api.yelp.com/v3/businesses/search?"
        
        guard let url = URL(string: baseEndpoint + endpoint) else {
            resultHander(.failure(StandardError()))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer FEyTy5mZtoHlI9lx9n38gQucETRaC7sD_mvzpa-SXnqKLNNXgc56OyUdAxTFnfXHSVSXvmjTHN5SkuCktUhTgR62RRsBmqj_c_doCDRDXl_p55GHlP5Ni8LZ_B0tXXYx", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    resultHander(.failure(StandardError()))
                    return
            }
            
            DispatchQueue.main.async {
                
                resultHander(.success(json))
                
            }
        })
        
        task.resume()
    }
    
}

// MARK: Error Implementation
struct StandardError: Error {
    
    // MARK: Static Variables
    static let reason: String = "Error"
    
}
