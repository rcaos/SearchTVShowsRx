//
//  TVShowsProviders.swift
//  SampleRxSwift
//
//  Created by Jeans Ruiz on 4/10/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

import Foundation

enum TVShowsProvider {
  case searchTVShow(delay: Int, query: String)
}

extension TVShowsProvider: EndPoint {
  
  var apiKey: String {
    return "06e1a8c1f39b7a033e2efb972625fee2"
  }
  
  var proxyBase: String {
    return "http://deelay.me"
  }
  
  var base: String {
    return "https://api.themoviedb.org"
  }
  
  var path: String {
    switch self {
    case .searchTVShow(let delay, _):
      return "/\(delay)/\(base)/3/search/tv/"
    }
  }
  
  var queryParameters: [String : Any] {
    var parameters: [String: Any] = [:]
    
    switch self {
    case .searchTVShow(_, let query):
      parameters["query"] = query
      parameters["api_key"] = apiKey
    }
    return parameters
  }
  
  var method: ServiceMethod {
    return .get
  }
}
