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
    searchShows(query: "The X Files", delay: 500)
    subscribe()
  }
  
  private func subscribe() {
    input.query
      .filter { !$0.isEmpty }
      .debounce( RxTimeInterval.milliseconds(1000) , scheduler: MainScheduler.instance)
      .flatMap { query -> Observable<TVShowResult> in
        
        var delay = 1000
        if self.longRequest {
          delay = 5000
          self.longRequest = !self.longRequest
        }
        return self.search(query: query, delay: delay)
    }
    .map { result in
      return [SingleSectionModel(header: "", items: result.results)]
    }
    .bind(to: showsObservableSubject)
    .disposed(by: disposeBag)
  }
  
  func search(query: String, delay: Int) -> Observable<TVShowResult> {
    let searchEndPoint = TVShowsProvider.searchTVShow(delay: delay, query: query)
    
    return client.request(searchEndPoint, TVShowResult.self)
  }
  
  
  func searchShows(query: String, delay: Int) {
    let searchEndPoint = TVShowsProvider.searchTVShow(delay: delay, query: query)
    
    client.request(searchEndPoint, TVShowResult.self)
      .subscribe(onNext: { [weak self] result in
        print("--> results for \(query), Delay: [\(delay)ms]: [\(result.results.count)]")
        self?.createModel(header: query, with: result.results)
        }, onError: { [weak self]  error in
          print("error : [\(error)]")
          self?.createModel(header: "", with: [])
        }, onDisposed: {
          print("-- disposed request: [\(query)]")
      })
      .disposed(by: disposeBag)
  }
  
  private func createModel(header: String, with shows: [TVShow]) {
    showsObservableSubject.onNext(
      [SingleSectionModel(header: header, items: shows)]
    )
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
