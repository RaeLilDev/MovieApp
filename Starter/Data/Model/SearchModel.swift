//
//  SearchModel.swift
//  Starter
//
//  Created by Ye Lynn Htet on 26/03/2022.
//

import Foundation
import RxSwift

protocol SearchModel {

    func getFilmsByName(name: String, page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    
}

class SearchModelImpl: BaseModel, SearchModel {
    
    static let shared = SearchModelImpl()
    
    private override init() { }
    
    func getFilmsByName(name: String, page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getFilmsByName(name: name, page: page, completion: completion)
    }
    
    
    //MARK: - Rx
    func getFilmsByName(name: String, page: Int) -> Observable<MovieListResponse> {
        print("Total page is \(page)")
        return RxNetworkAgent.shared.searchMovies(name: name, page: page)
    }
    
    
}
