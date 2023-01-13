//
//  MovieViewModelTest.swift
//  StarterTests
//
//  Created by Ye linn htet on 6/17/22.
//

import XCTest
@testable import Starter
import RxSwift

class MovieViewModelTest: XCTestCase {

    var viewModel: MovieViewModel!
    var movieModel: MockRxMovieModel!
    var actorModel: MockActorModel!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        
        movieModel = MockRxMovieModel()
        actorModel = MockActorModel()
        
        viewModel = MovieViewModel(movieModel: movieModel, actorModel: actorModel)
        
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        movieModel = nil
        actorModel = nil
        viewModel = nil
        disposeBag = nil
    }
    
    
    func test_fetchAllDataHomeItemList_allDataExist_returnsAllItems() {
        
        let responseExpectation = expectation(description: "wait for response")
        
        viewModel.fetchAllData()
        
        self.viewModel.homeItemList.subscribe(onNext: { [weak self] (items) in
            guard let self = self else { return }
            
            XCTAssertGreaterThan(self.viewModel.homeItemList.value.count, 1)
            responseExpectation.fulfill()
            
        }, onError: { (error) in
            XCTFail("Shouldn't fail")
        }).disposed(by: disposeBag)
        
        wait(for: [responseExpectation], timeout: 2)
    }
    
    
    func test_fetchAllDataHomeItemList_allDataIsEmpty_returnsMovieShowTimeSectionItemOnly() {
        
        movieModel.isEmptyModel = true
        actorModel.isEmptyModel = true

        let responseExpectation = expectation(description: "wait for response")
        
        viewModel.fetchAllData()
        
        self.viewModel.homeItemList.subscribe(onNext: { [weak self] (items) in
            guard let self = self else { return }

            XCTAssertEqual(self.viewModel.homeItemList.value.count, 1)
            responseExpectation.fulfill()
        }, onError: { (error) in
            XCTFail("Shouldn't fail")
        }).disposed(by: disposeBag)

        wait(for: [responseExpectation], timeout: 2)
    }
    
    
    func test_fetchAllDataHomeItemList_upcomingMoviesIsEmpty_returnsWithoutUpcomingMovies() {
        movieModel.isEmptyUpcoming = true

        let responseExpectation = expectation(description: "wait for response")
        
        viewModel.fetchAllData()
        
        self.viewModel.homeItemList.subscribe(onNext: { [weak self] (items) in
            guard let self = self else { return }

            XCTAssertEqual(self.viewModel.homeItemList.value.count, 6)
            responseExpectation.fulfill()
        }, onError: { (error) in
            XCTFail("Shouldn't fail")
        }).disposed(by: disposeBag)

        wait(for: [responseExpectation], timeout: 2)
    }
    

}
