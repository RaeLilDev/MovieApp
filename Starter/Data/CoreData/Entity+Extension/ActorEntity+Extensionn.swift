//
//  ActorEntity+Extensionn.swift
//  Starter
//
//  Created by Ye Lynn Htet on 04/04/2022.
//

import Foundation


extension ActorEntity {
    static func toMovieCast(entity: ActorEntity) -> MovieCast {
        
        return MovieCast(adult: entity.adult, gender: Int(entity.gender), id: Int(entity.id), knownForDepartment: entity.knownForDepartment, name: entity.name, originalName: nil, popularity: entity.popularity, profilePath: entity.profilePath, castID: nil, character: nil, creditID: nil, order: nil, department: entity.knownForDepartment, job: nil, backdropPath: nil, genreIDS: nil, originalLanguage: nil, originalTitle: nil, overview: nil, posterPath: entity.profilePath, releaseDate: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil, mediaType: nil)
    }
    
    static func toActorInfoResponse(entity: ActorEntity) -> ActorInfoResponse {
        return ActorInfoResponse(
            adult: entity.adult,
            gender: Int(entity.gender),
            id: Int(entity.id),
            knownFor: [MovieResult](),
            knownForDepartment: entity.knownForDepartment,
            name: entity.name,
            popularity: entity.popularity,
            profilePath: entity.profilePath)
    }
    
    static func toActorDetailResponse(entity: ActorEntity) -> ActorDetailResponse {
        return ActorDetailResponse(adult: entity.adult,
                                   alsoKnownAs: entity.alsoKnownAs?.components(separatedBy: ","),
                                   biography: entity.biography,
                                   birthday: entity.birthday,
                                   deathday: entity.deathday,
                                   gender: Int(entity.gender),
                                   homepage: entity.homePage,
                                   id: Int(entity.id),
                                   imdbID: entity.imdbID,
                                   knownForDepartment: entity.knownForDepartment,
                                   name: entity.name,
                                   placeOfBirth: entity.placeOfBirth,
                                   popularity: entity.popularity,
                                   profilePath: entity.profilePath)
    }
}
