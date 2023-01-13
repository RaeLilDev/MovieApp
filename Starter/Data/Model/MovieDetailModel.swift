//
//  MovieDetailModel.swift
//  Starter
//
//  Created by Ye Lynn Htet on 26/03/2022.
//

import Foundation

protocol MovieDetailModel {
    
    func getMovieTrailerVideo(id: Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getSimilarMovieList(id: Int, type: String, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getMovieCreditById(id: Int, type: String, completion: @escaping (MDBResult<[MovieCast]>) -> Void)
    func getMovieDetailById(id: Int, type: String, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
}

class MovieDetailModelImpl: BaseModel, MovieDetailModel {
    
    static let shared = MovieDetailModelImpl()
    
    private let movieRepository: MovieRepository = MovieRepositoryImpl.shared
    
    private override init() { }
    
    func getMovieTrailerVideo(id: Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        networkAgent.getMovieTrailerVideo(id: id, completion: completion)
    }
    
    func getSimilarMovieList(id: Int, type: String, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        //networkAgent.getSimilarMovieList(id: id, type: type, completion: completion)
        networkAgent.getSimilarMovieList(id: id, type: type) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveSimilarContent(id: id, data: data.results ?? [MovieResult]())
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRepository.getSimilarContent(id: id) { result in
                completion(.success(result))
            }
        }
    }
    
    func getMovieCreditById(id: Int, type: String, completion: @escaping (MDBResult<[MovieCast]>) -> Void) {
        //networkAgent.getMovieCreditById(id: id, type: type, completion: completion)
        networkAgent.getMovieCreditById(id: id, type: type) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveCasts(id: id, data: data.cast ?? [MovieCast]())
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.movieRepository.getCasts(id: id) { result in
                print(result.count)
                completion(.success(result))
            }
        }
    }
    
    func getMovieDetailById(id: Int, type: String, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        
        networkAgent.getMovieDetailById(id: id, type: type) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveDetail(data: data)
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRepository.getDetail(id: id) { item in
                DispatchQueue.main.async {
                    if let item = item {
                        completion(.success(item))
                    } else {
                        completion(.failure("Failed to get detail with id \(id)"))
                    }
                }
            }
        }
    }
    
    
}

