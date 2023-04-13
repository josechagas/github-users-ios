//
//  View.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import UIKit


protocol WithViewCode where Self: UIView {
    func addSubviews()
    func addConstraints()
}
