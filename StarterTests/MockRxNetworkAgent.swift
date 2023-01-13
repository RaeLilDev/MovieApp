//
//  MockRxNetworkAgent.swift
//  StarterTests
//
//  Created by Ye linn htet on 6/16/22.
//

import Foundation
@testable import Starter
import RxSwift

class MockRxNetworkAgent: RxNetworkAgentProtocol {
    
    func searchMovies(name: String, page: Int) -> Observable<MovieListResponse> {
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.SearchMovieResult.searchResultJSONUrl)
        
        let responseData = try! JSONDecoder().decode(MovieListResponse.self, from: mockedDataFromJSON)
        
        return Observable.just(responseData)
    }
    
    func getPopupularMovieList(page: Int) -> Observable<MovieListResponse> {
        Observable.never()
    }
    
    func getPopularTVSeriesList() -> Observable<MovieListResponse> {
        Observable.never()
    }
    
    func getUpcomingMovieList(page: Int) -> Observable<MovieListResponse> {
        Observable.never()
    }
    
    func getTopRatedMovieList(page: Int) -> Observable<MovieListResponse> {
        Observable.never()
    }
    
    func getGenreList() -> Observable<MovieGenreList> {
        Observable.never()
    }
    
    func getPopularPeople(page: Int) -> Observable<ActorListResponse> {
        Observable.never()
    }
    
    
}
