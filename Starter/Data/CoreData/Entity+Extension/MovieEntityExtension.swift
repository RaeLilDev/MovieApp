//
//  MovieEntityExtension.swift
//  Starter
//
//  Created by Ye Lynn Htet on 31/03/2022.
//

import Foundation
import CoreData

extension MovieEntity {
    static func toMovieResult(entity: MovieEntity) -> MovieResult {
        
        return MovieResult(adult: entity.adult,
                backdropPath: entity.backdropPath,
                genreIDS: entity.genreIDs?.components(separatedBy: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces))},
                id: Int(entity.id),
                originalLanguage: entity.originalLanguage,
                originalTitle: entity.originalTitle,
                originalName: entity.originalName,
                overview: entity.overview,
                popularity: entity.popularity,
                posterPath: entity.posterPath,
                releaseDate: entity.releaseDate,
                firstAirDate: entity.releaseDate,
                title: entity.title,
                video: entity.video,
                voteAverage: entity.voteAverage,
                voteCount: Int(entity.voteCount))
    }
    
    
    
    static func toMovieDetailResponse(entity: MovieEntity) -> MovieDetailResponse {
        return MovieDetailResponse(adult: entity.adult,
                backdropPath: entity.backdropPath,
                belongsToCollection: BelongsToCollectionEntity.toBelongsToCollection(entity: entity.belongsToCollection),
                budget: Int(entity.budget),
                genres: (entity.genres as? Set<GenreEntity>)?.map { GenreEntity.toMovieGenre(entity: $0) },
                homepage: entity.homePage,
                id: Int(entity.id),
                imdbID: entity.imdbID,
                originalLanguage: entity.originalLanguage,
                originalName: entity.originalName,
                originalTitle: entity.originalTitle,
                overview: entity.overview,
                popularity: entity.popularity,
                posterPath: entity.posterPath,
                productionCompanies: (entity.productionCompanies as? Set<ProductionCompanyEntity>)?.map { ProductionCompanyEntity.toProductionCompany(entity: $0) },
                productionCountries: (entity.productionCountries as? Set<ProductionCountryEntity>)?.map { ProductionCountryEntity.toProductionCountry(entity: $0) },
                releaseDate: entity.releaseDate,
                firstAirDate: entity.firstAirDate,
                revenue: Int(entity.revenue),
                runtime: Int(entity.runTime),
                spokenLanguages: (entity.spokenLanguages as? Set<SpokenLanguageEntity>)?.map { SpokenLanguageEntity.toSpokenLanguage(entity: $0) },
                status: entity.status,
                tagline: entity.tagline,
                title: entity.title,
                video: entity.video,
                voteAverage: entity.voteAverage,
                voteCount: Int(entity.voteCount))

    }
    
}


