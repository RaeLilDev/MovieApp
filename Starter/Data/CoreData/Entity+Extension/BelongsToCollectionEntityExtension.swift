//
//  BelongsToCollectionEntityExtension.swift
//  Starter
//
//  Created by Ye Lynn Htet on 01/04/2022.
//

import Foundation

extension BelongsToCollectionEntity {
    
    static func toBelongsToCollection(entity: BelongsToCollectionEntity?) -> BelongsToCollection? {
        if let entity = entity {
            return BelongsToCollection(id: Int(entity.id), name: entity.name, posterPath: entity.posterPath, backdropPath: entity.backdropPath)
        } else {
            return nil
        }
    }
}
