//
//  ActorRepository.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/03/2022.
//

import Foundation
import CoreData
import RxSwift

protocol ActorRepository {
    func getList(page: Int, type: String, completion: @escaping ([ActorInfoResponse]) -> Void)
    
    func save(list: [ActorInfoResponse])
    
    func saveDetails(data: ActorDetailResponse)
    
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void)
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void)
    
    func getCombinedCreditByActor(id: Int, completion: @escaping ([MovieResult]) -> Void)
    
    func saveCombinedCreditByActor(id: Int, data: [MovieResult])
    
    func getList(page: Int, type: String) -> Observable<[ActorInfoResponse]>
}

class ActorRepositoryImpl: BaseRepository, ActorRepository {
    
    static let shared: ActorRepository = ActorRepositoryImpl()
    
    private let contentTypeRepo: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    let pageSize: Int = 20
    
    func getList(page: Int, type: String, completion: @escaping ([ActorInfoResponse]) -> Void) {
        
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "insertedAt", ascending: false),
            NSSortDescriptor(key: "popularity", ascending: false),
            NSSortDescriptor(key: "name", ascending: true),
        ]
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do {
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.map { ActorEntity.toActorInfoResponse(entity: $0)})
        } catch {
            print("\(#function) \(error.localizedDescription)")
            completion([ActorInfoResponse]())
        }
    }
    
    func save(list: [ActorInfoResponse]) {
        list.forEach {
            let _ = $0.toActorEntity(context: coreData.context, contentTypeRepo: contentTypeRepo)
        }
        coreData.saveContext()
    }
    
    func saveDetails(data: ActorDetailResponse) {
        let _ = data.toActorEntity(context: coreData.context)
        coreData.saveContext()
    }
    
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void) {
        let fetchRequest: NSFetchRequest<ActorEntity> = getActorFetchRequestById(id)

        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            completion(ActorEntity.toActorDetailResponse(entity: firstItem))
        } else {
            completion(nil)
        }
    }
    
    func saveCombinedCreditByActor(id: Int, data: [MovieResult]) {
        
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            data.map {
                $0.toMovieEntity(context: coreData.context, groupType: contentTypeRepo.getBelongsToTypeEntity(type: .actorCredits))
            }.forEach {
                firstItem.addToCredits($0)
            }
            coreData.saveContext()
        }
    }
    
    
    func getCombinedCreditByActor(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            let similars = firstItem.credits as? Set<MovieEntity>
            completion(similars?.map { MovieEntity.toMovieResult(entity: $0) } ?? [MovieResult]())
        }
    }
    
    
    func getTotalPageActorList(completion: (Int) -> Void) {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "insertedAt", ascending: false),
            NSSortDescriptor(key: "popularity", ascending: false),
            NSSortDescriptor(key: "name", ascending: true),
        ]
        do {
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.count / pageSize)
        } catch {
            print("\(#function) \(error.localizedDescription)")
            completion(1)
        }
    }
    
    private func getActorFetchRequestById(_ id: Int) -> NSFetchRequest<ActorEntity> {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
    }
    
    
    //MARK: - RX
    
    func getList(page: Int, type: String) -> Observable<[ActorInfoResponse]> {
        
        return coreData.context.rx.entities(ActorInfoResponse.self,
                    sortDescriptors: [
                        NSSortDescriptor(key: "insertedAt", ascending: false),
                        NSSortDescriptor(key: "popularity", ascending: false),
                        NSSortDescriptor(key: "name", ascending: true)
                    ])
        .flatMap { actors -> Observable<[ActorInfoResponse]> in
            return Observable.create { (observer) -> Disposable in
                let items : [ActorInfoResponse] = actors.map {
                    $0
                }
                let startAt = (self.pageSize * page) - self.pageSize
                let endAt = startAt + self.pageSize
                var results = [ActorInfoResponse]()
                if items.count > 0 {
                    results = items[startAt..<endAt].map {
                        $0
                    }
                }
                observer.onNext(results)
                return Disposables.create()
            }
        }
        
        
    }
    
    
}
