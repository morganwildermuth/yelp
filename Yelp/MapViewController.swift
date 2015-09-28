//
//  MapViewController.swift
//  Yelp
//
//  Created by Morgan Wildermuth on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
    var businesses: [Business]?
    
    @IBAction func onBackTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(businesses!.first?.coordinate)")
        mapView.removeAnnotations(mapView.annotations)
        centerMapOnLocation(initialLocation)
        createAnnotiations()
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createAnnotiations(){
        for business in businesses! {
            var geocoder = CLGeocoder()
            var retrievedCoordinates: CLLocationCoordinate2D?
            
            geocoder.geocodeAddressString(business.address!, completionHandler: {(placemarks, error) -> Void in
                if (error != nil ){
                    print("\(error)")
                } else {
                    if let placemark = placemarks {
                        retrievedCoordinates = placemark.first!.location!.coordinate
                        business.coordinate = retrievedCoordinates!
                    }
                }
            })
            mapView.addAnnotation(business)
        }
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let pinView: MKPinAnnotationView = MKPinAnnotationView()
        pinView.annotation = annotation
        pinView.pinColor = MKPinAnnotationColor.Red
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        return pinView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
