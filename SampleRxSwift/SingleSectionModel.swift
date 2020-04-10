//
//  SingleSectionModel.swift
//  SearchRxSwift
//
//  Created by Jeans Ruiz on 4/10/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxDataSources

struct SingleSectionModel {
  var header: String
  var items: [Item]
}

extension SingleSectionModel: SectionModelType {
  
  typealias Item = TVShow
  
  init(original: Self, items: [Item]) {
    self = original
    self.items = items
  }
  
}
