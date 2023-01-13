//
//  GenreEntityExtension.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/03/2022.
//

import Foundation

extension GenreEntity {
    static func toMovieGenre(entity: GenreEntity) -> MovieGenre {
        MovieGenre(id: Int(entity.id ?? "0") ?? 0, name: entity.name ?? "")
    }
}
