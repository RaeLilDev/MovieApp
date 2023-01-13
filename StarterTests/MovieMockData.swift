//
//  MovieMockData.swift
//  StarterTests
//
//  Created by Ye linn htet on 6/15/22.
//

import Foundation

public final class MovieMockData {
    
    class SearchMovieResult {
        
        public static let searchResultJSONUrl: URL = Bundle(for: MovieMockData.self).url(forResource: "search_movie_result", withExtension: "json")!
        
        
        public static let invalidAPIKeyResponseURL: URL = Bundle(for: MovieMockData.self).url(forResource: "invalid_api_key_response", withExtension: "json")!
        
    }
    
    class MovieList {
        
        public static let topRatedMovieJSONUrl: URL = Bundle(for: MovieMockData.self).url(forResource: "top_rated_movie_result", withExtension: "json")!
        
        public static let genreJSONUrl: URL = Bundle(for: MovieMockData.self).url(forResource: "genre_result", withExtension: "json")!
        
    }
    
    
    class ActorList {
        
        public static let popularPeopleJSONURL: URL = Bundle(for: MovieMockData.self).url(forResource: "actor_result", withExtension: "json")!
        
    }
    
    static let corruptResponseURL: URL = Bundle(for: MovieMockData.self).url(forResource: "corrupt_response", withExtension: "html")!
}
