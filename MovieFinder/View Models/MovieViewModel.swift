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
    var detailsDriver: Driver<MovieDetails> { get }
    var similarMoviesDriver: Driver<[MovieSearchResult]> { get }
}

class MovieViewModel: MovieViewModelProtocol {
    private let _movieSearchResult: MovieSearchResult
    private let _apiService: APIServiceProtocol
    
    private let _detailsRelay: BehaviorRelay<MovieDetails>
    var detailsDriver: Driver<MovieDetails>
    
    private let _similarMoviesRelay: BehaviorRelay<[MovieSearchResult]>
    var similarMoviesDriver: Driver<[MovieSearchResult]>
    
    private let _disposeBag = DisposeBag()

    static func instantiate(movieSearchResult: MovieSearchResult,
                            apiService: APIServiceProtocol) -> MovieViewModelProtocol {
        return MovieViewModel(movieSearchResult: movieSearchResult,
                              apiService: apiService)
    }
    
    init(movieSearchResult: MovieSearchResult,
         apiService: APIServiceProtocol) {
        
        _apiService = apiService
        _movieSearchResult = movieSearchResult

        _detailsRelay = BehaviorRelay<MovieDetails>(value: MovieDetails(movieSearchResult: movieSearchResult))
        detailsDriver = _detailsRelay.asDriver()

        _similarMoviesRelay = BehaviorRelay<[MovieSearchResult]>(value: [])
        similarMoviesDriver = _similarMoviesRelay.asDriver()
        
        loadCredits()
        loadSimilarMovies()
    }
    
    private func loadCredits() {
        let request = MovieCreditsRequest(movieId: _movieSearchResult.id)
        let query = _apiService.send(apiRequest: request) as Observable<MovieCreditsResult>
        query.subscribe(onNext: { [unowned self] creditsResult in
            var movieDetails = _detailsRelay.value
            movieDetails.cast = creditsResult.cast
            movieDetails.crew = creditsResult.crew
            _detailsRelay.accept(movieDetails)
        })
        .disposed(by: _disposeBag)
    }
    
    private func loadSimilarMovies() {
        let request = SimilarMoviesRequest(movieId: _movieSearchResult.id)
        let query = _apiService.send(apiRequest: request) as Observable<QueryListResult<MovieSearchResult>>
        query.subscribe(onNext: { [unowned self] result in
            for m in result.results {
                print(m.title)
            }
            _similarMoviesRelay.accept(result.results)
        })
        .disposed(by: _disposeBag)
    }
}
