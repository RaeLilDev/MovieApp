//
//  RxMovieDetailModel.swift
//  Starter
//
//  Created by Ye linn htet on 5/28/22.
//

import Foundation
import RxSwift

protocol RxMovieDetailModel {
    
    func getMovieTrailerVideo(id: Int) -> Observable<MovieTrailerResponse>
    
    func getMovieDetailById(id: Int, type: String) -> Observable<MovieDetailResponse?>
    func getMovieCreditById(id: Int, type: String) -> Observable<[MovieCast]>
    func getSimilarMovieList(id: Int, type: String) -> Observable<[MovieResult]>
}

class RxMovieDetailModelImpl: BaseModel, RxMovieDetailModel {
    
    static let shared = RxMovieDetailModelImpl()
    
    private let movieRepository: MovieRepository = MovieRepositoryImpl.shared
    
    private let disposeBag = DisposeBag()
    
    private override init() { }
    
    
    func getMovieTrailerVideo(id: Int) -> Observable<MovieTrailerResponse> {
        return RxNetworkAgent.shared.getMovieTrailerVideo(id: id)
    }
    
    func getSimilarMovieList(id: Int, type: String) -> Observable<[MovieResult]> {
        
        let observableRemoteSimilarMovies = RxNetworkAgent.shared.getSimilarMovieList(id: id, type: type)
        
        return observableRemoteSimilarMovies
            .do(onNext: { data in
                self.movieRepository.saveSimilarContent(id: id, data: data.results ?? [MovieResult]())
            })
            .flatMap { _ -> Observable<[MovieResult]> in
                self.movieRepository.getSimilarContent(id: id)
            }
        
    }
    
    func getMovieCreditById(id: Int, type: String) -> Observable<[MovieCast]> {
        
        let observableRemoteMovieCredits = RxNetworkAgent.shared.getMovieCreditById(id: id, type: type)
        
        return observableRemoteMovieCredits
            .do( onNext: { data in
                self.movieRepository.saveCasts(id: id, data: data.cast ?? [MovieCast]())
            })
            .flatMap { _ -> Observable<[MovieCast]> in
                self.movieRepository.getCasts(id: id)
            }
    }
    
    
    func getMovieDetailById(id: Int, type: String) -> Observable<MovieDetailResponse?> {
        
        let observableRemoteMovieDetail = RxNetworkAgent.shared.getMovieDetailById(id: id, type: type)
        return observableRemoteMovieDetail
            .do (onNext: { data in
                self.movieRepository.saveDetail(data: data)
            })
            .flatMap { _ -> Observable<MovieDetailResponse?> in
                return self.movieRepository.getDetail(id: id)
            }
        
    }
    
    
}
