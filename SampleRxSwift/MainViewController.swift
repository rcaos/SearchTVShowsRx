//
//  MainViewController.swift
//  SampleRxSwift
//
//  Created by Jeans Ruiz on 2/17/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class MainViewController: UIViewController {
  
  var viewModel: MainViewModel
  let disposeBag = DisposeBag()
  
  var tableView: UITableView!
  var searchController:UISearchController!
  
  var refreshControl: UIRefreshControl!
  
  // Life Cycle
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    setupView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Single Section Example"
    
    setupTable()
    setupSearchBar()
    bindViewModel()
    setupButton()
    
    viewModel.viewDidLoad()
  }
  
  func setupView() {
    tableView = UITableView(frame: .zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    ])
  }
  
  func setupTable() {
    let nibName = UINib(nibName: "TableViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "TableViewCell")
    
    tableView.rowHeight = UITableView.automaticDimension
    
    refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl
  }
  
  func setupSearchBar() {
    // MARK: - TODO, test with UISearchController
    
    searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "Search TV Show"
    searchController.searchBar.delegate = self
    searchController.searchBar.barStyle = .default
    
    navigationItem.searchController = searchController
    //tableView.tableHeaderView = searchController.searchBar
    
    navigationItem.hidesSearchBarWhenScrolling = false
    
    definesPresentationContext = true
  }
  
  func bindViewModel() {
    // 1: Siempre Reload All de cells aunque no lo necesiten
    
    let dataSource = RxTableViewSectionedReloadDataSource<SingleSectionModel>(
      configureCell: { [weak self] (_, tableView, indexPath, element) -> UITableViewCell in
        guard let strongSelf = self else { fatalError() }
        
        //print("ask for element: \(indexPath)")
        return strongSelf.makeCellForEpisode(at: indexPath, element: element)
        
    },
      titleForHeaderInSection: { dataSource, sectionIndex in
          let section = dataSource[sectionIndex]
          return section.items.count > 0 ? "Results (\(section.items.count))" : "No repositories found"
      })
    
    viewModel.output
      .shows
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    searchController.searchBar.rx
      .text.orEmpty
      .bind(to: viewModel.input.query)
      .disposed(by: disposeBag)
    
    viewModel.output.isRefreshing
    .debug()
      .bind(to: refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)
    
    refreshControl.rx
      .controlEvent(.valueChanged)
      .map { _ in return self.refreshControl.isRefreshing }
      .filter { $0 == true }
      .map { _ in return () }
      .bind(to: viewModel.input.didPullRefresh)
      .disposed(by: disposeBag)
  }
  
  func setupButton() {
    let randomButton = UIBarButtonItem(title: "Reset True", style: .plain, target: nil, action: nil)
    tabBarController?.navigationItem.rightBarButtonItem = randomButton
    
    // Refresh search maybe ??
    
    randomButton
      .rx
      .tap
      .bind { [unowned self] in
        //self.largeRequest = true
    }
    .disposed(by: disposeBag)
  }
  
  fileprivate func makeCellForEpisode(at indexPath: IndexPath, element: TVShow) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
    cell.setModel(entity: element)
    return cell
  }
}

//MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    print("-- Search Cancell Button Clicked")
  }
}
