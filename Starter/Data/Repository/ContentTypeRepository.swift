//
//  ContentTypeRepository.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/03/2022.
//

import Foundation
import CoreData
import RxSwift
import RxCoreData

protocol ContentTypeRepository {
    
    func save(name: String) -> BelongsToTypeEntity
    
    func getMovieOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity
    
    func getTopRatedMovieTotalPages(type: MovieSerieGroupType, completion: @escaping (Int) -> Void)
    
    func getList(page: Int, type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    
    
    
    func getMoviesOrSeries(type: MovieSerieGroupType) -> Observable<[MovieResult]>
    
    func getList(page: Int, type: MovieSerieGroupType) -> Observable<[MovieResult]>
    
}

class ContentTypeRepositoryImpl: BaseRepository, ContentTypeRepository {
    
    static let shared: ContentTypeRepository = ContentTypeRepositoryImpl()
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    
    let disposeBag = DisposeBag()
    
    let pageSize: Int = 20
    
    private override init() {
        super.init()
        
        initializeData()
    }
    
    
    private func initializeData() {
        //Process Existing Data
        let fetchRequest: NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        
        do {
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            
            if dataSource.isEmpty {
                
                // Insert initial data
                MovieSerieGroupType.allCases.forEach {
                    save(name: $0.rawValue)
                }
            } else {
                // Map existing data
                dataSource.forEach {
                    if let key = $0.name {
                        contentTypeMap[key] = $0
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    @discardableResult
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        
        contentTypeMap[name] = entity
        
        coreData.saveContext()
        
        return entity
    }
    
    func getMovieOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        if let entity = contentTypeMap[type.rawValue],
           let movies = entity.movies,
           let itemSet = movies as? Set<MovieEntity> {
            
            completion(Array(itemSet.sorted(by: { (first, second)  -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                
                return firstDate.compare(secondDate) == .orderedDescending
            })).map { MovieEntity.toMovieResult(entity: $0) })
        } else {
            completion([MovieResult]())
        }
    }
    
    
   
    
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity {
        if let entity = contentTypeMap[type.rawValue] {
            return entity
        }
        return save(name: type.rawValue)
    }
    
    func getList(page: Int, type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest: NSFetchRequest<MovieEntity> = fetchRequestByBelongToType(type: type)
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do {
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.map { MovieEntity.toMovieResult(entity: $0)})
        } catch {
            print("\(#function) \(error.localizedDescription)")
            completion([MovieResult]())
        }
        
        
    }
    
    func getTopRatedMovieTotalPages(type: MovieSerieGroupType, completion: @escaping (Int) -> Void) {
        let fetchRequest: NSFetchRequest<MovieEntity> = fetchRequestByBelongToType(type: type)
        
        do {
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.count / pageSize)
        } catch {
            print("\(#function) \(error.localizedDescription)")
            completion(1)
        }
    }
    
    func fetchRequestByBelongToType(type: MovieSerieGroupType) ->NSFetchRequest <MovieEntity> {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "voteAverage", ascending: false),
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        fetchRequest.predicate = NSPredicate(format: "belongsToType.name CONTAINS[cd] %@", type.rawValue)
        return fetchRequest
    }
    
    
    
    //MARK: - Rx
    
    func getMoviesOrSeries(type: MovieSerieGroupType) -> Observable<[MovieResult]> {
        
        return coreData.context.rx.entities(MovieResult.self,
                predicate: NSPredicate(format: "belongsToType.name CONTAINS[cd] %@", type.rawValue ),
                sortDescriptors: [ NSSortDescriptor(key: "voteAverage", ascending: false),
                                   NSSortDescriptor(key: "popularity", ascending: false)])
                .map { $0 }
    }
    
    func getList(page: Int, type: MovieSerieGroupType) -> Observable<[MovieResult]> {
        
        let fetchRequest: NSFetchRequest<MovieEntity> = fetchRequestByBelongToType(type: type)
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map {
                $0.map { MovieEntity.toMovieResult(entity: $0)}
            }
    }
    
}


