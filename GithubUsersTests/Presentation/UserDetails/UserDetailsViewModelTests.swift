//
//  UserDetailsViewModelTests.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 14/04/23.
//

import XCTest
import Combine
@testable import GithubUsers

@MainActor
final class UserDetailsViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initialState() throws {
        let useCase = UserDetailsUseCaseSuccess(noData: false)
        let viewModel = UserDetailsViewModel(userLogin: "some_user", userDetailsUseCase: useCase)
        
        let userExpectation = XCTestExpectation(description: "Wait for user details")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for user details")

        viewModel.userPublisher.receive(on: RunLoop.main)
            .sink { (user) in
                XCTAssertNil(user, "User should be nil")
                userExpectation.fulfill()
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
        
        XCTAssertNil(viewModel.user, "User should be nil")
        if case ExecutionStatus.none = viewModel.executionStatus {
            XCTAssertTrue(true)
        } else {
            XCTFail("executionStatus sould be ExecutionStatus.none")
        }

        wait(for: [userExpectation, executionStatusExpectation], timeout: 10)

    }

    func test_loadUserDetails_success() async throws {
        let useCase = UserDetailsUseCaseSuccess(noData: false)
        let viewModel = UserDetailsViewModel(userLogin: "some_user", userDetailsUseCase: useCase)
        
        let userExpectation = XCTestExpectation(description: "Wait for user details")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for user details")

        await viewModel.loadUserDetails()
        
        viewModel.userPublisher.receive(on: RunLoop.main)
            .sink { (user) in
                XCTAssertNotNil(user, "User should not be nil")
                userExpectation.fulfill()
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
        
        XCTAssertNotNil(viewModel.user, "User should not be nil")
        if case ExecutionStatus.success = viewModel.executionStatus {
            XCTAssertTrue(true)
        } else {
            XCTFail("executionStatus sould be ExecutionStatus.success")
        }

        await fulfillment(of: [userExpectation, executionStatusExpectation], timeout: 10)

    }
    
    func test_loadUserDetails_success_with_noData() async throws {
        let useCase = UserDetailsUseCaseSuccess(noData: true)
        let viewModel = UserDetailsViewModel(userLogin: "some_user", userDetailsUseCase: useCase)
        
        let userExpectation = XCTestExpectation(description: "Wait for user details")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for user details")

        await viewModel.loadUserDetails()
        
        viewModel.userPublisher.receive(on: RunLoop.main)
            .sink { (user) in
                XCTAssertNil(user, "User should be nil")
                userExpectation.fulfill()
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
        
        XCTAssertNil(viewModel.user, "User should be nil")
        if case ExecutionStatus.noData = viewModel.executionStatus {
            XCTAssertTrue(true)
        } else {
            XCTFail("executionStatus sould be ExecutionStatus.noData")
        }

        await fulfillment(of: [userExpectation, executionStatusExpectation], timeout: 10)
    }

    func test_loadUserDetails_fail() async throws {
        let useCase = UserDetailsUseCaseFailed()
        let viewModel = UserDetailsViewModel(userLogin: "some_user", userDetailsUseCase: useCase)
        
        let userExpectation = XCTestExpectation(description: "Wait for user details")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for user details")

        await viewModel.loadUserDetails()
        
        viewModel.userPublisher.receive(on: RunLoop.main)
            .sink { (user) in
                XCTAssertNil(user, "User should be nil")
                userExpectation.fulfill()
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
        
        XCTAssertNil(viewModel.user, "User should be nil")
        if case ExecutionStatus.failed(let error) = viewModel.executionStatus {
            XCTAssertTrue(error is ApiRequestError)
        } else {
            XCTFail("executionStatus sould be ExecutionStatus.failed")
        }

        await fulfillment(of: [userExpectation, executionStatusExpectation], timeout: 10)
    }
}
