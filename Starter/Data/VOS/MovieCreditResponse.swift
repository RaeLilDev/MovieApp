// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieCreditResponse = try? newJSONDecoder().decode(MovieCreditResponse.self, from: jsonData)

import Foundation
import UIKit

// MARK: - MovieCreditResponse
struct MovieCreditResponse: Codable {
    let id: Int?
    let cast, crew: [MovieCast]?
}

// MARK: - Cast
struct MovieCast: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: String?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department: String?
    let job: String?
    let backdropPath: String?
    let genreIDS: [Int]?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let mediaType: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
        
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case mediaType = "media_type"
    }
    
    
    func convertToActorInfoResponse() -> ActorInfoResponse {
        return ActorInfoResponse(adult: self.adult, gender: self.gender, id: self.id, knownFor: nil, knownForDepartment: self.knownForDepartment, name: self.name, popularity: self.popularity, profilePath: self.profilePath)
    }
    
    func convertToMovieResult() -> MovieResult {
        return MovieResult(adult: self.adult, backdropPath: self.backdropPath, genreIDS: self.genreIDS, id: self.id, originalLanguage: self.originalLanguage, originalTitle: self.originalTitle, originalName: self.originalName, overview: self.overview, popularity: self.popularity, posterPath: self.posterPath, releaseDate: self.releaseDate,firstAirDate: "", title: self.title, video: self.video, voteAverage: self.voteAverage, voteCount: self.voteCount)
    }
    
    
}

//enum Department: String, Codable {
//    case acting = "Acting"
//    case art = "Art"
//    case camera = "Camera"
//    case costumeMakeUp = "Costume & Make-Up"
//    case crew = "Crew"
//    case directing = "Directing"
//    case editing = "Editing"
//    case production = "Production"
//    case sound = "Sound"
//    case visualEffects = "Visual Effects"
//    case writing = "Writing"
//}


