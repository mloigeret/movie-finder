//
//  MovieCreditsResult.swift
//  MovieFinder
//
//  Created by Manuel Loigeret on 2021-08-02.
//

import Foundation

struct MovieCreditsResult: Codable {
    let cast: [CastMember]
    let crew: [CrewMember]
}
