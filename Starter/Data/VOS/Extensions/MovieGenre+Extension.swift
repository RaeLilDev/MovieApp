//
//  MovieGenre+Extension.swift
//  Starter
//
//  Created by Ye linn htet on 5/26/22.
//

import Foundation
import RxCoreData
import RxDataSources
import CoreData

extension MovieGenre: Persistable {
    
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "GenreEntity"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    var identity: String {
        return "id"
    }
    
    init(entity: T) {
        id = Int(((entity.value(forKey: "id") as? String)!))!
        name = (entity.value(forKey: "name") as? String) ?? ""
    }
    
    func update(_ entity: T) {
        
        entity.setValue(id, forKey: "id")
        entity.setValue(name, forKey: "name")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
        
    }
}
