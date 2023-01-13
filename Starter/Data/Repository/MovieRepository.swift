//
//  MovieRepository.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/03/2022.
//

import Foundation
import CoreData
import RxSwift

protocol MovieRepository {
    
    func getDetail(id: Int, completion: @escaping (MovieDetailResponse?) -> Void)
    
    func saveDetail(data: MovieDetailResponse)
    
    func saveList(type: MovieSerieGroupType, data: MovieListResponse)
    
    func saveSimilarContent(id: Int, data: [MovieResult])
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void)
    
    func saveCasts(id: Int, data: [MovieCast])
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void)
    
    //MARK: - Rx
    func getDetail(id: Int) -> Observable<MovieDetailResponse?>
    
    func getCasts(id: Int) -> Observable<[MovieCast]> 
    
    func getSimilarContent(id: Int) -> Observable<[MovieResult]>
    
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
    
    
    static let shared: MovieRepository = MovieRepositoryImpl()
    
    private let contentTypeRepo: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    private override init() { }
    
    func getDetail(id: Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        
        coreData.context.perform {
            let fetchRequest: NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)

            if let items = try? self.coreData.context.fetch(fetchRequest),
               let firstItem = items.first {
                completion(MovieEntity.toMovieDetailResponse(entity: firstItem))
            } else {
                completion(nil)
            }
        }
        
    }
    
    func saveDetail(data: MovieDetailResponse) {
        
        let _ = data.toMovieEntity(context: self.coreData.context)
        print("Save Movie Detail data")
        self.coreData.saveContext()
       
    }
    
    func saveList(type: MovieSerieGroupType, data: MovieListResponse) {
        data.results?.forEach{
            $0.toMovieEntity(
                context: self.coreData.context,
                groupType: contentTypeRepo.getBelongsToTypeEntity(type: type)
            )
        }
        self.coreData.saveContext()
    }
    
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        
        let fetchRequest: NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            data.map {
                $0.toMovieEntity(
                    context: coreData.context,
                    groupType: contentTypeRepo.getBelongsToTypeEntity(type: .actorCredits)
                )
            }.forEach {
                firstItem.addToSimilarMovies($0)
            }
            print("Save Similar Contents Called")
            coreData.saveContext()
        }
    }
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        
        let fetchRequest: NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            completion(
                (firstItem.similarMovies as? Set<MovieEntity>)?.map {
                    MovieEntity.toMovieResult(entity: $0)
                } ?? [MovieResult]()
            )
        }
    }
    
    
    func saveCasts(id: Int, data: [MovieCast]) {
        
        let fetchRequest: NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            data.map {
                $0.convertToActorInfoResponse()
            }.map {
                $0.toActorEntity(context: coreData.context, contentTypeRepo: contentTypeRepo)
            }.forEach {
                firstItem.addToCasts($0)
            }
            coreData.saveContext()
        }
        
    }
    
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first,
           let actorEntities = (firstItem.casts as? Set<ActorEntity>) {
            completion(
                actorEntities.map {
                    ActorEntity.toMovieCast(entity: $0)
                }
            )
        }
    }
    
    
    private func getMovieFetchRequestById(_ id: Int) -> NSFetchRequest<MovieEntity> {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
    }
    
    
    //MARK: - Rx Methods
    
    func getDetail(id: Int) -> Observable<MovieDetailResponse?> {
        
        let fetchRequest = self.getMovieFetchRequestById(id)
        print("Rx Get Detail is called")
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map { data -> MovieDetailResponse? in
                if let item = data.first {
                    return MovieEntity.toMovieDetailResponse(entity: item)
                }
                return nil
            }
    }
    
    
    func getCasts(id: Int) -> Observable<[MovieCast]> {
        
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map { data -> [MovieCast] in
                if let item = data.first {
                    return (item.casts as? Set<ActorEntity>)?.map {
                        ActorEntity.toMovieCast(entity: $0)
                    } ?? [MovieCast]()
            }
            return [MovieCast]()
        }
    }
    
    func getSimilarContent(id: Int) -> Observable<[MovieResult]> {
        print("Rx Get Similar Contents Called")
        let fetchRequest: NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map { data -> [MovieResult] in
                if let item = data.first {
                    return (item.similarMovies as? Set<MovieEntity>)?.map {
                        MovieEntity.toMovieResult(entity: $0)
                    } ?? [MovieResult]()
                }
            return [MovieResult]()
        }
        
        
    }
        
}
    
    

