//
//  QueryListResult.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-07-21.
//

import Foundation

struct QueryListResult<T: Decodable>: Decodable {
    let results: [T]
}
