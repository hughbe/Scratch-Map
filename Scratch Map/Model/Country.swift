//
//  Country.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 08/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import GEOSwift
import MapKit

public class Country: CustomDebugStringConvertible {
    private let feature: Feature
    public let name: String

    public init(feature: Feature) {
        self.feature = feature
        self.name = feature.properties!["name"]! as! String
    }

    public lazy var overlays: [MKOverlay] = {
        guard let geometry = feature.geometries?.first else {
            return []
        }

        if let polygon = geometry as? Polygon {
            return [polygon.mapShape() as! MKOverlay]
        } else if let multiPolygon = geometry as? MultiPolygon<Polygon> {
            let shapes = multiPolygon.mapShape() as! MKShapesCollection
            return shapes.shapes.map { $0 as! MKOverlay }
        }

        return []
    }()

    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let geometry = Waypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)!
        return feature.geometries![0].contains(geometry)
    }

    public var debugDescription: String {
        return name
    }
}
