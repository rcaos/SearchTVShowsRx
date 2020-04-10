//
//  TVShow.swift
//  SampleRxSwift
//
//  Created by Jeans Ruiz on 4/10/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct TVShowResult: Decodable {
  
  let page: Int!
  var results: [TVShow]!
  let totalResults: Int!
  let totalPages: Int!
}

struct TVShow {
  
  var id: Int!
  var name: String!
  var voteAverage: Double?
  var firstAirDate: String?
  
  var posterPath: String?
  var genreIds: [Int]?
  var backDropPath: String?
  var overview: String!
  var originCountry: [String]!
  var voteCount: Int!
}

extension TVShow: IdentifiableType {
  typealias Identity = Int
  
  public var identity: Int {
      return id
  }
}

extension TVShow: Equatable {
  public static func ==(lhs: TVShow, rhs: TVShow) -> Bool {
    return lhs.id == rhs.id
  }
}
