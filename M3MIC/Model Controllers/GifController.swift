//
//  GifController.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import UserNotifications

class GifController {
    
    // MARK: - Properties
    static let shared = GifController()
    private init(){}
    
    var gifs: [String]?
    
    var gifReplyArray = [UIImage]()
    var gifPostImage: UIImage?
       
    var gifSearchArray = [UIImage]()
    var gifFunnyArray = [UIImage]()
    var gifCoolArray = [UIImage]()
    var gifHappyArray = [UIImage]()
    var gifSadArray = [UIImage]()
    var gifHungryArray = [UIImage]()
    var gifAngryArray = [UIImage]()
    var gifLoveArray = [UIImage]()

    // var replyImage: [ReplyImage]?
    // ReplyImage(replyImageURL: String, replyImage: UIImage?)
    
    let baseURL = URL(string: "https://api.tenor.com/v1")
    let apiKey = "8ZNGHJOGN4RF"
    
    /// Fetches an array of tinyGif urls and sets its value equal to the tinyGifs SOT array. By default, the query has a limit of 8 gif urls per query.
    ///
    /// - Parameters:
    ///   - searchTerm: determines what the query will search for
    ///   - completion: boolian value determines whether the query succeeded or failed
    func fetchGifUrls(searchTerm: String, completion: @escaping(Bool) -> Void) {
        guard var url = baseURL else { completion(false) ; return }
        
        url.appendPathComponent("search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchQuery = URLQueryItem(name: "q", value: searchTerm)
        let keyQuery = URLQueryItem(name: "key", value: apiKey)
        let limitQuery = URLQueryItem(name: "limit", value: "10")
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
                self.gifs = tinygifs
                completion(true)
                
            } catch { print("❌ could not decode topLevelJSON.") ; completion(false) ; return }
        }.resume()
    }
    
    func fetchGifsFromFSURLs(completion: @escaping(Bool) -> Void) {
    
        let replies = ReplyController.shared.replies
        gifReplyArray.removeAll()
        
        for reply in replies {
            guard let baseURL = URL(string: reply.imageURL) else { completion(false) ; return }
            
            URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                if let error = error {
                    print("❌ could not unwrap data in \(#function) ; \(error.localizedDescription) ; \(error)")
                    completion(false) ; return
                }
                
                guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                
                self.gifReplyArray.append(gif)
                
                if self.gifReplyArray.count == replies.count {
                    print("Image Fetch Complete!")
                    completion(true)
                }
            }.resume()
        }
    }
    
    func fetchTopReplyImageFrom(url: String, completion: @escaping(UIImage?) -> Void) {
        guard let baseURL = URL(string: url) else { completion(nil) ; return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("❌ could not unwrap data in \(#function) ; \(error.localizedDescription) ; \(error)")
                completion(nil) ; return
            }
            
            guard let data = data, let gif = UIImage(data: data) else { completion(nil) ; return }
            
            completion(gif)
            
            }.resume()
    }
    
    func fetchGifsFromUrls(tinygifs: [String], category: String, completion: @escaping(Bool) -> Void) {
        
        guard let gifs = gifs else { completion(false) ; return }
        
        switch category {
            
        case "funny":
            
            if gifFunnyArray.count < 10 {
                for gif in gifs {
                    guard let baseURL = URL(string: gif) else { completion(false) ; return }
                    
                    URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                        if let error = error {
                            print("❌ could not unwrap \(String(describing: category)) data in \(#function) ; \(error.localizedDescription) ; \(error)")
                            completion(false) ; return
                        }
                        guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                        
                        self.gifFunnyArray.append(gif)
                        
                        if self.gifFunnyArray.count == 10 {
                            print("[🤪Image] Complete!")
                            completion(true)
                        }
                    }.resume()
                }
            }
            
            
            
        case "cool":
            
            if gifCoolArray.count < 10 {
                for gif in gifs {
                    guard let baseURL = URL(string: gif) else { completion(false) ; return }
                    
                    URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                        if let error = error {
                            print("❌ could not unwrap \(String(describing: category)) data in \(#function) ; \(error.localizedDescription) ; \(error)")
                            completion(false) ; return
                        }
                        guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                        
                        self.gifCoolArray.append(gif)
                        if self.gifCoolArray.count == 10 {
                            print("[😎Image] Complete!")
                            completion(true)
                        }
                        
                    }.resume()
                }
            }

        case "happy":
            
            if gifHappyArray.count < 10 {
                for gif in gifs {
                    guard let baseURL = URL(string: gif) else { completion(false) ; return }
                    
                    URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                        if let error = error {
                            print("❌ could not unwrap \(String(describing: category)) data in \(#function) ; \(error.localizedDescription) ; \(error)")
                            completion(false) ; return
                        }
                        guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                        
                        self.gifHappyArray.append(gif)
                        if self.gifHappyArray.count == 10 {
                            print("[☀️Image] Complete!")
                            completion(true)
                        }
                        
                    }.resume()
                }
            }

        case "sad":
            
            if gifSadArray.count < 10 {
                for gif in gifs {
                    guard let baseURL = URL(string: gif) else { completion(false) ; return }
                    
                    URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                        if let error = error {
                            print("❌ could not unwrap \(String(describing: category)) data in \(#function) ; \(error.localizedDescription) ; \(error)")
                            completion(false) ; return
                        }
                        guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                        
                        self.gifSadArray.append(gif)
                        if self.gifSadArray.count == 10 {
                            print("[😢Image] Complete!")
                            completion(true)
                        }
                        
                    }.resume()
                }
            }

        case "hungry":
            
            if gifHungryArray.count < 10 {
                for gif in gifs {
                    guard let baseURL = URL(string: gif) else { completion(false) ; return }
                    
                    URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                        if let error = error {
                            print("❌ could not unwrap \(String(describing: category)) data in \(#function) ; \(error.localizedDescription) ; \(error)")
                            completion(false) ; return
                        }
                        guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                        
                        self.gifHungryArray.append(gif)
                        if self.gifSadArray.count == 10 {
                            print("[🍔Image] Complete!")
                            completion(true)
                        }
                        
                    }.resume()
                }
            }

        case "angry":
            
            if gifAngryArray.count < 10 {
                for gif in gifs {
                    guard let baseURL = URL(string: gif) else { completion(false) ; return }
                    
                    URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                        if let error = error {
                            print("❌ could not unwrap \(String(describing: category)) data in \(#function) ; \(error.localizedDescription) ; \(error)")
                            completion(false) ; return
                        }
                        guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                        
                        self.gifAngryArray.append(gif)
                        if self.gifAngryArray.count == 10 {
                            print("[😡Image] Complete!")
                            completion(true)
                        }

                    }.resume()
                }
            }

            
            
        case "love":
            
            if gifLoveArray.count < 10 {
                for gif in gifs {
                    guard let baseURL = URL(string: gif) else { completion(false) ; return }
                    
                    URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                        if let error = error {
                            print("❌ could not unwrap \(String(describing: category)) data in \(#function) ; \(error.localizedDescription) ; \(error)")
                            completion(false) ; return
                        }
                        guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                        
                        self.gifLoveArray.append(gif)
                        if self.gifLoveArray.count == 10 {
                            print("[💗Image] Complete!")
                            completion(true)
                        }

                    }.resume()
                }
            }
            
        default:
            
            self.gifSearchArray.removeAll()
            
            for gif in gifs {
                guard let baseURL = URL(string: gif) else { completion(false) ; return }
                
                URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
                    if let error = error {
                        print("❌ could not unwrap \(String(describing: category)) in \(#function) ; \(error.localizedDescription) ; \(error)")
                        completion(false) ; return
                    }
                    guard let data = data, let gif = UIImage(data: data) else { completion(false) ; return }
                    
                    self.gifSearchArray.append(gif)
                    if self.gifSearchArray.count == 10 {
                        print("[search] Complete!")
                        completion(true)
                    }
                }.resume()
            }
        }
    }
}
