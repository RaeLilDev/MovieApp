//
//  MDBEndpoint.swift
//  Starter
//
//  Created by Ye Lynn Htet on 23/03/2022.
//

import Foundation
import Alamofire

enum MDBEndpoint: URLConvertible {
    // 1 - enum case with associated value
    
    case searchFilms(_ page: Int, _ query: String)
    case actorCombinedCredits(_ id: Int)
    case actorImages(_ id: Int)
    case actorDetail(_ id: Int)
    case trailerVideo(_ id: Int)
    case similarFilms(_ id: Int, _ type: String)
    case movieActors(_ id: Int, _ type: String)
    case filmsDetail(_ id: Int, _ type: String)
    case popularActors(_ page: Int)
    case topRatedMovies(_ page: Int)
    case movieGenres
    case popularTVSeries
    case upcomingMovie(_ page: Int)
    case popularMovie(_ page: Int)
    
    
    private var baseURL: String {
        return AppConstants.BaseURL
    }
    
    func asURL() throws -> URL {
        return url
    }
    
    var url: URL {
        let urlComponents = NSURLComponents(string: baseURL.appending(apiPath))
        
        if (urlComponents?.queryItems == nil) {
            urlComponents!.queryItems = []
        }
        urlComponents!.queryItems!.append(contentsOf: [URLQueryItem(name: "api_key", value: AppConstants.apiKey)])
        
        return urlComponents!.url!
    }
    
    // 2 - construct api url
    private var apiPath: String {
        switch self {
        case .upcomingMovie(let page):
            return "/movie/upcoming?page=\(page)"
        case .popularMovie(let page):
            return "/movie/popular?page=\(page)"
        case .searchFilms(let page, let query):
            return "/search/movie?query=\(query)&page=\(page)"
        case .actorCombinedCredits(let id):
            return "/person/\(id)/combined_credits"
        case .actorImages(let id):
            return "/person/\(id)/images"
        case .actorDetail(let id):
            return "/person/\(id)"
        case .trailerVideo(let id):
            return "/movie/\(id)/videos"
        case .similarFilms(let id, let type):
            return "/\(type)/\(id)/similar"
        case .movieActors(let id, let type):
            return "/\(type)/\(id)/credits"
        case .filmsDetail(let id, let type):
            return "/\(type)/\(id)"
        case .popularActors(let page):
            return "/person/popular?page=\(page)"
        case .topRatedMovies(let page):
            return "/movie/top_rated?page=\(page)"
        case .movieGenres:
            return "/genre/movie/list"
        case .popularTVSeries:
            return "/tv/popular"
            
        }
    }
}


