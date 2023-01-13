//
//  MovieItemDelegate.swift
//  Starter
//
//  Created by Ye Lynn Htet on 10/02/2022.
//

import Foundation

protocol MovieItemDelegate {
    
    func onTapMovie(id: Int, type: String)
    
    func onTapActor(id: Int)
    
    func onTapMoreActors()
    
    func onTapMoreShowCases()
}
