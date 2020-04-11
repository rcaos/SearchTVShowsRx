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
    // Cancel button tmb envía nextEvent ""
    let clearTracksOnQueryChanged: Observable<[SingleSectionModel]> = input.query
      .skip(1)
      .map { _ in return [] }
    
    let tracksFromRepository: Observable<[SingleSectionModel]> = input.query
      .filter { !$0.isEmpty }
      .debounce( RxTimeInterval.milliseconds(1000) , scheduler: MainScheduler.instance)
      .startWith("Better Call Saul")
      .flatMapLatest { query -> Observable<TVShowResult> in
        return self.search(query: query, delay: 500)
    }
    .map { result in
      print("create model with: [\(result.results.count) elements]")
      return [SingleSectionModel(header: "", items: result.results)]
    }
    
    input.didPullRefresh
    .debug()
      .subscribe(onNext: {
        print("-- enter here didPullRefresh VM")
      })
    .disposed(by: disposeBag)
    
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
