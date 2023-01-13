//
//  NetworkClientTest.swift
//  StarterTests
//
//  Created by Ye linn htet on 6/15/22.
//

import XCTest
@testable import Starter
import Alamofire
import Mocker

class NetworkClientTest: XCTestCase {

    var networkClient = MovieDBNetworkAgent.shared
    
    override func setUpWithError() throws {
        //Init Mock
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        
        //Setting up dependency
        let sessionManager = Session(configuration: configuration)
        networkClient.sessionManager = sessionManager
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    //MARK: - Search Movie Result
    func test_searchMovie_successWithValidResponse_returnsCorrectData() throws {
        
        //Prepare mock data
        let query: String = "game"
        let page: Int = 1
        let apiEndpoint = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)&page=\(page)&api_key=\(AppConstants.apiKey)")!
        
        let searchMovieExpectation = expectation(description: "wait for search movie")
        
        //Load Data from json file
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.SearchMovieResult.searchResultJSONUrl)
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 200,
            data: [.get: mockedDataFromJSON])
        
        mock.register()
        
        networkClient.getFilmsByName(name: query, page: page) { result in
            switch result {
            case .success(let response):
                //Test by assertion
                XCTAssertEqual(response.page, 1)
                XCTAssertGreaterThan(response.results!.count, 0)
                
            case .failure(let error):
                XCTFail("Shouldn't fail with \(error)")
            }
            
            searchMovieExpectation.fulfill()
        }
        
        wait(for: [searchMovieExpectation], timeout: 5)
        
    }
    
    func test_searchMovie_failedWithCorruptJson_returnsCustomErrorMessage() throws {
        //Prepare mock data
        let query: String = "game"
        let page: Int = 1
        let apiEndpoint = MDBEndpoint.searchFilms(page, query).url
        
        let searchMovieExpectation = expectation(description: "wait for search movie")
        
        //Load Data from json file
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.corruptResponseURL)
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 200,
            data: [.get: mockedDataFromJSON])
        
        mock.register()
        
        networkClient.getFilmsByName(name: query, page: page) { result in
            switch result {
            case .success(_):
                //Test by assertion
                XCTFail("Shouldn't succeed.")
                
            case .failure(let error):
                print("\(#function) : error")
                XCTAssertGreaterThan(error.count, 0)
            }
            
            searchMovieExpectation.fulfill()
        }
        
        wait(for: [searchMovieExpectation], timeout: 5)
        
    }
    
    func test_searchMovie_withoutAPIKey_returnsErrorMessage() throws {
        //Prepare mock data
        let query: String = "game"
        let page: Int = 1
        let apiEndpoint = MDBEndpoint.searchFilms(page, query).url
        
        //Load Data from json file
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.SearchMovieResult.invalidAPIKeyResponseURL)
        
        let searchMovieExpectation = expectation(description: "wait for search movie")
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 401,
            data: [.get: mockedDataFromJSON])
        
        mock.register()
        
        networkClient.getFilmsByName(name: query, page: page) { result in
            switch result {
            case .success(_):
                //Test by assertion
                XCTFail("Shouldn't succeed.")
                
            case .failure(let error):
                XCTAssertEqual(error, "Invalid API key: You must be granted a valid key.")
            }
            
            searchMovieExpectation.fulfill()
        }
        
        wait(for: [searchMovieExpectation], timeout: 5)
    }
    
    func test_searchMovie_withoutQuery_returnsErrorMessage() throws {
        
    }

}
