//
//  HomeViewModel.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import Foundation

protocol HomeViewModelProtocol {
    
}

class HomeViewModel: HomeViewModelProtocol {
    
    static func instantiate() -> HomeViewModelProtocol {
        return HomeViewModel()
    }
}
