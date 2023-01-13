//
//  MovieDBNetworkAgentWithURLSession.swift
//  Starter
//
//  Created by Ye Lynn Htet on 24/03/2022.
//

import Foundation

class MovieDBNetworkAgentWithURLSession: MovieDBNetworkAgentProtocol {
    
    static let shared = MovieDBNetworkAgentWithURLSession()
    
    private init() {}
    
    func getFilmsByName(name: String, page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getCombinedCredits(id: Int, completion: @escaping (MDBResult<MovieCreditByActorResponse>) -> Void) {
        
    }
    
    func getActorDetail(id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        
    }
    
    func getMovieTrailerVideo(id: Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        
    }
    
    func getSimilarMovieList(id: Int, type: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getMovieCreditById(id: Int, type: String, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        
    }
    
    func getMovieDetailById(id: Int, type: String, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        
    }
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        
    }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
        let url = URL(string: "\(AppConstants.BaseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET" //case sensitive
        
        urlRequest.allHTTPHeaderFields = ["key1": "value1", "key2": "value2"]
        urlRequest.setValue("value3", forHTTPHeaderField: "key3")
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            
            let genreList: MovieGenreList = try! JSONDecoder().decode(MovieGenreList.self, from: data!)
            print(genreList.genres.count)
            
        }.resume()
    }
    
    func getPopularTVSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getPopupularMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getUpcomingMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
}
