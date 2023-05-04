//
//  SearchUsersView.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 02/05/23.
//

import UIKit

class SearchUsersView: UIView, WithViewCode {
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.isTranslucent = true
        view.placeholder = "Search users"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImageAndTitleInfoTableViewCell.self, forCellReuseIdentifier: String(describing: ImageAndTitleInfoTableViewCell.self))
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private lazy var loadStatusView: LoadResultStatusView = {
        let view = LoadResultStatusView(
            onLoading: LoadResultStatusView.StatusData(
                title: "Searching Users"
            ), onNoData: LoadResultStatusView.StatusData(
                title: "No matches found",
                actionButtonTitle: "Reload"
            ), onFailed: LoadResultStatusView.StatusData(
                title: "Failed to load the results :(",
                detail: "Some error happened. Verify your connection!",
                actionButtonTitle: "Reload"
            )
        )
        view.stateNone()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
        
    func setUp() {
        backgroundColor = UIColor.systemBackground
        addSubviews()
        addConstraints()

    }
    
    func addSubviews() {
        addSubview(searchResultsTableView)
        addSubview(loadStatusView)
        addSubview(searchBar)
    }
    
    func addConstraints() {
        addSearchBarConstraints()
        addSearchResultsTableViewConstraints()
        addLoadResultViewConstraints()
    }
    
    private func addSearchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    
    private func addSearchResultsTableViewConstraints() {
        NSLayoutConstraint.activate([
            searchResultsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func addLoadResultViewConstraints() {
        NSLayoutConstraint.activate([
            loadStatusView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            loadStatusView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
            loadStatusView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            loadStatusView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
            loadStatusView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)

        ])
    }
 
    func setUpWith(datasource: UITableViewDataSource?,
                   prefetchDataSource: UITableViewDataSourcePrefetching?,
                   delegate: UITableViewDelegate?,
                   loadStatusViewDelegate: LoadResultStatusViewDelegate?,
                   searchBarDelegate: UISearchBarDelegate
    ) {
        searchResultsTableView.dataSource = datasource
        searchResultsTableView.prefetchDataSource = prefetchDataSource
        searchResultsTableView.delegate = delegate
        loadStatusView.delegate = loadStatusViewDelegate
        searchBar.delegate = searchBarDelegate
    }
    
    func reloadData() {
        searchResultsTableView.reloadData()
    }
    
    func searchText()-> String? {
        return searchBar.text
    }
    
    func updateForStatus(executionStatus: ExecutionStatus) {
        switch executionStatus {
        case .none:
            searchResultsTableView.isHidden = false
            loadStatusView.stateNone()
        case .inProgress:
            searchResultsTableView.isHidden = true
            loadStatusView.stateLoading()
        case .success:
            searchResultsTableView.isHidden = false
            loadStatusView.stateNone()
        case .noData:
            searchResultsTableView.isHidden = true
            loadStatusView.stateNoData()
        case .failed(_):
            searchResultsTableView.isHidden = true
            loadStatusView.stateFailed()
        }
    }

}
