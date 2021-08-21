//
//  HomeViewController.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeViewControllerProtocol: UITableViewController {
}

class HomeViewController: UITableViewController, HomeViewControllerProtocol {

    private struct Constants {
        static let cellIdentifier = "movieCellIdentifier"
    }
    
    private let _searchController = UISearchController(searchResultsController: nil)
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
        configureRx()
    }
    
    private func configureProperties() {
        //title
        navigationItem.title = "Movie Finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //search
        _searchController.searchBar.placeholder = "Search for movies"
        _searchController.searchBar.returnKeyType = .done
        _searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = _searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //table
        tableView.register(MovieTableViewCell.self,
                            forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = 140
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func configureRx() {
        _searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .bind(to: _homeViewModel.searchObserver)
            .disposed(by: _disposeBag)
        
        _searchController.searchBar.rx.text.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                tableView.setContentOffset(.zero, animated: true)
            })
            .disposed(by: _disposeBag)
        
        tableView.rx.willDisplayCell
            .flatMap({ cell, indexPath -> Observable<Int> in
                return Observable.just(indexPath.row)
            })
            .bind(to: _homeViewModel.willDisplayItemObserver)
            .disposed(by: _disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] indexPath in
                tableView.cellForRow(at: indexPath)?.isSelected = false
                _homeViewModel.didSelectItemObserver.onNext(indexPath.row)
            })
            .disposed(by: _disposeBag)
        
        _homeViewModel.isLoadingDriver
            .drive(onNext: { [unowned self] isLoading in
                _searchController.searchBar.isLoading = isLoading
            })
            .disposed(by: _disposeBag)
        
        _homeViewModel.contentDriver.drive(tableView.rx.items(cellIdentifier: Constants.cellIdentifier)) {
            (index, movie: MovieSearchResult, cell: MovieTableViewCell) in
            cell.configure(movie: movie)
        }
        .disposed(by: _disposeBag)
    }
}
