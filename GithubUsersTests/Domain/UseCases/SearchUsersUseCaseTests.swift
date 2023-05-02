//
//  SearchUsersUseCaseTests.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 27/04/23.
//

import XCTest
@testable import GithubUsers

final class SearchUsersUseCaseTests: XCTestCase {
    func test_searchUsersFirstPage_success() async throws {
        let search = "John Doe"
        let sort:SearchUsersSortBy? = nil
        let order = GithubUsers.SearchUsersOrderBy.ascending
        
        let repository = UsersRepositoryMockforSearchUsersUseCaseTests(
            withResult: SearchUsersResult(totalCount: 300,
                                          users: [
                                            SmallUserInfo(id: 1, login: "someone one", htmlUrl: "https://github.com/someoneone"),
                                            SmallUserInfo(id: 2, login: "someone two", htmlUrl: "https://github.com/someonetwo"),
                                            SmallUserInfo(id: 3, login: "someone three", htmlUrl: "https://github.com/someonethree")
                                          ]
                                         )
        )

        let usecase = SearchUsersUseCase(usersRepository: repository)

        XCTAssertNil(repository.lastSearchParams)
        
        let searchExpectation = XCTestExpectation(description: "Wait for search users result")
        let result = try await usecase.searchUsers(search: search, sortBy: sort, orderBy: order)
        
        assertSearchParams(
            expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                by: search, page: 1, perPage: usecase.perPage, sortBy: sort, orderBy: order
            ),
            result: repository.lastSearchParams
        )
        
        assertSuccessResult(expected: repository.successResult?.users, result: result)
        
