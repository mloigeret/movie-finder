//
//  SimilarMoviesRequest.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-08-02.
//

import Foundation

class SimilarMoviesRequest: APIRequest {
    private let _movieId: Int
    
    var method = RequestType.GET
    var parameters = [String: String]()
    var path: String {
        get {
            return "/movie/\(_movieId)/similar"
        }
    }
    
    init(movieId: Int, page: Int) {
        _movieId = movieId
        parameters["api_key"] = Configuration.tmdb.apiKey
        parameters["page"] = String(page)
    }
}
