//
//  UserDetailsViewModel.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

class UserDetailsViewModel: UserDetailsViewModelProtocol {
    
    @Published private(set) var user: User? = nil
    @Published private(set) var executionStatus: ExecutionStatus = .none
    
    private(set) var userLogin: String
    
    var userPublisher: Published<User?>.Publisher {$user}
    var executionStatusPublisher: Published<ExecutionStatus>.Publisher {$executionStatus}
        
    private let userDetailsUseCase: UserDetailsUseCaseProtocol
    
    init(userLogin: String, userDetailsUseCase: UserDetailsUseCaseProtocol) {
        self.userLogin = userLogin
        self.userDetailsUseCase = userDetailsUseCase
    }
    
    func loadUserDetails() async {
        executionStatus = .inProgress
        do {
            user = try await userDetailsUseCase.loadUserDetails(login: userLogin)
            executionStatus = user != nil ? .success : .noData
        } catch {
            executionStatus = .failed(error: error)
        }
    }
    
}
