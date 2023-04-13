//
//  ExecutionStatus.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import Foundation

enum ExecutionStatus {
    case none
    case inProgress
    case success
    case noData
    case failed(error: Error)
}
