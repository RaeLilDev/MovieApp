//
//  SpokenLanguageEntity+Extension.swift
//  Starter
//
//  Created by Ye Lynn Htet on 05/04/2022.
//

import Foundation

extension SpokenLanguageEntity {
    
    static func toSpokenLanguage(entity: SpokenLanguageEntity?) -> SpokenLanguage {
        SpokenLanguage(
            englishName: entity?.englishName,
            iso639_1: entity?.iso639_1,
            name: entity?.name)
    }
}
