//
//  ImageAndTitleInfoTableViewCell.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit


class ImageAndTitleInfoTableViewCell: UITableViewCell, WithViewCode {
    private lazy var content: ImageAndTitleInfoView = {
        let view = ImageAndTitleInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
        
    private func setUp() {
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(content)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            content.topAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.topAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            content.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            content.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    
    func setUpWith(model: ImageAndTitleInfoView.Model) {
        content.setUpWith(model: model)
    }
}
