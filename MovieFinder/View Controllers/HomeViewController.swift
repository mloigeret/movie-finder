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

    static func instantiate() -> HomeViewControllerProtocol {
        return HomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
