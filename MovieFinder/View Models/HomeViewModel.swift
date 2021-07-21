//
//  HomeViewModel.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelProtocol {
    var searchObserver: AnyObserver<String> { get }
    var content: Driver<[MovieSearchResult]> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    
    private let _apiService = APIService()
    private let _disposeBag = DisposeBag()
    
    private let _searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return _searchSubject.asObserver()
    }
    
    private let _contentSubject = PublishSubject<[MovieSearchResult]>()
    var content: Driver<[MovieSearchResult]> {
        return _contentSubject
            .asDriver(onErrorJustReturn: [])
    }
    
    
    static func instantiate() -> HomeViewModelProtocol {
        return HomeViewModel()
    }
    
    init() {
        _searchSubject
            .asObservable()
                    .filter { !$0.isEmpty }
                    .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] text -> Observable<MovieSearchListResult> in
                let request = MovieSearchRequest(query: text)
                return _apiService.send(apiRequest: request)
            }
            
            .subscribe(onNext: { [unowned self] searchResult in
                
                for movie in searchResult.results {
                    print(movie.title)
                }
                
                self._contentSubject.onNext(searchResult.results)
            })
            .disposed(by: _disposeBag)
    }

}
