//
//  View.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit


protocol WithViewCode {
    func setUp()
    func addSubviews()
    func addConstraints()
}

extension WithViewCode where Self: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        addSubviews()
        addConstraints()
    }
}
