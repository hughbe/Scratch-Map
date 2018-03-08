//
//  VisitedCountry.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 08/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import CoreData

public extension VisitedCountry {
    public convenience init(country: Country) {
        self.init(entity: VisitedCountry.entity(), insertInto: nil)
        self.id = country.name
    }
}
