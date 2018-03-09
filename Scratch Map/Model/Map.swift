//
//  Map.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 08/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import Foundation
import GEOSwift
import MapKit

public extension Map {
    public func getVisitedCountry(country: Country) -> VisitedCountry {
        if let visitedCountry = countries?.first(where: { ($0 as! VisitedCountry).id == country.name }) {
            return visitedCountry as! VisitedCountry
        }

        let visitedCountry = VisitedCountry(context: Store.shared.context)
        visitedCountry.id = country.name

        addToCountries(visitedCountry)
        return visitedCountry
    }

    public var visitedCountries: [VisitedCountry] {
        return countries?.map({ $0 as! VisitedCountry }).filter({ $0.visited }) ?? []
    }
}
