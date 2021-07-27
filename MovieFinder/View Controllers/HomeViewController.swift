//
//  HomeViewController.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeViewControllerProtocol: UIViewController {
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {

    private struct Constants {
        static let cellIdentifier = "movieCellIdentifier"
    }
    
    private let _searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for movies"
        searchController.searchBar.returnKeyType = .done
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private let _tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self,
                           forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.rowHeight = 85
        tableView.keyboardDismissMode = .onDrag
        return tableView
        
    }()
    
    private let _homeViewModel : HomeViewModelProtocol
    private let _disposeBag = DisposeBag()

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
        configureSearch()
        configureObservers()
    }
    
    private func configureProperties() {
        //title
        navigationItem.title = "Movie Finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
    
    private func configureSearch() {
        _searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .bind(to: _homeViewModel.searchObserver)
            .disposed(by: _disposeBag)
        
        _tableView.rx.willDisplayCell
            .flatMap({ cell, indexPath -> Observable<Int> in
                return Observable.just(indexPath.row)
            })
            .bind(to: _homeViewModel.willDisplayItemObserver)
            .disposed(by: _disposeBag)
    }
    
    private func configureObservers() {
        _homeViewModel.contentDriver.drive(_tableView.rx.items(cellIdentifier: Constants.cellIdentifier)) {
            (index, model: MovieCellModel, cell: MovieTableViewCell) in
            cell.configure(model: model)
        }
        .disposed(by: _disposeBag)
    }
}
