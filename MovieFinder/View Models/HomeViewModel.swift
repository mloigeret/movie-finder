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
    var contentDriver: Driver<[MovieSearchResult]> { get }
    var isLoadingDriver: Driver<Bool> { get }
    var willDisplayItemObserver: AnyObserver<Int> { get }
    var didSelectItemObserver: AnyObserver<Int> { get }
    var requestDetailsObservable: Observable<MovieSearchResult> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    private let _apiService: APIServiceProtocol
    
    private var _lastSearchedText: String? = nil
    private var _currentPage = 1
    private var _couldFetchMoreResults = true

    private let _disposeBag = DisposeBag()
    
    private let _searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return _searchSubject.asObserver()
    }

    private let _contentRelay = BehaviorRelay<[MovieSearchResult]>(value: [])
    var contentDriver: Driver<[MovieSearchResult]> {
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
    
    private let _didSelectItemSubject = PublishSubject<Int>()
    var didSelectItemObserver: AnyObserver<Int> {
        return _didSelectItemSubject.asObserver()
    }
    
    private let _requestDetails = PublishSubject<MovieSearchResult>()
    var requestDetailsObservable: Observable<MovieSearchResult> {
        return _requestDetails.asObservable()
    }
    
    static func instantiate(apiService: APIServiceProtocol) -> HomeViewModelProtocol {
        return HomeViewModel(apiService: apiService)
    }
    
    init(apiService: APIServiceProtocol) {
        _apiService = apiService
        _searchSubject
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] text -> Observable<MovieSearchListResult> in
                _isLoadingRelay.accept(true)
                _lastSearchedText = text
                _currentPage = 1
                _couldFetchMoreResults = true
                
                let request = MovieSearchRequest(query: text, page: self._currentPage)
                return _apiService.send(apiRequest: request)
            }
            .subscribe(onNext: { [unowned self] searchResult in
                self._contentRelay.accept(searchResult.results)
                self._isLoadingRelay.accept(false)
            })
            .disposed(by: _disposeBag)
        
        _searchSubject
            .asObservable()
            .filter { $0.isEmpty }
            .subscribe(onNext: { [unowned self] _ in
                self._contentRelay.accept([])
                self._isLoadingRelay.accept(false)
            })
            .disposed(by: _disposeBag)

        _willDisplayItemSubject
            .asObservable()
            .distinctUntilChanged()
            .filter { [unowned self] itemIndex in
                _isLoadingRelay.value == false &&
                    itemIndex >= _contentRelay.value.count-5 &&
                    !(self._lastSearchedText?.isEmpty ?? false) && // may be use an observable instead
                    _couldFetchMoreResults
            }
            .flatMapLatest { [unowned self] _ -> Observable<MovieSearchListResult> in
                _isLoadingRelay.accept(true)
                _currentPage += 1
                let request = MovieSearchRequest(query: self._lastSearchedText ?? "", page: self._currentPage)
                return _apiService.send(apiRequest: request)
            }
            .subscribe(onNext: { [unowned self] searchResult in
                if searchResult.results.count == 0 {
                    _couldFetchMoreResults = false
                }
                self._contentRelay.accept(self._contentRelay.value + searchResult.results)
                self._isLoadingRelay.accept(false)
            })
            .disposed(by: _disposeBag)
        
        _didSelectItemSubject
            .asObservable()
            .flatMapLatest { [unowned self] index -> Observable<MovieSearchResult> in
                return Observable.of(_contentRelay.value[index])
            }
            .bind(to: _requestDetails)
            .disposed(by: _disposeBag)
    }
}
