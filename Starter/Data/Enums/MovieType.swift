//
//  MovieType.swift
//  Starter
//
//  Created by Ye Lynn Htet on 10/02/2022.
//

import Foundation

enum MovieType: Int {
    case MOVIE_SLIDER = 0
    case MOVIE_POPULAR = 1
    case SERIES_POPULAR = 2
    case MOVIE_SHOWTIME = 3
    case MOVIE_GENRE = 4
    case MOVIE_SHOWCASE = 5
    case MOVIE_BEST_ACTOR = 6
}

enum MovieSerieGroupType: String, CaseIterable {
    case upcomingMovies = "Upcoming Movies"
    case popularMovies = "Popular Movies"
    case topRatedMovies = "Top Rated Movies"
    case popularSeries = "Popular Series"
    case upcomingSeries = "Upcoming Series"
    case actorCredits = "Actor Credits"
}

