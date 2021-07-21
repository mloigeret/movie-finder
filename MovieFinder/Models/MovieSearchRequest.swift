//
//  MovieSearchRequest.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import Foundation

class MovieSearchRequest: APIRequest {
    var method = RequestType.GET
    var path = "search/movie"
    var parameters = [String: String]()
    
    init(query: String) {
        parameters["query"] = query
        parameters["api_key"] = Configuration.tmdb.apiKey
    }
}
