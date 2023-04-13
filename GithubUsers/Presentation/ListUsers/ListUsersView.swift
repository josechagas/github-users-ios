//
//  ListUsersView.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import UIKit

class ListUsersView: UIView, WithViewCode {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(ImageAndTitleInfoTableViewCell.self, forCellReuseIdentifier: String(describing: ImageAndTitleInfoTableViewCell.self))

        return tableView
    }()
    
    
    private lazy var loadStatusView: LoadResultStatusView = {
        let view = LoadResultStatusView(
            onLoading: LoadResultStatusView.StatusData(
                title: "Loading Users"
            ), onNoData: LoadResultStatusView.StatusData(
                title: "No users here",
                actionButtonTitle: "Reload"
            ), onFailed: LoadResultStatusView.StatusData(
                title: "Failed to load users :(",
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
        addSubview(tableView)
        addSubview(loadStatusView)
    }
    
    func addConstraints() {
        addTableViewConstraints()
        addLoadResultViewConstraints()
    }
    
    private func addTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
    
    func setUpWith(datasource: UITableViewDataSource?, delegate: UITableViewDelegate?, loadStatusViewDelegate: LoadResultStatusViewDelegate?) {
        tableView.dataSource = datasource
        tableView.delegate = delegate
        loadStatusView.delegate = loadStatusViewDelegate
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateForStatus(executionStatus: ExecutionStatus) {
        switch executionStatus {
        case .none:
            tableView.isHidden = false
            loadStatusView.stateNone()
        case .inProgress:
            tableView.isHidden = true
            loadStatusView.stateLoading()
        case .success:
            tableView.isHidden = false
            loadStatusView.stateNone()
        case .noData:
            tableView.isHidden = true
            loadStatusView.stateNoData()
        case .failed(_):
            tableView.isHidden = true
            loadStatusView.stateFailed()
        }
    }
}
