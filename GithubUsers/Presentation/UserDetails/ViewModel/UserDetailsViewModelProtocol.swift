//
//  UserDetailsViewModelProtocol.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

@MainActor
protocol UserDetailsViewModelProtocol {
    var userLogin: String {get}
    var user: Published<User?>.Publisher {get}
    var executionStatus: Published<ExecutionStatus>.Publisher {get}
    
    func loadUserDetails() async
}
