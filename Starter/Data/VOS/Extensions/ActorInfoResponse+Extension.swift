//
//  ActorInfoResponse+Extension.swift
//  Starter
//
//  Created by Ye linn htet on 5/26/22.
//

import Foundation
import RxCoreData
import CoreData

extension ActorInfoResponse: Persistable {
    
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "ActorEntity"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    var identity: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as? Int
        adult = entity.value(forKey: "adult") as? Bool
        gender = entity.value(forKey: "gender") as? Int
        knownFor = [MovieResult]()
        knownForDepartment = entity.value(forKey: "knownForDepartment") as? String
        name = entity.value(forKey: "name") as? String
        popularity = entity.value(forKey: "popularity") as? Double
        profilePath = entity.value(forKey: "profilePath") as? String
    }
    
    func update(_ entity: T) {
        
        entity.setValue(id, forKey: "id")
        entity.setValue(adult, forKey: "adult")
        entity.setValue(gender, forKey: "gender")
        entity.setValue(knownForDepartment, forKey: "knownForDepartment")
        entity.setValue(name, forKey: "name")
        entity.setValue(popularity, forKey: "popularity")
        entity.setValue(profilePath, forKey: "profilePath")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
        
    }
}
