//
//  MovieCellModel.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-22.
//

import UIKit

struct MovieCellModel {
    let title: String
    let overview: String
    let color: UIColor
    let imageURL: URL?
    
    init(movieSearchResult: MovieSearchResult) {
        title = movieSearchResult.title
        overview = movieSearchResult.overview
        color = .yellow
        imageURL = MovieCellModel.getImageURL(path: movieSearchResult.posterPath)
    }
    
    private static func getImageURL(path: String?) -> URL? {
        if let path = path,
           let url = URL(string: Configuration.tmdb.imgBaseUrl + path) {
            return url
        }
        return nil
    }
}
