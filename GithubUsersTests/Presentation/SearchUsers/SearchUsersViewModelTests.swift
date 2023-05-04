//
//  SearchUsersViewModelTests.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 04/05/23.
//

import XCTest
import Combine
@testable import GithubUsers

@MainActor
final class SearchUsersViewModelTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    func test_initialState() throws {
        let usecase: SearchUsersUseCaseProtocol = SearchUsersUseCaseMock(
            searchUsersResult: Result.success([]),
            loadMoreForLastSearchResult: Result.success([])
        )
        let viewModel = SearchUsersViewModel(usecase: usecase)
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for executionStatus")
        let paginationExecutionStatusExpectation = XCTestExpectation(description: "Wait for paginationExecutionStatus")

        viewModel.userPublisher.receive(on: RunLoop.main)
            .sink { (users) in
                XCTAssertNil(users, "Users should be nil")
                usersExpectation.fulfill()
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
        
        viewModel.paginationExecutionStatusPublisher.receive(on: RunLoop.main)
            .sink { (status) in
                if case ExecutionStatus.none = status {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("paginationExecutionStatus sould be ExecutionStatus.none")
                }
                paginationExecutionStatusExpectation.fulfill()
            }.store(in: &cancellables)
        
        
        XCTAssertEqual(viewModel.numberOfItems(), 0)
        XCTAssertNil(viewModel.itemAtIndex(index: 0))
    
        wait(for: [usersExpectation, executionStatusExpectation, paginationExecutionStatusExpectation], timeout: 10)
        
    }
    
    //MARK: - searchUsersBy

    func test_searchUsersBy_withSuccess() throws {
        XCTFail()
    }
    
    func test_searchUsersBy_withFail() throws {
        XCTFail()
    }
    
    //MARK: - fetchMoreSearchResults
    
    func test_fetchMoreSearchResults_withSuccess() throws {
        XCTFail()
    }

    func test_fetchMoreSearchResults_withFail() throws {
        XCTFail()
    }

    func test_fetchMoreSearchResults_withInvalidLastIndex() throws {
        XCTFail()
    }
    
    //MARK: - numberOfItems
    
    func test_numberOfItems_afterExecutingLoadingUsers() throws {
        XCTFail()
    }
    
    //MARK: - itemAtIndex
    
    func test_itemAtIndex_whenIndexIsLessThanZero() throws {
        XCTFail()
    }
    
    func test_itemAtIndex_whenIndexIsValid() throws {
        XCTFail()
    }
    
    func test_itemAtIndex_whenIndexIsGreaterThanMax() throws {
        XCTFail()
    }
    
    
}
