//
//  Gif.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

struct TopLevelJSON: Codable {
    let results: [JSONResult]
}

struct JSONResult: Codable {
    let media: [GifDictionary]
}

struct GifDictionary: Codable {
    let tinygif: TinyGif
}

struct TinyGif: Codable {
    let url: String
}
