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
    var contentDriver: Driver<[MovieCellModel]> { get }
    var isLoadingDriver: Driver<Bool> { get }
    var willDisplayItemObserver: AnyObserver<Int> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    private var _lastSearchedText: String? = nil
    private var _currentPage = 1
    
    private let _apiService = APIService()
    private let _disposeBag = DisposeBag()
    
    private let _searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return _searchSubject.asObserver()
    }

    private let _contentRelay = BehaviorRelay<[MovieCellModel]>(value: [])
    var contentDriver: Driver<[MovieCellModel]> {
        return _contentRelay
            .asDriver(onErrorJustReturn: [])
    }
    
    private let _isLoadingRelay = BehaviorRelay<Bool>(value: false)
    var isLoadingDriver: Driver<Bool> {
        return _isLoadingRelay
            .asDriver(onErrorJustReturn: false)
    }
    
    private let _willDisplayItemSubject = PublishSubject<Int>()
    var willDisplayItemObserver: AnyObserver<Int> {
        return _willDisplayItemSubject.asObserver()
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
                self._isLoadingRelay.accept(true)
                self._lastSearchedText = text
                self._currentPage = 1
                let request = MovieSearchRequest(query: text, page: self._currentPage)
                return _apiService.send(apiRequest: request)
            }
            .subscribe(onNext: { [unowned self] searchResult in
                let movieCellModels = searchResult.results.map {
                    return MovieCellModel(movieSearchResult: $0)
                }
                self._contentRelay.accept(movieCellModels)
                self._isLoadingRelay.accept(false)
            })
            .disposed(by: _disposeBag)
        
        _willDisplayItemSubject
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .filter { [unowned self] itemIndex in
                _isLoadingRelay.value == false &&
                    itemIndex >= _contentRelay.value.count-5 &&
                    !(self._lastSearchedText?.isEmpty ?? false) // may be use an observable instead
            }
            .flatMapLatest { [unowned self] _ -> Observable<MovieSearchListResult> in
                _isLoadingRelay.accept(true)
                _currentPage += 1
                let request = MovieSearchRequest(query: self._lastSearchedText ?? "", page: self._currentPage)
                return _apiService.send(apiRequest: request)
            }
            .subscribe(onNext: { [unowned self] searchResult in
                let movieCellModels = searchResult.results.map {
                    return MovieCellModel(movieSearchResult: $0)
                }
                self._contentRelay.accept(self._contentRelay.value + movieCellModels)
                self._isLoadingRelay.accept(false)
            })
            .disposed(by: _disposeBag)
    }
}
