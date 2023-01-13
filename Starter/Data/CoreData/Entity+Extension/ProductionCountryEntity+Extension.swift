//
//  ProductionCountryEntity+Extension.swift
//  Starter
//
//  Created by Ye Lynn Htet on 05/04/2022.
//

import Foundation

extension ProductionCountryEntity {
    
    static func toProductionCountry(entity: ProductionCountryEntity?) -> ProductionCountry {
        ProductionCountry(iso3166_1: entity?.iso3166_1, name: entity?.name)
    }
}
