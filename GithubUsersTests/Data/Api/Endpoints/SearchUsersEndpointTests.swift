//
//  SearchUsersEndpointTests.swift
//  GithubUsersTests
//
//  Created by José Lucas Souza das Chagas on 27/04/23.
//

import XCTest
@testable import GithubUsers

final class SearchUsersEndpointTests: XCTestCase {
    
    func test_initWith_validValues() throws {
        let search = "John Doe"
        let page = 2
        let perPage = 95
        let sortBy = SortBy.joined
        let order = Order.asc
        let endpoint = try SearchUsersEndpoint(by: search, page: page, perPage: perPage, sortBy: sortBy, order: order)
        
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.endpoint, "search/users")
        XCTAssertEqual(endpoint.headers.count, 0)
        XCTAssertEqual(endpoint.queries["q"], search)
        XCTAssertEqual(endpoint.queries["page"], String(describing: page))
        XCTAssertEqual(endpoint.queries["per_page"], String(describing: perPage))
        XCTAssertEqual(endpoint.queries["sort"], sortBy.rawValue)
        XCTAssertEqual(endpoint.queries["order"], order.rawValue)
    }
    
    func test_initWith_emptySearch_throwsSearchCanNotBeBlankException() throws {
        let message = "It must throw SearchUsersEndpointError.searchCanNotBeBlank exception"
        XCTAssertThrowsError(try SearchUsersEndpoint(by: ""),
                             message) { error in
            guard case SearchUsersEndpointError.searchCanNotBeBlank = error else {
                XCTFail(message)
                return
            }
            XCTAssertTrue(true, message)
        }
    }
    
    func test_initWith_blankSearch_throwsSearchCanNotBeBlankException() throws {
        let message = "It must throw SearchUsersEndpointError.searchCanNotBeBlank exception"
        XCTAssertThrowsError(try SearchUsersEndpoint(by: ""),
                             message) { error in
            guard case SearchUsersEndpointError.searchCanNotBeBlank = error else {
                XCTFail(message)
                return
            }
            XCTAssertTrue(true, message)
        }
    }
    
    func test_initWith_pageEqualZero_throwsPageLessThanOneException() throws {
        let message = "It must throw SearchUsersEndpointError.pageLessThanOne exception"
        XCTAssertThrowsError(try SearchUsersEndpoint(by: "John Doe", page: 0),
                             message) { error in
            guard case SearchUsersEndpointError.pageLessThanOne = error else {
                XCTFail(message)
                return
            }
            XCTAssertTrue(true, message)
        }
    }

    func test_initWith_perPageEqualZero_throwsPerPageLessThanOneException() throws {
        let message = "It must throw SearchUsersEndpointError.perPageLessThanOne exception"
        XCTAssertThrowsError(try SearchUsersEndpoint(by: "John Doe", page: 1, perPage: 0),
                             message) { error in
            guard case SearchUsersEndpointError.perPageLessThanOne = error else {
                XCTFail(message)
                return
            }
            XCTAssertTrue(true, message)
        }
    }
    
    func test_initWith_perPageBiggerThanMax_throwsPerPageBiggerThanMaxException() throws {
        let message = "It must throw SearchUsersEndpointError.perPageBiggerThanMax exception"
        XCTAssertThrowsError(try SearchUsersEndpoint(by: "John Doe", page: 1, perPage: SearchUsersEndpoint.perPageMaxValue + 1),
                             message) { error in
            guard case SearchUsersEndpointError.perPageBiggerThanMax = error else {
                XCTFail(message)
                return
            }
            XCTAssertTrue(true, message)
        }
    }
    
    
}
