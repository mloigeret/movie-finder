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

    private struct Constants {
        static let cellIdentifier = "movieCellIdentifier"
    }
    
    private let _searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for movies"
        return searchController
    }()
    private let _tableView = UITableView()
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
        configureProperties()
        configureLayout()
    }
    
    private func configureProperties() {
        //title
        navigationItem.title = "Movie Finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //table view
        _tableView.register(UITableViewCell.self,
                            forCellReuseIdentifier: Constants.cellIdentifier)
        
        //search
        navigationItem.searchController = _searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureLayout() {
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_tableView)
        NSLayoutConstraint.activate([
            _tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            _tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            _tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        _tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
}
