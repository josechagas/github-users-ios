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
    var user: User? {get}
    var executionStatus: ExecutionStatus {get}
    var userPublisher: Published<User?>.Publisher {get}
    var executionStatusPublisher: Published<ExecutionStatus>.Publisher {get}
    
    func loadUserDetails() async
}
