//
//  MapViewController.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 08/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import GEOSwift
import MapKit
import UIKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentCountryView: CurrentCountryView!

    private var map = Store.shared.currentMap
    private var currentCountry: VisitedCountry? {
        didSet {
            displayCurrentCountry()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let overlays = CountryOverlays.shared.getOverlays(visited: map.visitedCountries)
        mapView.addOverlays(overlays)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        displayCurrentCountry()
    }

    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        guard let country = CountryOverlays.shared.getCountry(from: coordinate) else {
            currentCountry = nil
            return
        }

        let visitedCountry = map.getVisitedCountry(country: country)
        if visitedCountry.visited {
            // The first tap on a visited country brings up the info pane.
            // The second tap on a visited country clears it's visited status.
            if visitedCountry == currentCountry {
                visitedCountry.visited = false
                mapView.removeOverlays(country.overlays)
                currentCountry = nil
            } else {
                currentCountry = visitedCountry
            }
        } else {
            visitedCountry.visited = true

            mapView.addOverlays(country.overlays)
            currentCountry = visitedCountry
        }

        Store.shared.saveContext()
    }

    private func displayCurrentCountry() {
        guard let currentCountry = currentCountry else {
            currentCountryView.setHidden(true)
            return
        }

        currentCountryView.nameButton.setTitle(currentCountry.id, for: .normal)
        currentCountryView.setDateString(currentCountry.visitedString)
        currentCountryView.setHidden(false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController, let currentCountryViewController = navigationController.viewControllers.first as? CurrentCountryViewController {
            currentCountryViewController.country = currentCountry!
        }
    }

    @IBAction func unwindToMapViewController(segue:UIStoryboardSegue) { }
}

extension MapViewController : MKMapViewDelegate {
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
