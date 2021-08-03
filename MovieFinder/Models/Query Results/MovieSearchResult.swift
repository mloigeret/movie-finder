//
//  MovieSearchResult.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import Foundation

struct MovieSearchResult: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    
    var fullPosterPath: String? {
        get {
            guard let posterPath = posterPath else { return nil }
            return Configuration.tmdb.imgBaseUrl + posterPath
        }
    }
}
