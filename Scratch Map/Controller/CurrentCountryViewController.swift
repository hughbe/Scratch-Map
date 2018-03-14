//
//  CurrentCountryViewController.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 09/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import ActionSheetPicker_3_0
import MapKit
import UIKit

public class CurrentCountryViewController : UIViewController {
    @IBOutlet weak var visitedButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    public var country: VisitedCountry!

    public override func viewDidLoad() {
        super.viewDidLoad()
        displayCountry(setMapRegion: true)
    }

    private func displayCountry(setMapRegion: Bool) {
        navigationItem.title = country.id

        if setMapRegion {
            let overlay = country.country!.fullOverlay
            let region = MKCoordinateRegionForMapRect(overlay.boundingMapRect)
            mapView.setRegion(region, animated: false)
        }

        visitedButton.setTitle(country.visitedString ?? NSLocalizedString("When Did You Visit?", comment: "When Did You Visit?"), for: .normal)
    }

    @IBAction func changeVisited(_ sender: UIButton) {
        ActionSheetDatePicker.show(withTitle: NSLocalizedString("Visit Date", comment: "Visit Date"), datePickerMode: .date, selectedDate: country.date ?? Date(), doneBlock: { _, selectedDate, _ in
            self.country.date = selectedDate as! NSDate as Date
            self.displayCountry(setMapRegion: false)
            Store.shared.saveContext()
        }, cancel: nil, origin: sender)
    }
}

extension CurrentCountryViewController : MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapView.zoomLevel > 5 {
            mapView.zoomLevel = 5
        }
    }
}
