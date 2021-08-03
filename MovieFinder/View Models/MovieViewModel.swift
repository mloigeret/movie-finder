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
    var willDisplaySimilarItemObserver: AnyObserver<Int> { get }
    var didSelectSimilarObserver: AnyObserver<Int> { get }
    var requestDetailsObservable: Observable<MovieSearchResult> { get }
}

class MovieViewModel: MovieViewModelProtocol {
    private let _movieSearchResult: MovieSearchResult
    private let _apiService: APIServiceProtocol
    
    private var _currentPage = 1
    private var _isLoadingSimilars: Bool = false
    private var _couldFetchMoreSimilars: Bool = true
    
    private let _detailsRelay: BehaviorRelay<MovieDetails>
    var detailsDriver: Driver<MovieDetails>
    
    private let _similarMoviesRelay: BehaviorRelay<[MovieSearchResult]>
    var similarMoviesDriver: Driver<[MovieSearchResult]>
    
    private let _willDisplaySimilarItemSubject: PublishSubject<Int>
    var willDisplaySimilarItemObserver: AnyObserver<Int>
    
    private let _didSelectSimilarSubject: PublishSubject<Int>
    var didSelectSimilarObserver: AnyObserver<Int>
    
    private let _requestDetailsSubject: PublishSubject<MovieSearchResult>
    var requestDetailsObservable: Observable<MovieSearchResult>
    
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
        
        _willDisplaySimilarItemSubject = PublishSubject<Int>()
        willDisplaySimilarItemObserver = _willDisplaySimilarItemSubject.asObserver()
        
        _didSelectSimilarSubject = PublishSubject<Int>()
        didSelectSimilarObserver = _didSelectSimilarSubject.asObserver()
        
        _requestDetailsSubject = PublishSubject<MovieSearchResult>()
        requestDetailsObservable = _requestDetailsSubject.asObservable()
        
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
        _isLoadingSimilars = true
        let request = SimilarMoviesRequest(movieId: _movieSearchResult.id,
                                           page: _currentPage)
        let query = _apiService.send(apiRequest: request) as Observable<QueryListResult<MovieSearchResult>>
        query.subscribe(onNext: { [unowned self] result in
            for m in result.results {
                print(m.title)
            }
            _similarMoviesRelay.accept(result.results)
            _isLoadingSimilars = false
        })
        .disposed(by: _disposeBag)
        
        //subscribe to _willDisplaySimilarItemSubject for pagination
        _willDisplaySimilarItemSubject
            .asObservable()
            .distinctUntilChanged()
            .filter { [unowned self] itemIndex in
                _isLoadingSimilars == false &&
                    itemIndex >= _similarMoviesRelay.value.count-5 &&
                    _couldFetchMoreSimilars
            }
            .flatMapLatest { [unowned self] _ -> Observable<QueryListResult<MovieSearchResult>> in
                _isLoadingSimilars = true
                _currentPage += 1
                let request = SimilarMoviesRequest(movieId: _movieSearchResult.id,
                                                   page: _currentPage)
                return _apiService.send(apiRequest: request)
            }
            .subscribe (onNext: { [unowned self] result in
                if result.results.count == 0 {
                    _couldFetchMoreSimilars = false
                }
                _similarMoviesRelay.accept(_similarMoviesRelay.value + result.results)
                _isLoadingSimilars = false
            })
            .disposed(by: _disposeBag)
        
        _didSelectSimilarSubject
            .asObservable()
            .flatMapLatest { [unowned self] index -> Observable<MovieSearchResult> in
                return Observable.of(_similarMoviesRelay.value[index])
            }
            .bind(to: _requestDetailsSubject)
            .disposed(by: _disposeBag)
    }
}
