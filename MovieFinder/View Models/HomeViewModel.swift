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
    var content: Driver<[MovieCellModel]> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    private let _apiService = APIService()
    private let _disposeBag = DisposeBag()
    
    private let _searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return _searchSubject.asObserver()
    }
    
    private let _contentSubject = PublishSubject<[MovieCellModel]>()
    var content: Driver<[MovieCellModel]> {
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
                let movieCellModels = searchResult.results.map {
                    return MovieCellModel(title: $0.title,
                                          overview: $0.overview,
                                          color: .yellow,
                                          imageURL: getImageURL(path: $0.posterPath))
                }
                self._contentSubject.onNext(movieCellModels)
            })
            .disposed(by: _disposeBag)
    }
    
    private func getImageURL(path: String?) -> URL? {
        if let path = path,
           let url = URL(string: Configuration.tmdb.imgBaseUrl + path) {
            return url
        }
        return nil
    }
}
