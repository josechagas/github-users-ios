//
//  ListUserReposViewModelTests.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import XCTest
import Combine
@testable import GithubUsers

@MainActor
final class ListUserReposViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    func test_initialState() throws {
        let usecase = ViewUserReposUseCaseSuccess()
        let viewModel = ListUserReposViewModel(userLogin: "some_user", viewUserReposUseCase: usecase)
        
        let reposExpectation = XCTestExpectation(description: "Wait for repos")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for repos")

        viewModel.reposPublisher.receive(on: RunLoop.main)
            .sink { (repos) in
                XCTAssertNil(repos, "Repos should be nil")
                reposExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.executionStatusPublisher.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.none = status {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.none")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)
        
        XCTAssertEqual(viewModel.numberOfRepos(), 0)
        
        wait(for: [reposExpectation, executionStatusExpectation], timeout: 10)
    }
    
    func test_repoAtIndex_safeAccess() async throws {
        let usecase = ViewUserReposUseCaseSuccess()
        let viewModel = ListUserReposViewModel(userLogin: "some_user", viewUserReposUseCase: usecase)

        await viewModel.loadUserRepos()
        let numberOfItems = viewModel.numberOfRepos()
        XCTAssertNil(viewModel.repoAtIndex(-1))
        XCTAssertNil(viewModel.repoAtIndex(numberOfItems))
        XCTAssertNil(viewModel.repoAtIndex(numberOfItems + 1))
    }
    
    func test_loadRepos_success() async throws {
        let usecase = ViewUserReposUseCaseSuccess()
        let viewModel = ListUserReposViewModel(userLogin: "some_user", viewUserReposUseCase: usecase)
        await viewModel.loadUserRepos()
        
        let reposExpectation = XCTestExpectation(description: "Wait for repos")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for repos")

        viewModel.reposPublisher.receive(on: RunLoop.main)
            .sink { (repos) in
                XCTAssertNotNil(repos)
                XCTAssertTrue(usecase.repos.elementsEqual(repos!, by: { userOne, userTwo in
                    return userOne.id == userTwo.id
                }))
                reposExpectation.fulfill()
            }.store(in: &cancellables)
        
        
        viewModel.executionStatusPublisher.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.success = status {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.success")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)

        
        XCTAssertEqual(viewModel.numberOfRepos(), usecase.repos.count)
        await fulfillment(of: [reposExpectation, executionStatusExpectation], timeout: 10)
    }

    func test_loadRepos_success_with_noData() async throws {
        let usecase = ViewUserReposUseCaseSuccess(repos: [])
        let viewModel = ListUserReposViewModel(userLogin: "some_user", viewUserReposUseCase: usecase)
        await viewModel.loadUserRepos()
        
        let reposExpectation = XCTestExpectation(description: "Wait for repos")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for repos")

        viewModel.reposPublisher.receive(on: RunLoop.main)
            .sink { (repos) in
                XCTAssertNotNil(repos)
                XCTAssertTrue(usecase.repos.isEmpty)
                reposExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.executionStatusPublisher.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.noData = status {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.noData")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)
        
        XCTAssertEqual(viewModel.numberOfRepos(), usecase.repos.count)
        await fulfillment(of: [reposExpectation, executionStatusExpectation], timeout: 10)
    }
    
    func test_loadRepos_fail() async throws {
        let usecase = ViewUserReposUseCaseFailed()
        let viewModel = ListUserReposViewModel(userLogin: "some_user", viewUserReposUseCase: usecase)
        await viewModel.loadUserRepos()

        let reposExpectation = XCTestExpectation(description: "Wait for repos")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for repos")

        viewModel.reposPublisher.receive(on: RunLoop.main)
            .sink { (users) in
                XCTAssertNil(users)
                reposExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.executionStatusPublisher.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.failed(let error) = status {
                    XCTAssertTrue(error is ApiRequestError)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.failed")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)
        
        XCTAssertEqual(viewModel.numberOfRepos(), 0)
        await fulfillment(of: [reposExpectation, executionStatusExpectation], timeout: 10)
    }
}
