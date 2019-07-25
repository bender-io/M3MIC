//
//  TenorContoller.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/25/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

class TenorController {
    
    static var shared = TenorController()
    private init(){}
    
    var replyURLs: [String]?
    
    private let baseURL = URL(string: "https://api.tenor.com/v1")
    private let apiKey = "8ZNGHJOGN4RF"
    
    public func fetchImageURLs(searchTerm: String, completion: @escaping(Error?) -> Void) {
        guard var url = baseURL else { completion(Errors.unwrapURL) ; return }
        
        url.appendPathComponent("search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchQuery = URLQueryItem(name: "q", value: searchTerm)
        let keyQuery = URLQueryItem(name: "key", value: apiKey)
        let limitQuery = URLQueryItem(name: "limit", value: "10")
        components?.queryItems = [searchQuery, keyQuery, limitQuery]
        
        guard let finalURL = components?.url else { completion(Errors.unwrapURL) ; return }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error performing dataTask in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            }
            guard let data = data else { completion(Errors.unwrapData) ; return }
            
            do {
                var replyURLs: [String] = []
                let topLevelJSON = try JSONDecoder().decode(TopLevelJSON.self, from: data)
                let results = topLevelJSON.results
                for result in results {
                    let media = result.media
                    for gif in media {
                        let tinygif = gif.tinygif
                        let url = tinygif.url
                        replyURLs.append(url)
                    }
                }
                self.replyURLs = replyURLs
                completion(nil)
                
            } catch { completion(error) ; return }
        }.resume()
    }
}
