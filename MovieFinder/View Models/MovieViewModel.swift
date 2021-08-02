//
//  MovieViewModel.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-29.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieViewModelProtocol {
    var contentDriver: Driver<MovieSearchResult> { get }
}

class MovieViewModel: MovieViewModelProtocol {
    private let _movieSearchResult: MovieSearchResult
    
    private let _contentRelay: BehaviorRelay<MovieSearchResult>
    var contentDriver: Driver<MovieSearchResult>

    static func instantiate(movieSearchResult: MovieSearchResult) -> MovieViewModelProtocol {
        return MovieViewModel(movieSearchResult: movieSearchResult)
    }
    
    init(movieSearchResult: MovieSearchResult) {
        _movieSearchResult = movieSearchResult
        _contentRelay = BehaviorRelay<MovieSearchResult>(value: movieSearchResult)
        contentDriver = _contentRelay.asDriver()
    }
}
