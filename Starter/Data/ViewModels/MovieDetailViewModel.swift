//
//  MovieDetailViewModel.swift
//  Starter
//
//  Created by Ye linn htet on 6/2/22.
//

import Foundation
import RxSwift

class MovieDetailViewModel {
    
    private let movieDetailModel: MovieDetailModel = MovieDetailModelImpl.shared
    
    private let rxMovieDetailModel: RxMovieDetailModel = RxMovieDetailModelImpl.shared
    
    private let disposeBag = DisposeBag()
    
    
    let similarMovieResultItems: BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    let castsResultItems: BehaviorSubject<[MovieCast]> = BehaviorSubject(value: [])
    let trailerResultItems: BehaviorSubject<[MovieTrailer]> = BehaviorSubject(value: [])
    let productionCompaniesResultItems: BehaviorSubject<[ProductionCompany]> = BehaviorSubject(value: [])
    
    let movieDetailResultItem: BehaviorSubject<MovieDetailResponse?> = BehaviorSubject(value: nil)
    
    var movieID: Int = -1
    var movieType: String = ""
    
    init(movieID: Int, movieType: String) {
        self.movieID = movieID
        self.movieType = movieType
    }
    
    func fetchAllData() {
//        print("Movie id is \(movieID)")
        getMovieTrailers(id: movieID)
        getSimilarMovies(id: movieID, type: movieType)
        getMovieCreditsById(id: movieID, type: movieType)
        fetchMovieDetails(id: movieID, type: movieType)
        
    }
    
    func getSelectedMovieResult(index: Int) -> MovieResult {
        let items = try! similarMovieResultItems.value()
        return items[index]
    }
    
    func getSelectedCastResult(index: Int) -> MovieCast {
        let items = try! castsResultItems.value()
        return items[index]
    }
    
    //MARK: - API Methods
     private func getMovieTrailers(id: Int) {
         
         rxMovieDetailModel.getMovieTrailerVideo(id: id)
             .subscribe(onNext: { [weak self] data in
                 guard let self = self else { return }
                 let trailers = data.results ?? [MovieTrailer]()
                 self.trailerResultItems.onNext(trailers)
             })
             .disposed(by: disposeBag)

     }
     
     private func getSimilarMovies(id: Int, type: String) {
         
         rxMovieDetailModel.getSimilarMovieList(id: id, type: type)
             .subscribe( onNext: { [weak self] data in
                 guard let self = self else { return }
                 self.similarMovieResultItems.onNext(data)
             })
             .disposed(by: disposeBag)

     }
     
     private func getMovieCreditsById(id: Int, type: String) {
         
         rxMovieDetailModel.getMovieCreditById(id: id, type: type)
             .subscribe( onNext: { [weak self] data in
                 guard let self = self else { return }
                 self.castsResultItems.onNext(data)
             })
             .disposed(by: disposeBag)

     }
     
     private func fetchMovieDetails(id: Int, type: String) {
         
         rxMovieDetailModel.getMovieDetailById(id: id, type: type)
             .subscribe(onNext: { [weak self] data in
                 guard let self = self else { return }
                 if let data = data {
                     self.movieDetailResultItem.onNext(data)
                     self.productionCompaniesResultItems.onNext(data.productionCompanies ?? [ProductionCompany]())
                 }
             })
             .disposed(by: disposeBag)

     }
}
