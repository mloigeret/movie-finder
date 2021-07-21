//
//  HomeViewController.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import UIKit

protocol HomeViewControllerProtocol: UIViewController {
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {

    private let _homeViewModel : HomeViewModelProtocol
    
    static func instantiate(viewModel: HomeViewModelProtocol) -> HomeViewControllerProtocol {
        return HomeViewController(viewModel: viewModel)
    }
    
    init(viewModel: HomeViewModelProtocol) {
        _homeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
