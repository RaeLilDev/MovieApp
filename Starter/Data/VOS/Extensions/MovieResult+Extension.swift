//
//  MovieResult+Extension.swift
//  Starter
//
//  Created by Ye linn htet on 5/26/22.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

extension MovieResult : Persistable {
    
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "MovieEntity"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    var identity: String {
        return "id"
    }
    
    init(entity: T) {
        
        adult = entity.value(forKey: "adult") as? Bool
        backdropPath = entity.value(forKey: "backdropPath") as? String
        firstAirDate = entity.value(forKey: "firstAirDate") as? String
        genreIDS = (entity.value(forKey: "genreIDs") as? String)?.components(separatedBy: ",").compactMap({ Int($0.trimmingCharacters(in: .whitespaces))})
        id = entity.value(forKey: "id") as? Int
        originalTitle = entity.value(forKey: "originalTitle") as? String
        originalLanguage = entity.value(forKey: "originalLanguage") as? String
        originalName = entity.value(forKey: "originalName") as? String
        overview = entity.value(forKey: "overview") as? String
        releaseDate = entity.value(forKey: "releaseDate") as? String
        popularity = entity.value(forKey: "popularity") as? Double
        posterPath = entity.value(forKey: "posterPath") as? String
        voteAverage = entity.value(forKey: "voteAverage") as? Double
        voteCount = entity.value(forKey: "voteCount") as? Int
        title = entity.value(forKey: "title") as? String
        video = entity.value(forKey: "video") as? Bool
    }
    
    
    func update(_ entity: T) {
        
        entity.setValue(adult, forKey: "adult")
        entity.setValue(backdropPath, forKey: "backdropPath")
        entity.setValue(firstAirDate, forKey: "firstAirDate")
        entity.setValue(genreIDS, forKey: "genreIDs")
        entity.setValue(id, forKey: "id")
        entity.setValue(originalTitle, forKey: "originalTitle")
        entity.setValue(originalLanguage, forKey: "originalLanguage")
        entity.setValue(originalName, forKey: "originalName")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(releaseDate, forKey: "releaseDate")
        entity.setValue(popularity, forKey: "popularity")
        entity.setValue(posterPath, forKey: "posterPath")
        entity.setValue(voteAverage, forKey: "voteAverage")
        entity.setValue(voteCount, forKey: "voteCount")
        entity.setValue(title, forKey: "title")
        entity.setValue(video, forKey: "video")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
        
    }
    
    
    
}
