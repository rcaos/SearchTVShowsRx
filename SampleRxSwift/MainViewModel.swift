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
  
  private var disposeBag = DisposeBag()
  
  private var showsObservableSubject = BehaviorSubject<[SingleSectionModel]>(value: [])
  private var isRefreshingObservableSubject = BehaviorSubject<Bool>(value: false)
  
  private var longRequest = true
  
  var input: Input
  var output: Output
  
  private var client: ApiClient
  
  init() {
    self.input = Input()
    self.output = Output(
      shows: showsObservableSubject.asObservable(),
      isRefreshing: isRefreshingObservableSubject.asObservable())
    client = ApiClient()
  }
  
  public func viewDidLoad() {
    subscribe()
  }
  
  private func subscribe() {
    
    let searchTextChanged = input.query.skip(1)
    let theQuery = searchTextChanged
      .debounce(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
      .startWith("Better Call Saul")
    
    let refreshLastQuery = input.didPullRefresh.withLatestFrom(searchTextChanged)
    
    let tracksFromRepository: Observable<[SingleSectionModel]> = Observable.merge(theQuery, refreshLastQuery)
      .filter { $0.count >= 3 }
      .flatMapLatest { query -> Observable<TVShowResult> in
        return self.search(query: query, delay: 500)
    }
    .map { result in
      print("create model with: [\(result.results.count) elements]")
      return [SingleSectionModel(header: "", items: result.results)]
    }.do( onNext: { _ in
      self.isRefreshingObservableSubject.onNext(false)
    })
    
    // Cancel button tmb envía nextEvent ""
    let clearTracksOnQueryChanged: Observable<[SingleSectionModel]> = input.query
      .skip(1)
      .map { _ in return [] }
    
    // Una sola fuente para la View
    Observable.merge(tracksFromRepository, clearTracksOnQueryChanged)
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
    let didPullRefresh = BehaviorSubject<Void>(value: ())
  }
  
  public struct Output {
    let shows: Observable<[SingleSectionModel]>
    let isRefreshing: Observable<Bool>
  }
}
