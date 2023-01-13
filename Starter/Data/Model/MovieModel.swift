//
//  MovieModel.swift
//  Starter
//
//  Created by Ye Lynn Htet on 25/03/2022.
//

import Foundation

protocol MovieModel {
    
    var totalPageTopRatedMovieList: Int { get set }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void)
    func getPopupularMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getUpcomingMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getPopularTVSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
}

class MovieModelImpl: BaseModel, MovieModel {
    
    private let genreRepository: GenreRepository = GenreRepositoryImpl.shared
    private let movieRepository: MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepository: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    static let shared = MovieModelImpl()
    
    var totalPageTopRatedMovieList: Int = 1
    
    private override init() { }
    
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        
        let contentType: MovieSerieGroupType = .topRatedMovies
        
        var networkResult = [MovieResult]()
        networkAgent.getTopRatedMovieList(page: page) { result in
            switch result {
            case .success(let data):
                networkResult = data.results ?? [MovieResult]()
                self.movieRepository.saveList(type: contentType, data: data)
                self.totalPageTopRatedMovieList = data.totalPages ?? 1
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getList(page: page, type: contentType) { result in
                completion(.success(result))
            }
            
            
            if networkResult.isEmpty {
                //self.actorRepository.getTotalPageActorList { self.totalPageActorList = $0 }
                
                self.contentTypeRepository.getTopRatedMovieTotalPages(type: contentType, completion: { result in
                    self.totalPageTopRatedMovieList = result
                })
            }
        }
        
        
        
        
    }
    
    func getGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void) {
        
        networkAgent.getGenreList { result in
            switch result {
            case .success(let data):
                self.genreRepository.save(data: data)

            case .failure(let message):
                print("\(#function) \(message)")

            }

            self.genreRepository.get { completion(.success($0))}
        }
    }
    
    func getPopupularMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        
        let contentType: MovieSerieGroupType = .popularMovies
        
        networkAgent.getPopupularMovieList(page: page) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: contentType, data: data)
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.contentTypeRepository.getMovieOrSeries(type: contentType) { completion(.success($0))}
        }
        
    }
    
    func getUpcomingMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        
        let contentType: MovieSerieGroupType = .upcomingMovies
        
        networkAgent.getUpcomingMovieList(page: page) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: contentType, data: data)
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMovieOrSeries(type: contentType) { completion(.success($0))}
        }
    }
    
    func getPopularTVSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        
        let contentType: MovieSerieGroupType = .popularSeries
        
        networkAgent.getPopularTVSeriesList { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: contentType, data: data)
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.contentTypeRepository.getMovieOrSeries(type: contentType) { completion(.success($0))}
        }
    }
}
