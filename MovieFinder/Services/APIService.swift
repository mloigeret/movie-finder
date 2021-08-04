//
//  APIService.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import Foundation
import RxCocoa
import RxSwift

protocol APIServiceProtocol {
    func send<T: Decodable>(apiRequest: APIRequest) -> Observable<T>
}

class APIService: APIServiceProtocol {
    private struct Constants {
        static let baseURL = URL(string: Configuration.tmdb.baseUrl)!
    }
    
    static func instantiate() -> APIServiceProtocol {
        return APIService()
    }
    
    func send<T: Decodable>(apiRequest: APIRequest) -> Observable<T> {
        let request = apiRequest.request(with: Constants.baseURL)
        return URLSession.shared.rx.data(request: request)
            .map { data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            }
            .observe(on: MainScheduler.asyncInstance)
    }
}
