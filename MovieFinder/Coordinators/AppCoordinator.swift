//
//  AppCoordinator.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import UIKit
import RxSwift

protocol AppCordinatorProtocol: Coordinator {
}

class AppCoordinator: AppCordinatorProtocol {
    private let _window: UIWindow
    private var _navigationController: UINavigationController?
    private let _apiService: APIServiceProtocol = APIService.instantiate()
    private let _disposeBag = DisposeBag()
    
    static func instantiate(window: UIWindow) -> AppCordinatorProtocol {
        return AppCoordinator(window: window)
    }
    
    init(window: UIWindow) {
        _window = window
    }
    
    func start() {
        let homeViewModel = HomeViewModel.instantiate(apiService: _apiService)
        homeViewModel.requestDetailsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movieSearchResult in
                showDetailsViewController(movieSearchResult: movieSearchResult)
            })
            .disposed(by: _disposeBag)
        let homeViewController = HomeViewController.instantiate(viewModel: homeViewModel)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.view.backgroundColor = .white
        _navigationController = navigationController
        _window.rootViewController = navigationController
        _window.makeKeyAndVisible()
    }
    
    private func showDetailsViewController(movieSearchResult: MovieSearchResult) {
        let movieVM = MovieViewModel.instantiate(movieSearchResult: movieSearchResult, apiService: _apiService)
        let movieVC = MovieViewController.instantiate(movieViewModel: movieVM)
        _navigationController?.show(movieVC, sender: nil)
    }
}
