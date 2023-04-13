//
//  ListUsersViewModelTests.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 13/04/23.
//

import XCTest
import Combine
@testable import GithubUsers

@MainActor
final class ListUsersViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    
    func test_initialState() throws {
        let viewModel = ListUsersViewModel(viewUsersUseCase: ViewUsersUseCaseSuccess())
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for users")

        viewModel.users.receive(on: RunLoop.main)
            .sink { (users) in
                XCTAssertNil(users, "Users should be nil")
                usersExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.executionStatus.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.none = status {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.none")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)
        
        XCTAssertEqual(viewModel.numberOfUsers(), 0)
        
        wait(for: [usersExpectation, executionStatusExpectation], timeout: 10)
    }
    
    func test_usersAtIndex_safeAccess() async throws {
        let viewModel = ListUsersViewModel(viewUsersUseCase: ViewUsersUseCaseSuccess())
        await viewModel.loadUsers()
        let numberOfItems = viewModel.numberOfUsers()
        XCTAssertNil(viewModel.userAtIndex(-1))
        XCTAssertNil(viewModel.userAtIndex(numberOfItems))
        XCTAssertNil(viewModel.userAtIndex(numberOfItems + 1))
    }
    
    func test_loadUsers_success() async throws {
        let usecase = ViewUsersUseCaseSuccess()
        let viewModel = ListUsersViewModel(viewUsersUseCase: usecase)
        await viewModel.loadUsers()
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for users")

        viewModel.users.receive(on: RunLoop.main)
            .sink { (users) in
                XCTAssertNotNil(users)
                XCTAssertTrue(usecase.users.elementsEqual(users!, by: { userOne, userTwo in
                    return userOne.id == userTwo.id
                }))
                usersExpectation.fulfill()
            }.store(in: &cancellables)
        
        
        viewModel.executionStatus.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.success = status {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.success")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)

        
        XCTAssertEqual(viewModel.numberOfUsers(), usecase.users.count)
        await fulfillment(of: [usersExpectation, executionStatusExpectation], timeout: 10)
    }

    func test_loadUsers_success_with_noData() async throws {
        let usecase = ViewUsersUseCaseSuccess(users: [])
        let viewModel = ListUsersViewModel(viewUsersUseCase: usecase)
        await viewModel.loadUsers()
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for users")

        viewModel.users.receive(on: RunLoop.main)
            .sink { (users) in
                XCTAssertNotNil(users)
                XCTAssertTrue(usecase.users.isEmpty)
                usersExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.executionStatus.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.noData = status {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.noData")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)
        
        XCTAssertEqual(viewModel.numberOfUsers(), usecase.users.count)
        await fulfillment(of: [usersExpectation, executionStatusExpectation], timeout: 10)
    }
    
    func test_loadUsers_fail() async throws {
        let usecase = ViewUsersUseCaseFailed(error: ApiRequestError.unknownError)
        let viewModel = ListUsersViewModel(viewUsersUseCase: usecase)
        await viewModel.loadUsers()
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for users")

        viewModel.users.receive(on: RunLoop.main)
            .sink { (users) in
                XCTAssertNil(users)
                usersExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.executionStatus.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.failed(let error) = status {
                    XCTAssertTrue(error is ApiRequestError)
                } else {
                    XCTFail("executionStatus sould be ExecutionStatus.failed")
                }
                executionStatusExpectation.fulfill()
            }.store(in: &cancellables)
        
        XCTAssertEqual(viewModel.numberOfUsers(), 0)
        await fulfillment(of: [usersExpectation, executionStatusExpectation], timeout: 10)
    }
}
