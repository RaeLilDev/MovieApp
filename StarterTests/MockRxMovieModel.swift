//
//  MockRxMovieModel.swift
//  StarterTests
//
//  Created by Ye linn htet on 6/17/22.
//

import Foundation
@testable import Starter
import RxSwift

class MockRxMovieModel: RxMovieModel {
    
    var movieData: [MovieResult] = []
    var movieGenre: [MovieGenre] = []
    
    var isEmptyModel: Bool = false
    var isEmptyUpcoming: Bool = false
    
    init() {
        let movieDataJson: Data = try! Data(contentsOf: MovieMockData.MovieList.topRatedMovieJSONUrl)
        let movieResponseData: MovieListResponse = try! JSONDecoder().decode(MovieListResponse.self, from: movieDataJson)
        movieData = movieResponseData.results!
        
        let movieGenreJson: Data = try! Data(contentsOf: MovieMockData.MovieList.genreJSONUrl)
        let genreResponseData: MovieGenreList = try! JSONDecoder().decode(MovieGenreList.self, from: movieGenreJson)
        movieGenre = genreResponseData.genres
    }
    
    
    func getUpcomingMovieList(page: Int) -> Observable<[MovieResult]> {
        if isEmptyModel || isEmptyUpcoming {
            return Observable.empty()
        }
        return Observable.just(movieData)
    }
    
    func getPopularMovieList(page: Int) -> Observable<[MovieResult]> {
        if isEmptyModel {
            return Observable.empty()
        }
        return Observable.just(movieData)
    }
    
    func getPopularTVSeriesList() -> Observable<[MovieResult]> {
        if isEmptyModel {
            return Observable.empty()
        }
        return Observable.just(movieData)
    }
    
    func getGenreList() -> Observable<[MovieGenre]> {
        if isEmptyModel {
            return Observable.empty()
        }
        return Observable.just(movieGenre)
    }
    
    func getTopRatedMovieList(page: Int) -> Observable<[MovieResult]> {
        if isEmptyModel {
            return Observable.empty()
        }
        return Observable.just(movieData)
    }
    
    
}
