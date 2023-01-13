//
//  MovieViewModel.swift
//  Starter
//
//  Created by Ye linn htet on 6/2/22.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    //MARK: - Observables
    
    let homeItemList = BehaviorRelay<[HomeMovieSectionModel]>(value: [])
    
    private var observableUpcomingMovies = BehaviorRelay<[MovieResult]>(value: [])
    let observablePopularMovies = BehaviorRelay<[MovieResult]>(value: [])
    let observablePopularSeries = BehaviorRelay<[MovieResult]>(value: [])
    let observableMovieGenres = BehaviorRelay<[MovieGenre]>(value: [])
    let observableShowCaseMovies = BehaviorRelay<[MovieResult]>(value: [])
    let observablePopularPeople = BehaviorRelay<[ActorInfoResponse]>(value: [])
    
    
    var movieModel:RxMovieModel = RxMovieModelImpl.shared
    var actorModel:ActorModel = ActorModelImpl.shared
    
    private let disposeBag = DisposeBag()
    
    init(movieModel: RxMovieModel, actorModel: ActorModel) {
        self.movieModel = movieModel
        self.actorModel = actorModel
        initObservers()
    }
    
    
    init() {
        initObservers()
    }
    
    private func initObservers() {
        
        Observable.combineLatest(
            observableUpcomingMovies,
            observablePopularMovies,
            observablePopularSeries,
            observableMovieGenres,
            observableShowCaseMovies,
            observablePopularPeople
        )
        .subscribe {(
            upcomingMovies,
            popularMovies,
            populerSeries,
            movieGenres,
            showcaseMovies,
            popularPeople) in
            
            var items = [HomeMovieSectionModel]()
            
            var allMoviesAndSeries = [MovieResult]()
            
            allMoviesAndSeries.append(contentsOf: upcomingMovies)
            allMoviesAndSeries.append(contentsOf: popularMovies)
            allMoviesAndSeries.append(contentsOf: populerSeries)

            let genreVOs = movieGenres.map { $0.convertToGenreVO() }
            genreVOs.first?.isSelected = true
            
            if !upcomingMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.upcomingMoviesSection(items: upcomingMovies)]))
            }
            
            if !popularMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularMoviesSection(items: popularMovies)]))
            }
            
            if !populerSeries.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularSeriesSection(items: populerSeries)]))
            }
            
            items.append(HomeMovieSectionModel.movieResult(items: [.movieShowTimeSection]))
            
            if !movieGenres.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.movieGenreSection(items: genreVOs, movies: allMoviesAndSeries)]))
            }
            
            if !showcaseMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.showcaseMoviesSection(items: showcaseMovies)]))
            }
            
            if !popularPeople.isEmpty {
                items.append(HomeMovieSectionModel.actorResult(items: [.bestActorSection(items: popularPeople)]))
            }
            
            self.homeItemList.accept(items)
            
        }.disposed(by: disposeBag)
    }
    
    
    func fetchAllData() {
        
        print("Fetch all data working")
        getPopularMovieList()
        getPopularSeriesList()
        getTopRatedMovieList()
        getUpcomingMovieList()
        getPopularPeople()
        getGenreList()
    }
    
    func getPopularMovieList() {
        movieModel.getPopularMovieList(page: 1)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.observablePopularMovies.accept(data)
            })
            .disposed(by: disposeBag)
    }
    
    func getPopularSeriesList() {
        movieModel.getPopularTVSeriesList()
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.observablePopularSeries.accept(data)
            })
            .disposed(by: disposeBag)
    }
    
    
    func getTopRatedMovieList() {
        movieModel.getTopRatedMovieList(page: 1)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.observableShowCaseMovies.accept(data)
            })
            .disposed(by: disposeBag)
    }
    
    func getUpcomingMovieList() {
        movieModel.getUpcomingMovieList(page: 1)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.observableUpcomingMovies.accept(data)
            })
            .disposed(by: disposeBag)
    }
    
    func getPopularPeople() {
        actorModel.getPopularPeople(page: 1)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.observablePopularPeople.accept(data)})
            .disposed(by: disposeBag)
    }
    
    func getGenreList() {
        movieModel.getGenreList()
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.observableMovieGenres.accept(data)})
            .disposed(by: disposeBag)
    }
}


