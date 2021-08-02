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
    var details: Driver<MovieDetails> { get }
   // var castDriver: Driver<[CastMember]> { get }
}

class MovieViewModel: MovieViewModelProtocol {
    private let _movieSearchResult: MovieSearchResult
    private let _apiService: APIServiceProtocol
    
    private let _details: BehaviorRelay<MovieDetails>
    var details: Driver<MovieDetails>
    
//    private let _castRelay: BehaviorRelay<[CastMember]>
//    var castDriver: Driver<[CastMember]>
    
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

        _details = BehaviorRelay<MovieDetails>(value: MovieDetails(movieSearchResult: movieSearchResult))
        details = _details.asDriver()
//        _castRelay = BehaviorRelay<[CastMember]>(value: [])
//        castDriver = _castRelay.asDriver()

        
        
        loadCredits()
    }
    
    private func loadCredits() {
        let request = MovieCreditsRequest(movieId: _movieSearchResult.id)
        let query = _apiService.send(apiRequest: request) as Observable<MovieCreditsResult>
        query.subscribe(onNext: { [unowned self] creditsResult in
            var movieDetails = _details.value
            movieDetails.cast = creditsResult.cast
            movieDetails.crew = creditsResult.crew
            _details.accept(movieDetails)
        })
        .disposed(by: _disposeBag)
    }
}
