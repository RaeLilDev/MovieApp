// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcomingMovieList = try? newJSONDecoder().decode(UpcomingMovieList.self, from: jsonData)

import Foundation
import CoreData

// MARK: - UpcomingMovieList
struct MovieListResponse: Codable {
        
    let dates: Dates?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalMovieResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalMovieResults = "total_MovieResults"
    }
    
    init(dates: Dates?, page: Int?, results: [MovieResult]?, totalPages: Int?, totalMovieResults: Int?) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalMovieResults = totalMovieResults
    }

    
    
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - MovieResult
struct MovieResult: Codable, Hashable {
    
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, originalName, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, firstAirDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext, groupType: BelongsToTypeEntity) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genreIDS?.map { String($0) }.joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalName
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? firstAirDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.addToBelongsToType(groupType)
        return entity
    }
    
    static func dummy() -> MovieResult {
        return MovieResult(adult: nil, backdropPath: nil, genreIDS: nil, id: nil, originalLanguage: nil, originalTitle: nil, originalName: nil, overview: nil, popularity: nil, posterPath: nil, releaseDate: nil, firstAirDate: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil)
    }
    
}

struct MovieCreditByActorResponse: Codable {
    let cast, crew: [MovieResult]?
    let id: Int?
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case es = "es"
}
