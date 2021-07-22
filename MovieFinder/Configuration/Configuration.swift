//
//  Configuration.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import Foundation

struct Configuration {
    struct tmdb {
        static let apiKey = ApiKey.tmdb
        static let baseUrl = "https://api.themoviedb.org/3"
        static let imgBaseUrl = "https://image.tmdb.org/t/p/w500"
    }
}
