//
//  MovieCreditsRequest.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-08-02.
//

import Foundation

class MovieCreditsRequest: APIRequest {
    private let _movieId: Int
    
    var method = RequestType.GET
    var parameters = [String: String]()
    var path: String {
        get {
            return "/movie/\(_movieId)/credits"
        }
    }
    
    init(movieId: Int) {
        _movieId = movieId
        parameters["api_key"] = Configuration.tmdb.apiKey
    }
    
}