        searchExpectation.fulfill()
        await fulfillment(of: [searchExpectation], timeout: 10)

    }

    func test_searchUsersFirstPage_failed() async throws {
        let search = "John Doe"
        let sort:SearchUsersSortBy? = nil
        let order = GithubUsers.SearchUsersOrderBy.ascending
        
        let repository = UsersRepositoryMockforSearchUsersUseCaseTests(withError: ApiRequestError.unknownError)

        let usecase = SearchUsersUseCase(usersRepository: repository)

        XCTAssertNil(repository.lastSearchParams)
        
        let searchExpectation = XCTestExpectation(description: "Wait for search users result")

        do {
            let _ = try await usecase.searchUsers(search: search, sortBy: sort, orderBy: order)
            XCTFail()
        } catch where error is ApiRequestError {
            assertSearchParams(
                expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                    by: search, page: 1, perPage: usecase.perPage, sortBy: sort, orderBy: order
                ),
                result: repository.lastSearchParams
            )
        } catch {
            XCTFail()
        }
                
        searchExpectation.fulfill()
        await fulfillment(of: [searchExpectation], timeout: 10)

    }

    
    func test_searchUsersNextPages_success() async throws {
        let search = "John Doe"
        let sort:SearchUsersSortBy? = nil
        let order = GithubUsers.SearchUsersOrderBy.ascending
        
        let repository = UsersRepositoryMockforSearchUsersUseCaseTests(
            withResult: SearchUsersResult(totalCount: 300,
                                          users: [
                                            SmallUserInfo(id: 1, login: "someone one", htmlUrl: "https://github.com/someoneone"),
                                            SmallUserInfo(id: 2, login: "someone two", htmlUrl: "https://github.com/someonetwo"),
                                            SmallUserInfo(id: 3, login: "someone three", htmlUrl: "https://github.com/someonethree")
                                          ]
                                         )
        )

        let usecase = SearchUsersUseCase(usersRepository: repository)

        XCTAssertNil(repository.lastSearchParams)
        
        let searchExpectation = XCTestExpectation(description: "Wait for search users result")
        let _ = try await usecase.searchUsers(search: search, sortBy: sort, orderBy: order)
        assertSearchParams(
            expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                by: search, page: 1, perPage: usecase.perPage, sortBy: sort, orderBy: order
            ),
            result: repository.lastSearchParams
        )
        
        let nextPageResult = try await usecase.loadMoreForLastSearch()
        assertSearchParams(
            expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                by: search, page: 2, perPage: usecase.perPage, sortBy: sort, orderBy: order
            ),
            result: repository.lastSearchParams
        )
        assertSuccessResult(expected: repository.successResult?.users, result: nextPageResult)

        
        searchExpectation.fulfill()
        await fulfillment(of: [searchExpectation], timeout: 10)

    }


    func test_searchUsersNextPages_withoutMorePagesToLoad_success() async throws {
        let search = "John Doe"
        let sort:SearchUsersSortBy? = nil
        let order = GithubUsers.SearchUsersOrderBy.ascending
        
        let repository = UsersRepositoryMockforSearchUsersUseCaseTests(
            withResult: SearchUsersResult(totalCount: 3,
                                          users: [
                                            SmallUserInfo(id: 1, login: "someone one", htmlUrl: "https://github.com/someoneone"),
                                            SmallUserInfo(id: 2, login: "someone two", htmlUrl: "https://github.com/someonetwo"),
                                            SmallUserInfo(id: 3, login: "someone three", htmlUrl: "https://github.com/someonethree")
                                          ]
                                         )
        )

        let usecase = SearchUsersUseCase(usersRepository: repository)

        XCTAssertNil(repository.lastSearchParams)
        
        let searchExpectation = XCTestExpectation(description: "Wait for search users result")
        let _ = try await usecase.searchUsers(search: search, sortBy: sort, orderBy: order)
        assertSearchParams(
            expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                by: search, page: 1, perPage: usecase.perPage, sortBy: sort, orderBy: order
            ),
            result: repository.lastSearchParams
        )
        
        let nextPageResult = try await usecase.loadMoreForLastSearch()
        //Page keeps 1 because it does not make a repository call
        assertSearchParams(
            expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                by: search, page: 1, perPage: usecase.perPage, sortBy: sort, orderBy: order
            ),
            result: repository.lastSearchParams
        )
        assertSuccessResult(expected: [], result: nextPageResult)

        
        searchExpectation.fulfill()
        await fulfillment(of: [searchExpectation], timeout: 10)

    }
    
    func test_searchUsersNextPages_failed() async throws {
        let search = "John Doe"
        let sort:SearchUsersSortBy? = nil
        let order = GithubUsers.SearchUsersOrderBy.ascending
        
        let repository = UsersRepositoryMockforSearchUsersUseCaseTests(
            withResult: SearchUsersResult(totalCount: 300,
                                          users: [
                                            SmallUserInfo(id: 1, login: "someone one", htmlUrl: "https://github.com/someoneone"),
                                            SmallUserInfo(id: 2, login: "someone two", htmlUrl: "https://github.com/someonetwo"),
                                            SmallUserInfo(id: 3, login: "someone three", htmlUrl: "https://github.com/someonethree")
                                          ]
                                         )
        )

        let usecase = SearchUsersUseCase(usersRepository: repository)

        XCTAssertNil(repository.lastSearchParams)
        
        let searchExpectation = XCTestExpectation(description: "Wait for search users result")
        let _ = try await usecase.searchUsers(search: search, sortBy: sort, orderBy: order)
        assertSearchParams(
            expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                by: search, page: 1, perPage: usecase.perPage, sortBy: sort, orderBy: order
            ),
            result: repository.lastSearchParams
        )
        
        do {
            repository.updateForNextPage(nextPageResult: nil, error: ApiRequestError.requestFailed(statusCode: 400, errorBody: nil))
            let _ = try await usecase.loadMoreForLastSearch()
            XCTFail()
        } catch where error is ApiRequestError {
            assertSearchParams(
                expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams(
                    by: search, page: 2, perPage: usecase.perPage, sortBy: sort, orderBy: order
                ),
                result: repository.lastSearchParams
            )
        } catch {
            XCTFail()
        }
        
        searchExpectation.fulfill()
        await fulfillment(of: [searchExpectation], timeout: 10)

    }

    
    func assertSearchParams(expected: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams,
                            result: UsersRepositoryMockforSearchUsersUseCaseTests.LastSearchParams?) {
        XCTAssertEqual(expected.by, result?.by)
        XCTAssertEqual(expected.orderBy, result?.orderBy)
        XCTAssertEqual(expected.sortBy, result?.sortBy)
        XCTAssertEqual(expected.perPage, result?.perPage)
        XCTAssertEqual(expected.page, result?.page)
    }
    
    func assertSuccessResult(expected: [SmallUserInfo]?, result: [SmallUserInfo]) {
        XCTAssertEqual(expected?.count, result.count)
        XCTAssertTrue(result.enumerated().allSatisfy({ item in
            guard let user = expected?[item.offset] else {
                return false
            }
            return item.element.id == user.id
        }))

    }
}
