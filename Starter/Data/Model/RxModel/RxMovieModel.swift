//
//  RxMovieModel.swift
//  Starter
//
//  Created by Ye linn htet on 5/25/22.
//

import Foundation
import RxSwift

protocol RxMovieModel {
    
    func getUpcomingMovieList(page: Int) -> Observable<[MovieResult]>
    
    func getPopularMovieList(page: Int) -> Observable<[MovieResult]>

    func getPopularTVSeriesList() -> Observable<[MovieResult]>

    func getGenreList() -> Observable<[MovieGenre]>

    func getTopRatedMovieList(page: Int) -> Observable<[MovieResult]>
}

class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    private let genreRepository: GenreRepository = GenreRepositoryImpl.shared
    private let movieRepository: MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepository: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    
    static let shared = RxMovieModelImpl()
    
    let disposeBag = DisposeBag()
    
    private override init() { }
    
    
    func getUpcomingMovieList(page: Int) -> Observable<[MovieResult]> {
        
        let observableRemoteMovieList = RxNetworkAgent.shared.getUpcomingMovieList(page: page)
        observableRemoteMovieList
            .subscribe (onNext: { data in
                self.movieRepository.saveList(type: .upcomingMovies, data: data)
            })
            .disposed(by: disposeBag)
        
        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .upcomingMovies)
        return observableLocalMovieList
    
    }
    
    
    
    func getPopularMovieList(page: Int) -> Observable<[MovieResult]> {

        let observableRemoteMovieList = RxNetworkAgent.shared.getPopupularMovieList(page: page)
        observableRemoteMovieList
            .subscribe (onNext: { data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposeBag)

        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .popularMovies)
        return observableLocalMovieList


    }

    func getPopularTVSeriesList() -> Observable<[MovieResult]> {
        let observableRemoteMovieList = RxNetworkAgent.shared.getPopularTVSeriesList()
        observableRemoteMovieList
            .subscribe (onNext: { data in
                self.movieRepository.saveList(type: .popularSeries, data: data)
            })
            .disposed(by: disposeBag)

        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .popularSeries)
        return observableLocalMovieList
    }
    
    
    func getGenreList() -> Observable<[MovieGenre]> {
        let observableRemoteGenreList = RxNetworkAgent.shared.getGenreList()

        observableRemoteGenreList
            .subscribe( onNext: { data in
                self.genreRepository.save(data: data)
            })
            .disposed(by: disposeBag)

        let observableLocalGenreList = genreRepository.get()
        return observableLocalGenreList

    }
    

    func getTopRatedMovieList(page: Int) -> Observable<[MovieResult]> {
        
        let observableRemoteMovieList = RxNetworkAgent.shared.getTopRatedMovieList(page: page)

        return observableRemoteMovieList
            .do (onNext: { data in
                self.movieRepository.saveList(type: .topRatedMovies, data: data)
            })
            .flatMap { _ -> Observable<[MovieResult]> in
                return ContentTypeRepositoryImpl.shared.getList(page: page, type: .topRatedMovies)
            }

    }
    
    
}
