//
//  ActorListResponse.swift
//  Starter
//
//  Created by Ye Lynn Htet on 17/03/2022.
//

import Foundation
import CoreData

public struct ActorListResponse: Codable {
    let dates: Dates?
    let page: Int?
    let results: [ActorInfoResponse]?
    let totalPages, totalMovieResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalMovieResults = "total_MovieResults"
    }
}

struct ActorInfoResponse: Codable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownFor: [MovieResult]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name
        case popularity
        case profilePath = "profile_path"
    }
    
    
    
    @discardableResult
    func toActorEntity(context: NSManagedObjectContext, contentTypeRepo: ContentTypeRepository) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.gender = Int32(gender!)
        entity.id = Int32(id!)
        entity.popularity = popularity!
        entity.alsoKnownAs = nil
        entity.biography = nil
        entity.birthday = nil
        entity.deathday = nil
        entity.homePage = nil
        entity.imdbID = nil
        entity.knownForDepartment = knownForDepartment
        entity.name = name
        entity.placeOfBirth = nil
        entity.profilePath = profilePath
        entity.adult = adult!
        entity.insertedAt = Date()
        return entity
    }
}
