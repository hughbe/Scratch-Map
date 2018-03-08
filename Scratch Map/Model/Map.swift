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

public class Map {
    public static let shared = Map()
    private init() {}

    private lazy var features: Features = {
        let geoJSONURL = Bundle.main.url(forResource: "countries", withExtension: "geo.json")!
        let features = try! Features.fromGeoJSON(geoJSONURL)
        return features!
    }()

    public lazy var visitedCountries: [VisitedCountry] = {
        do {
            return try CoreDataStorage.shared.context.fetch(VisitedCountry.fetchRequest())
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }()

    private lazy var countries = features.map(Country.init)

    public func getCountry(from coordinate: CLLocationCoordinate2D) -> Country? {
        return countries.first { $0.contains(coordinate: coordinate) }
    }

    public func getVisitedCountry(country: Country) -> VisitedCountry {
        if let visitedCountry = visitedCountries.first(where: { $0.id == country.name }) {
            return visitedCountry
        }

        let visitedCountry = VisitedCountry(context: CoreDataStorage.shared.context)
        visitedCountry.id = country.name

        visitedCountries.append(visitedCountry)
        return visitedCountry
    }

    public var overlays: [MKOverlay] {
        let visited = visitedCountries.filter { $0.visited }
        let overlays = visited.flatMap { country in countries.first { $0.name == country.id }?.overlays}
        return overlays.flatMap { $0 }
    }
}
