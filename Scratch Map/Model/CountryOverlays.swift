//
//  CountryOverlays.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 08/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import GEOSwift
import MapKit

public class CountryOverlays {
    public static let shared = CountryOverlays()
    private init() {}

    public func getCountry(from name: String) -> Country? {
        return countries[name]
    }

    public func getCountry(from coordinate: CLLocationCoordinate2D) -> Country? {
        return countries.values.first { $0.contains(coordinate: coordinate) }
    }

    private lazy var countries: [String: Country] = {
        var dictionary = Dictionary<String, Country>(minimumCapacity: features.count)
        for feature in features {
            let country = Country.init(feature: feature)
            dictionary[country.name] = country
        }
        return dictionary
    }()

    private lazy var features: Features = {
        let geoJSONURL = Bundle.main.url(forResource: "countries", withExtension: "geo.json")!
        let features = try! Features.fromGeoJSON(geoJSONURL)
        return features!
    }()

    public func getOverlays(visited: [VisitedCountry]) -> [MKOverlay] {
        let overlays = visited.flatMap { country in countries[country.id!]!.overlays}
        return overlays.flatMap { $0 }
    }
}
