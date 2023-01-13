// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailResponse = try? newJSONDecoder().decode(MovieDetailResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - MovieDetailResponse
struct MovieDetailResponse: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [MovieGenre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalName, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate, firstAirDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.budget = Int64(budget ?? 0)
        entity.revenue = Int64(revenue ?? 0)
        entity.runTime = Int64(runtime ?? 0)
        entity.voteCount = Int64(voteCount ?? 0)
        entity.popularity = popularity ?? 0
        entity.voteAverage = voteAverage ?? 0
        entity.backdropPath = backdropPath
        entity.firstAirDate = firstAirDate ?? ""
        entity.homePage = homepage
        entity.imdbID = imdbID
        entity.lastAirDate = ""
        self.genres?.forEach {
            entity.addToGenres($0.toGenreEntity(context: context))
        }
        entity.originalLanguage = originalLanguage
        entity.originalName = originalName
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? ""
        entity.status = status
        entity.tagline = tagline
        entity.title = title
        entity.adult = adult ?? false
        entity.video = video ?? false
        
        self.productionCompanies?.forEach {
            entity.addToProductionCompanies($0.toProductionCompanyEntity(context: context))
        }
        
        self.productionCountries?.forEach {
            entity.addToProductionCountries($0.toProductionCountryEntity(context: context))
        }
        
        
        self.spokenLanguages?.forEach {
            entity.addToSpokenLanguages($0.toSpokenLanguageEntity(context: context))
        }
        
        return entity
    }
}


// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?
    //let backdropPath: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}


// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    func toProductionCompanyEntity(context: NSManagedObjectContext) -> ProductionCompanyEntity {
        let entity = ProductionCompanyEntity(context: context)
        entity.id = Int32(self.id!)
        entity.logoPath = self.logoPath
        entity.name = self.name
        entity.originCountry = self.originCountry
        return entity
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
    func toProductionCountryEntity(context: NSManagedObjectContext) -> ProductionCountryEntity {
        let entity = ProductionCountryEntity(context: context)
        entity.iso3166_1 = self.iso3166_1
        entity.name = self.name
        return entity
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
    
    func toSpokenLanguageEntity(context: NSManagedObjectContext) -> SpokenLanguageEntity {
        let entity = SpokenLanguageEntity(context: context)
        entity.englishName = self.englishName
        entity.iso639_1 = self.iso639_1
        entity.name = self.name
        return entity
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
