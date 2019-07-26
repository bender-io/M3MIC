//
//  TenorContoller.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/25/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import FirebaseAuth

class TenorController {
    
    static var shared = TenorController()
    private init(){}
    
    var imageURLs: [String]?
    
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
                var imageURLs: [String] = []
                let topLevelJSON = try JSONDecoder().decode(TopLevelJSON.self, from: data)
                let results = topLevelJSON.results
                for result in results {
                    let media = result.media
                    for gif in media {
                        let tinygif = gif.tinygif
                        let url = tinygif.url
                        imageURLs.append(url)
                    }
                }
                self.imageURLs = imageURLs
                completion(nil)
                
            } catch { completion(error) ; return }
        }.resume()
    }
    
    func fetchImageFromURLs(postUID: String, completion: @escaping(Error?) -> Void) {
        guard let imageURLs = imageURLs else { completion(Errors.unwrapURL) ; return }
        
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.noCurrentUser) ; return }
        
        for imageURL in imageURLs {
            guard let baseURL = URL(string: imageURL) else { completion(Errors.unwrapURL) ; return }
            
            URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                if let error = error {
                    print("Could not unwrap data in \(#function) ; \(error.localizedDescription)")
                    completion(error) ; return
                }
                guard let data = data, let image = UIImage(data: data) else { completion(Errors.unwrapData) ; return }
                
                let reply = Reply(postUID: postUID, userUID: currentUser.uid, imageURL: imageURL, image: image)
                ReplyController.shared.replies.append(reply)
                
            }.resume()
        }
        self.imageURLs?.removeAll()
        print("Generated Reply Models\nRemoved imageURLs from array")
        completion(nil)
    }
}



