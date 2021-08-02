//
//  MovieDetails.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-08-02.
//

import Foundation

struct MovieDetails {
    let title: String
    let overview: String
    let posterPath: String?
    var cast: [CastMember]?
    var crew: [CrewMember]?
    
    init(movieSearchResult: MovieSearchResult) {
        title = movieSearchResult.title
        overview = movieSearchResult.overview
        posterPath = movieSearchResult.posterPath
        cast = nil
        crew = nil
    }
    
    var fullPosterPath: String? {
        get {
            guard let posterPath = posterPath else { return nil }
            return Configuration.tmdb.imgBaseUrl + posterPath
        }
    }
    
    var castString: String? {
        guard let cast = cast else { return nil }
        return cast.map { "\($0.name) (\($0.character))" }.joined(separator: ", ")
    }
    
    var crewString: String? {
        guard let crew = crew else { return nil }
        return crew.map { "\($0.name) (\($0.job))" }.joined(separator: ", ")
    }
}
