//
//  MovieViewController.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-29.
//

import UIKit
import RxSwift

protocol MovieViewControllerProtocol: UIViewController {
}

class MovieViewController: UIViewController, MovieViewControllerProtocol {

    private let _scrollView = UIScrollView()
    private let _scrollViewContent = UIView()
    private let _movieDetailsView = MovieDetailsView()
    private let _similarCollectionView = UICollectionView()
    
    private let _movieViewModel: MovieViewModelProtocol
    private let _disposeBag = DisposeBag()
    
    static func instantiate(movieViewModel: MovieViewModelProtocol) -> MovieViewControllerProtocol {
        return MovieViewController(movieViewModel: movieViewModel)
    }
    
    init(movieViewModel: MovieViewModelProtocol) {
        _movieViewModel = movieViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        configureLayout()
        configureRx()
    }
    
    private func configureProperties() {
        //title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //background
        view.backgroundColor = .red
        _movieDetailsView.backgroundColor = .blue
        _similarCollectionView.backgroundColor = .green
    }
    
    private func configureLayout() {
        _scrollView.translatesAutoresizingMaskIntoConstraints = false
        _scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        _movieDetailsView.translatesAutoresizingMaskIntoConstraints = false
        _similarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(_scrollView)
        _scrollView.addSubview(_scrollViewContent)
        _scrollViewContent.addSubview(_movieDetailsView)
        _scrollViewContent.addSubview(_similarCollectionView)
        
        let scrollViewContentHeightConstraint = _scrollViewContent.heightAnchor.constraint(greaterThanOrEqualTo: _scrollView.heightAnchor)
        scrollViewContentHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            _scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            _scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            _scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            _scrollViewContent.topAnchor.constraint(equalTo: _scrollView.topAnchor),
            _scrollViewContent.leftAnchor.constraint(equalTo: _scrollView.leftAnchor),
            _scrollViewContent.rightAnchor.constraint(equalTo: _scrollView.rightAnchor),
            _scrollViewContent.bottomAnchor.constraint(equalTo: _scrollView.bottomAnchor),
            _scrollViewContent.widthAnchor.constraint(equalTo: _scrollView.widthAnchor),
            scrollViewContentHeightConstraint,
            
            _movieDetailsView.topAnchor.constraint(equalTo: _scrollViewContent.topAnchor),
            _movieDetailsView.leftAnchor.constraint(equalTo: _scrollViewContent.leftAnchor),
            _movieDetailsView.rightAnchor.constraint(equalTo: _scrollViewContent.rightAnchor),
            _movieDetailsView.heightAnchor.constraint(equalToConstant: 300),
            
            _similarCollectionView.topAnchor.constraint(equalTo: _movieDetailsView.bottomAnchor),
            _similarCollectionView.leftAnchor.constraint(equalTo: _scrollViewContent.leftAnchor),
            _similarCollectionView.rightAnchor.constraint(equalTo: _scrollViewContent.rightAnchor),
            _similarCollectionView.bottomAnchor.constraint(equalTo: _scrollViewContent.bottomAnchor),
            _similarCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureRx() {
        _movieViewModel.details.drive { [unowned self]  movieDetails in
            title = movieDetails.title
            _movieDetailsView.configure(model: movieDetails)
        }
        .disposed(by: _disposeBag)
    }
}
