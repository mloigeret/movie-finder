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

    private var _currentPage = 1
    private var _couldFetchMoreResults = true

    private let _disposeBag = DisposeBag()
    
    private let _searchSubject: BehaviorSubject<String>
    var searchObserver: AnyObserver<String>

    private let _contentRelay: BehaviorRelay<[MovieSearchResult]>
    var contentDriver: Driver<[MovieSearchResult]>
    
    private let _isLoadingRelay: BehaviorRelay<Bool>
    var isLoadingDriver: Driver<Bool>
    
    private let _willDisplayItemSubject: PublishSubject<Int>
    var willDisplayItemObserver: AnyObserver<Int>
    
    private let _didSelectItemSubject: PublishSubject<Int>
    var didSelectItemObserver: AnyObserver<Int>
    
    private let _requestDetailsSubject: PublishSubject<MovieSearchResult>
    var requestDetailsObservable: Observable<MovieSearchResult>
    
    static func instantiate(apiService: APIServiceProtocol) -> HomeViewModelProtocol {
        return HomeViewModel(apiService: apiService)
    }
    
    init(apiService: APIServiceProtocol) {
        _apiService = apiService
        
        _searchSubject = BehaviorSubject<String>(value: "")
        searchObserver = _searchSubject.asObserver()
        
        _contentRelay = BehaviorRelay<[MovieSearchResult]>(value: [])
        contentDriver = _contentRelay.asDriver()
        
        _isLoadingRelay = BehaviorRelay<Bool>(value: false)
        isLoadingDriver = _isLoadingRelay.asDriver()
        
        _willDisplayItemSubject = PublishSubject<Int>()
        willDisplayItemObserver = _willDisplayItemSubject.asObserver()
        
        _didSelectItemSubject = PublishSubject<Int>()
        didSelectItemObserver = _didSelectItemSubject.asObserver()
        
        _requestDetailsSubject = PublishSubject<MovieSearchResult>()
        requestDetailsObservable = _requestDetailsSubject.asObservable()
        
        setupRx()
    }
    
    private func setupRx() {
        _searchSubject
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] text -> Observable<QueryListResult<MovieSearchResult>> in
                _isLoadingRelay.accept(true)
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
                    !((try? _searchSubject.value().isEmpty) ?? false) &&
                    _couldFetchMoreResults
            }
            .flatMapLatest { [unowned self] _ -> Observable<QueryListResult<MovieSearchResult>> in
                _isLoadingRelay.accept(true)
                _currentPage += 1
                let request = MovieSearchRequest(query: (try? _searchSubject.value()) ?? "",
                                                 page: self._currentPage)
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
            .bind(to: _requestDetailsSubject)
            .disposed(by: _disposeBag)
    }
}
