//
//  GenreVO.swift
//  Starter
//
//  Created by Ye Lynn Htet on 08/02/2022.
//

import Foundation
import CoreData

class GenreVO {
    var id: Int = 0
    var name: String = "ACTION"
    var isSelected: Bool = false
    
    init(id: Int = 0, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    

}
