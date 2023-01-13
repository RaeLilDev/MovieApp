//
//  SearchContentViewModelTest.swift
//  StarterTests
//
//  Created by Ye linn htet on 6/16/22.
//

import XCTest
@testable import Starter
import RxSwift

class SearchContentViewModelTest: XCTestCase {

    
    var viewModel: MovieSearchViewModel!
    var networkAgent: MockRxNetworkAgent!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        networkAgent = MockRxNetworkAgent()
        
        viewModel = MovieSearchViewModel(networkAgent: networkAgent)
        
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        networkAgent = nil
        disposeBag = nil
    }

    func test_viewModelInitState_withInitialization_returnsCorrectState() throws {
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPages, 1)
    }
    
    func test_handlePagination_withIndexPathAndSearchText_currentPageShouldIncrement() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        
        //Prepare Data
        viewModel.searchResultItems.onNext([MovieResult.dummy()])
        viewModel.currentPage = 1
        viewModel.totalPages = 2
        
        //trigger target method
        viewModel.handlePagination(indexPath: indexPath, searchText: "abc")
        
        //Assertion
        XCTAssertEqual(viewModel.currentPage, 2)
        
    }
    
    func test_handleSearchInputText_withTextEmpty_dataShouldResult() throws {
        viewModel.handleSearchInputText(text: "")
        
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPages, 1)
        
        let waitExpectation = expectation(description: "wait for response")
        viewModel.searchResultItems
            .subscribe(onNext: { data in
                waitExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [waitExpectation], timeout: 5)
    }
    
    func test_searchMovies_withSimpleData_shouldItems() throws {
        viewModel.fetchFilmsByName(name: "test", page: 1)
        
        let waitExpectation = expectation(description: "wait for response")
        
        viewModel.searchResultItems
            .subscribe(onNext: { [weak self] data in
                
                guard let self = self else { return }
                
                XCTAssertEqual(self.viewModel.totalPages, 16)
                XCTAssertGreaterThan(data.count, 0)
                
                waitExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [waitExpectation], timeout: 5)
    }

}
