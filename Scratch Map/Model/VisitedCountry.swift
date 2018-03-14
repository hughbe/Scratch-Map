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
        cachedCountry = country
    }

    public var country: Country? {
        if let country = cachedCountry as? Country {
            return country
        }

        let country = CountryOverlays.shared.getCountry(from: id!)
        cachedCountry = country
        return country
    }

    public var visitedString: String? {
        guard let date = date else {
            return nil
        }

        let dateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        return "\(NSLocalizedString("Visited On", comment: "Visited On")) \(dateString)"
    }
}
