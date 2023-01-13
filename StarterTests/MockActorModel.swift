//
//  MockActorModel.swift
//  StarterTests
//
//  Created by Ye linn htet on 6/17/22.
//

import Foundation
@testable import Starter
import RxSwift

class MockActorModel: ActorModel {
    
    var totalPageActorList: Int = 0
    
    var isEmptyModel: Bool = false
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void) {
        
    }
    
    func getCombinedCredits(id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        
    }
    
    func getActorDetail(id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        
    }
    
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]> {
        if isEmptyModel {
            return Observable.empty()
        } else {
            let actorDataJson: Data = try! Data(contentsOf: MovieMockData.ActorList.popularPeopleJSONURL)
            let actorListResponse: ActorListResponse = try! JSONDecoder().decode(ActorListResponse.self, from: actorDataJson)
            return Observable.just(actorListResponse.results!)
        }
        
        
    }
    
    
}
