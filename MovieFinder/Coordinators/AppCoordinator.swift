//
//  AppCoordinator.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import UIKit

protocol AppCordinatorProtocol: Coordinator {
}

class AppCoordinator: AppCordinatorProtocol {
    private let _window: UIWindow
    
    static func instantiate(window: UIWindow) -> AppCordinatorProtocol {
        return AppCoordinator(window: window)
    }
    
    init(window: UIWindow) {
        _window = window
    }
    
    func start() {
        let homeViewModel = HomeViewModel.instantiate()
        let homeViewController = HomeViewController.instantiate(viewModel: homeViewModel)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        _window.rootViewController = navigationController
        _window.makeKeyAndVisible()
    }
}
