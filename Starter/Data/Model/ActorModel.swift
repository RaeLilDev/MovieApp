//
//  ActorModel.swift
//  Starter
//
//  Created by Ye Lynn Htet on 26/03/2022.
//

import Foundation
import RxSwift

protocol ActorModel {
    
    var totalPageActorList: Int { get set }
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void)
    
    func getCombinedCredits(id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    
    func getActorDetail(id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void)
    
    func getPopularPeople(page: Int) ->Observable<[ActorInfoResponse]>
    
    
}

class ActorModelImpl: BaseModel, ActorModel {
    
    static let shared = ActorModelImpl()
    
    private let actorRepository: ActorRepository = ActorRepositoryImpl.shared
    
    var totalPageActorList: Int = 1
    
    private let disposeBag = DisposeBag()
    
    
    private override init() { }
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void) {
        //networkAgent.getPopularPeople(page: page, completion: completion)
        var networkResult = [ActorInfoResponse]()
        networkAgent.getPopularPeople(page: page) { result in
            switch result {
            case .success(let data):
                networkResult = data.results ?? [ActorInfoResponse]()
                self.actorRepository.save(list: data.results ?? [ActorInfoResponse]())
                self.totalPageActorList = data.totalPages ?? 1
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.actorRepository.getList(page: page, type: "Popular People") { result in
                completion(.success(result))
            }
            
            if networkResult.isEmpty {
                self.actorRepository.getTotalPageActorList { self.totalPageActorList = $0 }
            }
        }
    }
    
    func getCombinedCredits(id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        
        networkAgent.getCombinedCredits(id: id) { result in
            switch result {
            case .success(let data):
                print(data)
                self.actorRepository.saveCombinedCreditByActor(id: id, data: data.cast!)
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.actorRepository.getCombinedCreditByActor(id: id) { result in
                completion(.success(result))
            }

        }
    }
    
    func getActorDetail(id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        //networkAgent.getActorDetail(id: id, completion: completion)
        
        networkAgent.getActorDetail(id: id) { result in
            switch result {
            case .success(let data):
                self.actorRepository.saveDetails(data: data)
                
            case .failure(let error):
                print("\(#function) \(error)")
                
            }
            
            self.actorRepository.getDetails(id: id) { actor in
                if let actor = actor {
                    completion(.success(actor))
                } else {
                    completion(.failure("Failed to get detail with id \(id)"))
                }
            }
        }
        
    }
    
    
    //MARK: - Rx
    
    func getPopularPeople(page: Int) ->Observable<[ActorInfoResponse]> {
        
        let observableRemoteActorList = RxNetworkAgent.shared.getPopularPeople(page: page)
        
        observableRemoteActorList
            .subscribe(onNext: { data in
                self.actorRepository.save(list: data.results ?? [ActorInfoResponse]())
            })
            .disposed(by: disposeBag)
        
        let observableLocalActorList = self.actorRepository.getList(page: page, type: "Popular People")
        
        
        return observableLocalActorList
    }
    
    
}

