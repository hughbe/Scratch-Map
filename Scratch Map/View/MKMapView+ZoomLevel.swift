//
//  MKMapView+ZoomLevel.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 09/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import MapKit

extension MKMapView {
    @IBInspectable
    public var zoomLevel: NSInteger {
        get {
            return NSInteger(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1);
        }
        set {
            setCenterCoordinate(coordinate:self.centerCoordinate, zoomLevel: newValue, animated: false)
        }
    }

    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool){
        let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegionMake(coordinate, span), animated: animated)
    }
}
