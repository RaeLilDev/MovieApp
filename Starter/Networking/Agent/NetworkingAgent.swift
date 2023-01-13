//
//  NetworkingAgent.swift
//  Starter
//
//  Created by Ye Lynn Htet on 16/03/2022.
//

import Foundation
import Alamofire

protocol MovieDBNetworkAgentProtocol {
    
    //Films
    func getFilmsByName(name: String, page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    
    //Actor
    func getCombinedCredits(id: Int, completion: @escaping (MDBResult<MovieCreditByActorResponse>) -> Void)
    func getActorDetail(id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void)
    
    //MovieDetail
    func getMovieTrailerVideo(id: Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getSimilarMovieList(id: Int, type: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieCreditById(id: Int, type: String, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getMovieDetailById(id: Int, type: String, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    
    //Movie
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getPopupularMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getUpcomingMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularTVSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    
}

struct MovieDBNetworkAgent: MovieDBNetworkAgentProtocol {
    
    static let shared = MovieDBNetworkAgent()
    
    var sessionManager: Session = AF
    
    private init() {
        
    }
    
    func getFilmsByName(name: String, page: Int = 1, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
        sessionManager.request(MDBEndpoint.searchFilms(page, name))
            .validate()
            .responseDecodable(of: MovieListResponse.self)
            { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getCombinedCredits(id: Int, completion: @escaping (MDBResult<MovieCreditByActorResponse>) -> Void) {
    
        AF.request(MDBEndpoint.actorCombinedCredits(id)).responseDecodable(of: MovieCreditByActorResponse .self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getActorDetail(id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        AF.request(MDBEndpoint.actorDetail(id)).responseDecodable(of: ActorDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieTrailerVideo(id: Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/movie/\(id)/videos?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.trailerVideo(id)).responseDecodable(of: MovieTrailerResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSimilarMovieList(id: Int, type: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/\(type)/\(id)/similar?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.similarFilms(id, type)).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieCreditById(id: Int, type: String, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/\(type)/\(id)/credits?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.movieActors(id, type)).responseDecodable(of: MovieCreditResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieDetailById(id: Int, type: String, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        
//        URLSession.shared.dataTask(with: MDBEndpoint.filmsDetail(id, type).url) { data, _, _ in
//            completion(.success(try! JSONDecoder().decode(MovieDetailResponse.self, from: data!)))
//        }.resume()
        
        AF.request(MDBEndpoint.filmsDetail(id, type)).responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))

            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularPeople(page: Int = 1, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/person/popular?page=\(page)&api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.popularActors(page)).responseDecodable(of: ActorListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getTopRatedMovieList(page: Int = 1, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/movie/top_rated?page=\(page)&api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.topRatedMovies(page)).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.movieGenres).responseDecodable(of: MovieGenreList.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularTVSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/tv/popular?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.popularTVSeries).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    func getPopupularMovieList(page: Int = 1 ,completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/movie/popular?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.popularMovie(page)).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    
    func getUpcomingMovieList(page: Int = 1, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        //let url = "\(AppConstants.BaseURL)/movie/upcoming?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.upcomingMovie(page)).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let upcomingMovieList):
                completion(.success(upcomingMovieList))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    // 3. Customized Error body
    fileprivate func handleError<T, E : MDBErrorModel>(
        _ response : DataResponse<T, AFError>,
        _ error : (AFError),
        _ errorBodyType : E.Type) -> String {
        
        var respBody : String = ""
        var serverErrorMessage : String?
        var errorBody : E?
        
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        // 2. Extract debug info
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        // 1. Essential debug info
        print(
        """
        ================
        URL
        -> \(sourcePath)
        
        Status
        -> \(respCode)
        
        Body
        -> \(respBody)
        
        Underlying Error
        -> \(String(describing: error.underlyingError))
        
        Error Description
        -> \(error.errorDescription!)
        ====================
        """
        )
        
        // 4. Client Display
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
        
    }
    
}


protocol MDBErrorModel : Decodable {
    var message : String { get }
}

class MDBCommonResponseError: MDBErrorModel {
    var message: String {
        return statusMessage
    }
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys : String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}



enum MDBResult<T> {
    case success(T)
    case failure(String)
}


