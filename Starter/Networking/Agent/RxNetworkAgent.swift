//
//  RxNetworkAgent.swift
//  Starter
//
//  Created by Ye linn htet on 5/25/22.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import UIKit

enum MDBError: Error {
    case withMessage(String)
}


protocol RxNetworkAgentProtocol {
    
    func searchMovies(name: String, page: Int) -> Observable<MovieListResponse>
    
    func getPopupularMovieList(page: Int) -> Observable<MovieListResponse>
    
    func getPopularTVSeriesList() -> Observable<MovieListResponse>
    
    func getUpcomingMovieList(page: Int) -> Observable<MovieListResponse>
    
    func getTopRatedMovieList(page: Int) -> Observable<MovieListResponse>
    
    func getGenreList() -> Observable<MovieGenreList>
    
    func getPopularPeople(page: Int) -> Observable<ActorListResponse>
}


class RxNetworkAgent: RxNetworkAgentProtocol {
    
    static let shared = RxNetworkAgent()
    
    private init() { }
    
    func searchMovies(name: String, page: Int = 1) -> Observable<MovieListResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.searchFilms(page, name).url))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getPopupularMovieList(page: Int = 1) -> Observable<MovieListResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.popularMovie(page).url))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    
    func getPopularTVSeriesList() -> Observable<MovieListResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.popularTVSeries.url))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getUpcomingMovieList(page: Int = 1) -> Observable<MovieListResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.upcomingMovie(page).url))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getTopRatedMovieList(page: Int = 1) -> Observable<MovieListResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.topRatedMovies(page).url))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getGenreList() -> Observable<MovieGenreList> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.movieGenres.url))
            .flatMap { item -> Observable<MovieGenreList> in
                return Observable.just(item.1)
            }
    }
    
    func getPopularPeople(page: Int = 1) -> Observable<ActorListResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.popularActors(page).url))
            .flatMap { item -> Observable<ActorListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getMovieDetailById(id: Int, type: String) -> Observable<MovieDetailResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.filmsDetail(id, type).url))
            .flatMap { item -> Observable<MovieDetailResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getSimilarMovieList(id: Int, type: String) -> Observable<MovieListResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.similarFilms(id, type).url))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getMovieCreditById(id: Int, type: String) -> Observable<MovieCreditResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.movieActors(id, type).url))
            .flatMap { item -> Observable<MovieCreditResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getMovieTrailerVideo(id: Int) -> Observable<MovieTrailerResponse> {
        RxAlamofire
            .requestDecodable(URLRequest(url: MDBEndpoint.trailerVideo(id).url))
            .flatMap { item -> Observable<MovieTrailerResponse> in
                return Observable.just(item.1)
            }
    }

}
