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

        try! assertViewModelPublishers(viewModel: viewModel,
                                       expectedUsers: nil,
                                       expectedStatus: .none,
                                       expectedPaginationStatus: .none,
                                       usersExpectation: usersExpectation,
                                       statusExpectation: executionStatusExpectation,
                                       paginationExpectation: paginationExecutionStatusExpectation)

        try! assertUsers(value: viewModel.users, expected: nil)
        try! assertExecutionStatus(value: viewModel.executionStatus, expected: .none)
        try! assertExecutionStatus(value: viewModel.paginationExecutionStatus, expected: .none)
        
        XCTAssertEqual(viewModel.numberOfItems(), 0)
        XCTAssertNil(viewModel.itemAtIndex(index: 0))
    
        wait(for: [usersExpectation, executionStatusExpectation, paginationExecutionStatusExpectation], timeout: 10)
        
    }
    
    //MARK: - searchUsersBy

    func test_searchUsersBy_withSuccess() async throws {
        let loadedUsers = [
            SmallUserInfo(id: 1, login: "teste 1", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 2, login: "teste 12", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 13, login: "teste 100", htmlUrl: "https://google.com.br")
        ]
        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.success(loadedUsers),
            loadMoreForLastSearchResult: Result.success([])
        )
        let viewModel = SearchUsersViewModel(usecase: usecase)
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for executionStatus")
        let paginationExecutionStatusExpectation = XCTestExpectation(description: "Wait for paginationExecutionStatus")

        await viewModel.searchUsersBy(search: "teste")
        
        try! assertViewModelPublishers(viewModel: viewModel,
                                       expectedUsers: loadedUsers,
                                       expectedStatus: .success,
                                       expectedPaginationStatus: .none,
                                       usersExpectation: usersExpectation,
                                       statusExpectation: executionStatusExpectation,
                                       paginationExpectation: paginationExecutionStatusExpectation)
  
        try! assertUsers(value: viewModel.users, expected: loadedUsers)
        try! assertExecutionStatus(value: viewModel.executionStatus, expected: .success)
        try! assertExecutionStatus(value: viewModel.paginationExecutionStatus, expected: .none)
        
        XCTAssertEqual(viewModel.numberOfItems(), loadedUsers.count)
        XCTAssertEqual(viewModel.itemAtIndex(index: 0)?.id, loadedUsers[0].id)
    
        await fulfillment(of: [usersExpectation, executionStatusExpectation, paginationExecutionStatusExpectation], timeout: 10)

    }
    
    func test_searchUsersBy_withFail() async throws {
        let searchUsersException = ApiRequestError.requestFailed(statusCode: 500, errorBody: nil)
        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.failure(searchUsersException),
            loadMoreForLastSearchResult: Result.success([])
        )
        let viewModel = SearchUsersViewModel(usecase: usecase)
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for executionStatus")
        let paginationExecutionStatusExpectation = XCTestExpectation(description: "Wait for paginationExecutionStatus")

        await viewModel.searchUsersBy(search: "teste")
        
        try! assertViewModelPublishers(viewModel: viewModel,
                                       expectedUsers: nil,
                                       expectedStatus: .failed(error: searchUsersException),
                                       expectedPaginationStatus: .none,
                                       usersExpectation: usersExpectation,
                                       statusExpectation: executionStatusExpectation,
                                       paginationExpectation: paginationExecutionStatusExpectation)
  
        
        try! assertUsers(value: viewModel.users, expected: nil)
        try! assertExecutionStatus(value: viewModel.executionStatus, expected: .failed(error: searchUsersException))
        try! assertExecutionStatus(value: viewModel.paginationExecutionStatus, expected: .none)
        XCTAssertEqual(viewModel.numberOfItems(), 0)
        XCTAssertNil(viewModel.itemAtIndex(index: 0))
    
        
        await fulfillment(of: [usersExpectation, executionStatusExpectation, paginationExecutionStatusExpectation], timeout: 10)

    }
    
    //MARK: - fetchMoreSearchResults
    
    func test_fetchMoreSearchResults_withSuccess() async throws {
        let loadedUsers = [
            SmallUserInfo(id: 1, login: "teste 1", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 2, login: "teste 12", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 13, login: "teste 100", htmlUrl: "https://google.com.br")
        ]
        
        let nextLoadedUsers = [
            SmallUserInfo(id: 15, login: "teste 200", htmlUrl: "https://google.com.br")
        ]

        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.success(loadedUsers),
            loadMoreForLastSearchResult: Result.success(nextLoadedUsers)
        )
        let viewModel = SearchUsersViewModel(usecase: usecase)
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for executionStatus")
        let paginationExecutionStatusExpectation = XCTestExpectation(description: "Wait for paginationExecutionStatus")

        await viewModel.searchUsersBy(search: "teste")
        await viewModel.fetchMoreSearchResults(lastIndex: 2)
        
        try! assertViewModelPublishers(viewModel: viewModel,
                                       expectedUsers: loadedUsers + nextLoadedUsers,
                                       expectedStatus: .success,
                                       expectedPaginationStatus: .success,
                                       usersExpectation: usersExpectation,
                                       statusExpectation: executionStatusExpectation,
                                       paginationExpectation: paginationExecutionStatusExpectation)
        
        try! assertUsers(value: viewModel.users, expected: loadedUsers + nextLoadedUsers)
        try! assertExecutionStatus(value: viewModel.executionStatus, expected: .success)
        try! assertExecutionStatus(value: viewModel.paginationExecutionStatus, expected: .success)
        
        XCTAssertEqual(viewModel.numberOfItems(), loadedUsers.count + nextLoadedUsers.count)
        XCTAssertEqual(viewModel.itemAtIndex(index: 3)?.id, (loadedUsers + nextLoadedUsers)[3].id)
    
        await fulfillment(of: [usersExpectation, executionStatusExpectation, paginationExecutionStatusExpectation], timeout: 10)

    }

    func test_fetchMoreSearchResults_withFail() async throws {
        let loadedUsers = [
            SmallUserInfo(id: 1, login: "teste 1", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 2, login: "teste 12", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 13, login: "teste 100", htmlUrl: "https://google.com.br")
        ]
        
        let nexSearchUsersException = ApiRequestError.requestFailed(statusCode: 500, errorBody: nil)

        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.success(loadedUsers),
            loadMoreForLastSearchResult: Result.failure(nexSearchUsersException)
        )
        let viewModel = SearchUsersViewModel(usecase: usecase)
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for executionStatus")
        let paginationExecutionStatusExpectation = XCTestExpectation(description: "Wait for paginationExecutionStatus")

        await viewModel.searchUsersBy(search: "teste")
        await viewModel.fetchMoreSearchResults(lastIndex: 2)
        
        try! assertViewModelPublishers(viewModel: viewModel,
                                       expectedUsers: loadedUsers,
                                       expectedStatus: .success,
                                       expectedPaginationStatus: .failed(error: nexSearchUsersException),
                                       usersExpectation: usersExpectation,
                                       statusExpectation: executionStatusExpectation,
                                       paginationExpectation: paginationExecutionStatusExpectation)

     
        try! assertUsers(value: viewModel.users, expected: loadedUsers)
        try! assertExecutionStatus(value: viewModel.executionStatus, expected: .success)
        try! assertExecutionStatus(value: viewModel.paginationExecutionStatus, expected: .failed(error: nexSearchUsersException))
        
        XCTAssertEqual(viewModel.numberOfItems(), loadedUsers.count)
        XCTAssertEqual(viewModel.itemAtIndex(index: 1)?.id, loadedUsers[1].id)
    
        await fulfillment(of: [usersExpectation, executionStatusExpectation, paginationExecutionStatusExpectation], timeout: 10)

    }

    func test_fetchMoreSearchResults_withInvalidLastIndex() async throws {
        let loadedUsers = [
            SmallUserInfo(id: 1, login: "teste 1", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 2, login: "teste 12", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 13, login: "teste 100", htmlUrl: "https://google.com.br")
        ]
        
        let nextLoadedUsers = [
            SmallUserInfo(id: 15, login: "teste 200", htmlUrl: "https://google.com.br")
        ]

        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.success(loadedUsers),
            loadMoreForLastSearchResult: Result.success(nextLoadedUsers)
        )
        let viewModel = SearchUsersViewModel(usecase: usecase)
        
        let usersExpectation = XCTestExpectation(description: "Wait for users")
        let executionStatusExpectation = XCTestExpectation(description: "Wait for executionStatus")
        let paginationExecutionStatusExpectation = XCTestExpectation(description: "Wait for paginationExecutionStatus")

        await viewModel.searchUsersBy(search: "teste")
        await viewModel.fetchMoreSearchResults(lastIndex: 0)
        
        try! assertViewModelPublishers(viewModel: viewModel,
                                       expectedUsers: loadedUsers,
                                       expectedStatus: .success,
                                       expectedPaginationStatus: .none,
                                       usersExpectation: usersExpectation,
                                       statusExpectation: executionStatusExpectation,
                                       paginationExpectation: paginationExecutionStatusExpectation)
        
        try! assertUsers(value: viewModel.users, expected: loadedUsers)
        try! assertExecutionStatus(value: viewModel.executionStatus, expected: .success)
        try! assertExecutionStatus(value: viewModel.paginationExecutionStatus, expected: .none)
        
        XCTAssertEqual(viewModel.numberOfItems(), loadedUsers.count)
        XCTAssertEqual(viewModel.itemAtIndex(index: 1)?.id, loadedUsers[1].id)
    
        await fulfillment(of: [usersExpectation, executionStatusExpectation, paginationExecutionStatusExpectation], timeout: 10)

    }
    
    //MARK: - itemAtIndex
    
    func test_itemAtIndex_whenIndexIsLessThanZero() throws {
        let loadedUsers = [
            SmallUserInfo(id: 1, login: "teste 1", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 2, login: "teste 12", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 13, login: "teste 100", htmlUrl: "https://google.com.br")
        ]
        
        let nextLoadedUsers = [
            SmallUserInfo(id: 15, login: "teste 200", htmlUrl: "https://google.com.br")
        ]

        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.success(loadedUsers),
            loadMoreForLastSearchResult: Result.success(nextLoadedUsers)
        )
        
        let viewModel = SearchUsersViewModel(usecase: usecase)
        XCTAssertNil(viewModel.itemAtIndex(index: -1))
    }
    
    func test_itemAtIndex_whenIndexIsValid() async throws {
        let loadedUsers = [
            SmallUserInfo(id: 1, login: "teste 1", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 2, login: "teste 12", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 13, login: "teste 100", htmlUrl: "https://google.com.br")
        ]

        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.success(loadedUsers),
            loadMoreForLastSearchResult: Result.success([])
        )
        
        let viewModel = SearchUsersViewModel(usecase: usecase)
        let usersExpectation = XCTestExpectation(description: "Wait for users")

        await viewModel.searchUsersBy(search: "teste")
        
        XCTAssertEqual(viewModel.itemAtIndex(index: 2)?.id, loadedUsers[2].id)
        usersExpectation.fulfill()
        
        await fulfillment(of: [usersExpectation], timeout: 10)
    }
    
    func test_itemAtIndex_whenIndexIsGreaterThanMax() async throws {
        let loadedUsers = [
            SmallUserInfo(id: 1, login: "teste 1", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 2, login: "teste 12", htmlUrl: "https://google.com.br"),
            SmallUserInfo(id: 13, login: "teste 100", htmlUrl: "https://google.com.br")
        ]

        let usecase: SearchUsersUseCaseMock = SearchUsersUseCaseMock(
            searchUsersResult: Result.success(loadedUsers),
            loadMoreForLastSearchResult: Result.success([])
        )
        
        let viewModel = SearchUsersViewModel(usecase: usecase)
        let usersExpectation = XCTestExpectation(description: "Wait for users")

        await viewModel.searchUsersBy(search: "teste")
        
        XCTAssertNil(viewModel.itemAtIndex(index: loadedUsers.count))
        usersExpectation.fulfill()
        
        await fulfillment(of: [usersExpectation], timeout: 10)

    }
    
    
    //MARK: - Helpers
    
    func assertViewModelPublishers(viewModel: SearchUsersViewModelProtocol,
                                   expectedUsers: [SmallUserInfo]?,
                                   expectedStatus: ExecutionStatus,
                                   expectedPaginationStatus: ExecutionStatus,
                                   usersExpectation: XCTestExpectation,
                                   statusExpectation: XCTestExpectation,
                                   paginationExpectation: XCTestExpectation) throws {
        viewModel.userPublisher.receive(on: RunLoop.main)
            .sink { [weak self] (users) in
                try! self!.assertUsers(value: users, expected: expectedUsers)
                usersExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.executionStatusPublisher.receive(on: RunLoop.main)
            .sink { [weak self] (status) in
                try! self!.assertExecutionStatus(value: status, expected: expectedStatus)
                statusExpectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.paginationExecutionStatusPublisher.receive(on: RunLoop.main)
            .sink { [weak self] (status) in
                try! self!.assertExecutionStatus(value: status, expected: expectedPaginationStatus)
                paginationExpectation.fulfill()
            }.store(in: &cancellables)
    }
    
    func assertUsers(value: [SmallUserInfo]?, expected: [SmallUserInfo]?) throws {
        if expected == nil {
            XCTAssertNil(value, "Users should be nil")
        } else {
            if let value, let expected, value.count == expected.count {
                XCTAssertTrue(value.enumerated().allSatisfy({item in
                    item.element.id == expected[item.offset].id
                }))
            } else {
                XCTFail()
            }

        }
    }
    
    func assertExecutionStatus(value: ExecutionStatus, expected: ExecutionStatus) throws {
        switch (expected, value) {
        case (.success, .success),
            (.inProgress, .inProgress),
            (.failed, .failed),
            (.none, .none),
            (.noData, .noData):
            XCTAssertTrue(true)
        default:
            XCTFail("value must be equal to expected, but value = \(value) and expected = \(expected)")
        }
    }
}
