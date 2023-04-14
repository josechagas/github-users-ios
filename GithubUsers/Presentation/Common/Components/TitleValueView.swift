//
//  TitleValueView.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import UIKit

class TitleValueView: UIStackView, WithViewCode {
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        return view
    }()
    
    private lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.gray
        view.textAlignment = .right
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = 5
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
    }
    
    func addConstraints() {}

    func setUpWith(title: String, value: String) {
        setTitle(title: title)
        setValue(value: value)
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setValue(value: String) {
        valueLabel.text = value
    }
}
