// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetailResponse = try? newJSONDecoder().decode(ActorDetailResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - ActorDetailResponse
struct ActorDetailResponse: Codable {
    
    let adult: Bool?
    let alsoKnownAs: [String]?
    let biography, birthday: String?
    let deathday: String?
    let gender: Int?
    let homepage: String?
    let id: Int?
    let imdbID, knownForDepartment, name, placeOfBirth: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    @discardableResult
    func toActorEntity(context: NSManagedObjectContext) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.gender = Int32(gender!)
        entity.id = Int32(id!)
        entity.popularity = popularity ?? 0.0
        entity.alsoKnownAs = alsoKnownAs?.joined(separator: ",")
        entity.biography = biography
        entity.birthday = birthday
        entity.deathday = deathday
        entity.homePage = homepage
        entity.imdbID = imdbID
        entity.knownForDepartment = knownForDepartment
        entity.name = name
        entity.placeOfBirth = placeOfBirth
        entity.profilePath = profilePath
        entity.adult = adult ?? false
        entity.insertedAt = Date()
        return entity
        
    }
}

