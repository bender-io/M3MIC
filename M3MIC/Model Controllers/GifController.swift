//
//  GifController.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

class GifController {
    
    // MARK: - Properties
    static let shared = GifController()
    private init(){}
    
    var tinyGifs: [String]?
    
    let baseURL = URL(string: "https://api.tenor.com/v1")
    let apiKey = "8ZNGHJOGN4RF"
    
    /// Fetches an array of tinyGif urls and sets its value equal to the tinyGifs SOT array. By default, the query has a limit of 8 gif urls per query.
    ///
    /// - Parameters:
    ///   - searchTerm: determines what the query will search for
    ///   - completion: boolian value determines whether the query succeeded or failed
    func fetchGifURL(searchTerm: String, completion: @escaping(Bool) -> Void) {
        guard var url = baseURL else { completion(false) ; return }
        
        url.appendPathComponent("search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchQuery = URLQueryItem(name: "q", value: searchTerm)
        let keyQuery = URLQueryItem(name: "key", value: apiKey)
        let limitQuery = URLQueryItem(name: "limit", value: "8")
        components?.queryItems = [searchQuery, keyQuery, limitQuery]
        
        guard let finalURL = components?.url else { completion(false) ; return }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("❌ error found in \(#function) ; \(error.localizedDescription) ; \(error)")
                completion(false) ; return
            }
            
            guard let data = data else { print("❌ no data found") ; completion(false) ; return }
            do {
                var tinygifs: [String] = []
                let topLevelJSON = try JSONDecoder().decode(TopLevelJSON.self, from: data)
                let results = topLevelJSON.results
                // TODO: - Resolve Nested For Loops
                for result in results {
                    let media = result.media
                    for gif in media {
                        let tinygif = gif.tinygif
                        let url = tinygif.url
                        tinygifs.append(url)
                    }
                }
                self.tinyGifs = tinygifs
                completion(true)
                
            } catch { print("❌ could not decode topLevelJSON.") ; completion(false) ; return }
        }.resume()
    }
}
