//
//  LoadResultStatusView.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit

class LoadResultStatusView: UIStackView, WithViewCode {
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.textAlignment = .center
        title.numberOfLines = 2
        return title
    }()
    
    private lazy var detailLabel: UILabel = {
        let detail = UILabel()
        detail.font = UIFont.preferredFont(forTextStyle: .callout)
        detail.numberOfLines = 3
        detail.textAlignment = .center
        return detail
    }()

    private lazy var progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var actionButton: UIButton = {
        let view = UIButton(type: .system)
        view.addTarget(self, action: #selector(onActionButtonPressed), for: .touchUpInside)
        return view
    }()

    
    private var onLoading: StatusData = StatusData.Default
    private var onNoData: StatusData = StatusData.Default
    private var onFailed: StatusData = StatusData.Default
    
    private var currentStatusData: StatusData? = nil
    private var currentStatus: Status = .none
    
    weak var delegate: LoadResultStatusViewDelegate? = nil
    
    init(onLoading: StatusData, onNoData: StatusData, onFailed: StatusData) {
        self.onLoading = onLoading
        self.onNoData = onNoData
        self.onFailed = onFailed
        super.init(frame: .zero)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 10
        addArrangedSubview(titleLabel)
        addArrangedSubview(detailLabel)
        addArrangedSubview(progressView)
        addArrangedSubview(actionButton)
    }
    
    func addConstraints() {}
    
    
    func stateNone() {
        isHidden = true
        progressView.stopAnimating()
        currentStatus = .none
        currentStatusData = nil
    }
        
    func stateLoading() {
        isHidden = false
        progressView.startAnimating()
        currentStatus = .loading
        currentStatusData = onLoading
        updateUI()
    }
    
    func stateNoData() {
        isHidden = false
        progressView.stopAnimating()
        currentStatus = .noData
        currentStatusData = onNoData
        updateUI()
    }
    
    func stateFailed() {
        isHidden = false
        progressView.stopAnimating()
        currentStatus = .failed
        currentStatusData = onFailed
        updateUI()
    }
    
    private func updateUI() {
        if let status = currentStatusData {
            titleLabel.text = status.title
            detailLabel.text = status.detail
            detailLabel.isHidden = status.detail == nil
            actionButton.setTitle(status.actionButtonTitle, for: .normal)
            actionButton.isHidden = status.actionButtonTitle == nil || currentStatus == .loading
        }
    }
    
    @objc
    private func onActionButtonPressed() {
        delegate?.onActionButtonPressed(currentStatus: currentStatus)
    }

}


extension LoadResultStatusView {
    enum Status {
        case noData
        case failed
        case loading
        case none
    }
    
    struct StatusData {
        var title: String
        var detail: String?
        var actionButtonTitle: String?
        
        init(title: String, detail: String? = nil, actionButtonTitle: String? = nil) {
            self.title = title
            self.detail = detail
            self.actionButtonTitle = actionButtonTitle
        }
        
        static var Default = StatusData(title: "")
    }
}

protocol LoadResultStatusViewDelegate: AnyObject {
    func onActionButtonPressed(currentStatus: LoadResultStatusView.Status)
}

