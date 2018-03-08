//
//  ViewController.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 08/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import GEOSwift
import MapKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    private var map = Map.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.addOverlays(map.overlays)
    }

    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        guard let country = map.getCountry(from: coordinate) else {
            return
        }

        let visitedCountry = map.getVisitedCountry(country: country)
        if visitedCountry.visited {
            mapView.removeOverlays(country.overlays)
        } else {
            mapView.addOverlays(country.overlays)
        }

        visitedCountry.visited = !visitedCountry.visited
        CoreDataStorage.shared.saveContext()
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let fill = UIColor.blue
        let alpha: CGFloat = 0.5

        if let polygon = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygon)
            renderer.fillColor = fill
            renderer.alpha = alpha
            return renderer
        }

        return MKOverlayRenderer(overlay: overlay)
    }
}
