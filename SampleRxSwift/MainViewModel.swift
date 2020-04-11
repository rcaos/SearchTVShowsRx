//
//  MainViewModel.swift
//  SampleRxSwift
//
//  Created by Jeans Ruiz on 4/10/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources

final class MainViewModel {
  
  var disposeBag = DisposeBag()
  
  var showsObservableSubject = BehaviorSubject<[SingleSectionModel]>(value: [])
  
  var longRequest = true
  
  var input: Input
  var output: Output
  
  var client: ApiClient
  
  init() {
    self.input = Input()
    self.output = Output(shows: showsObservableSubject.asObservable())
    client = ApiClient()
  }
  
  public func viewDidLoad() {
    subscribe()
  }
  
  private func subscribe() {
    input.query
      .filter { !$0.isEmpty }
      .debounce( RxTimeInterval.milliseconds(1000) , scheduler: MainScheduler.instance)
      .startWith("Better Call Saul")
      .flatMapLatest { query -> Observable<TVShowResult> in
        return self.search(query: query, delay: 3000)
    }
    .map { result in
      print("create model with: [\(result.results.count) elements]")
      return [SingleSectionModel(header: "", items: result.results)]
    }
    .bind(to: showsObservableSubject)
    .disposed(by: disposeBag)
  }
  
  func search(query: String, delay: Int) -> Observable<TVShowResult> {
    let searchEndPoint = TVShowsProvider.searchTVShow(delay: delay, query: query)
    
    return client.request(searchEndPoint, TVShowResult.self)
  }
}

extension MainViewModel {
  
  public struct Input {
    let query = BehaviorSubject<String>(value: "")
  }
  
  public struct Output {
    let shows: Observable<[SingleSectionModel]>
  }
}
