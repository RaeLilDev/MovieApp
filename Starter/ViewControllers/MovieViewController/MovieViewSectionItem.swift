//
//  MovieViewSectionItem.swift
//  Starter
//
//  Created by Ye linn htet on 5/26/22.
//

import Foundation
import RxDataSources

enum SectionItem {
    case upcomingMoviesSection(items: [MovieResult])
    case popularMoviesSection(items: [MovieResult])
    case popularSeriesSection(items: [MovieResult])
    case movieShowTimeSection
//    case movieGenreSection(items: [MovieGenre])
    case movieGenreSection(items: [GenreVO], movies: [MovieResult])
    case showcaseMoviesSection(items: [MovieResult])
    case bestActorSection(items: [ActorInfoResponse])
}

enum HomeMovieSectionModel: SectionModelType {
    
    init(original: HomeMovieSectionModel, items: [SectionItem]) {
        switch original {
        case .movieResult(let results):
            self = .movieResult(items: results)
            
        case .actorResult(let results):
            self = .actorResult(items: results)
            
            
        }
    }
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .movieResult(let items):
            return items
            
        case .actorResult(let items):
            return items
            
            
        }
    }
    
    case movieResult(items: [SectionItem])
    case actorResult(items: [SectionItem])
}
