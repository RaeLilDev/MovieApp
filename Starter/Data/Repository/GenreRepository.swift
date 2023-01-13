//
//  GenreRepository.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/03/2022.
//

import Foundation
import CoreData
import RxSwift

protocol GenreRepository {
    
    func get(completion: @escaping ([MovieGenre]) -> Void)
    
    func save(data: MovieGenreList)
    
    func get() -> Observable<[MovieGenre]>
}

class GenreRepositoryImpl: BaseRepository, GenreRepository {
    
    static let shared: GenreRepository = GenreRepositoryImpl()
    
    private override init() {}
    
    
    
    func save(data: MovieGenreList) {
        
        let _ = data.genres.map {
            let entity = GenreEntity(context: coreData.context)
            entity.id = String($0.id)
            entity.name = $0.name
            return
        }
        coreData.saveContext()
        
    }
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        
        let fetchRequest: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            let results: [GenreEntity] = try coreData.context.fetch(fetchRequest)
            let items = results.map {
                GenreEntity.toMovieGenre(entity: $0)
            }
            completion(items)
        } catch {
            completion([MovieGenre]())
            print("\(#function) \(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Rx
    func get() -> Observable<[MovieGenre]> {
        
        return coreData.context.rx.entities(MovieGenre.self,
                sortDescriptors: [ NSSortDescriptor(key: "name", ascending: true)
                    ])
        .map { $0 }
        
    }
    
}
