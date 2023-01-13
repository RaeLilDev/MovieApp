//
//  ProductionCompanyEntity+Extension.swift
//  Starter
//
//  Created by Ye Lynn Htet on 05/04/2022.
//

import Foundation

extension ProductionCompanyEntity {
    static func toProductionCompany(entity: ProductionCompanyEntity?) -> ProductionCompany {
        ProductionCompany(
            id: Int(entity?.id ?? 0),
            logoPath: entity?.logoPath,
            name: entity?.name,
            originCountry: entity?.originCountry)
    }
}
