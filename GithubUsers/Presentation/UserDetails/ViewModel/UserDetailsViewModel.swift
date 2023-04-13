//
//  UserDetailsViewModel.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

class UserDetailsViewModel: UserDetailsViewModelProtocol {
    @Published private var _user: User? = nil
    @Published private var _executionStatus: ExecutionStatus = .none
    
    private(set) var userLogin: String
    var user: Published<User?>.Publisher {$_user}
    var executionStatus: Published<ExecutionStatus>.Publisher {$_executionStatus}
    
    
    init(userLogin: String) {
        self.userLogin = userLogin
    }
    
    func loadUserDetails() async {
        
    }
    
}
