//
//  MapViewController.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/2/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var mapViewReloadButton: UIBarButtonItem!
    @IBOutlet weak var mapViewAddButton: UIBarButtonItem!

    var locations = [TheStudentInformation]()
    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        theMapView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTheStudentLocation()
    }

    func getTheStudentLocation() {
        APIClient.getStudentLocation { locations, error in
            if error == nil {
                self.theMapView.removeAnnotations(self.annotations)
                self.annotations.removeAll()
                self.locations = locations ?? []
                for dictionary in locations ?? [] {
                    let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                    let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    self.annotations.append(annotation)
                }
                DispatchQueue.main.async {
                    self.theMapView.addAnnotations(self.annotations)
                }
            } else {
                DispatchQueue.main.async {
                    self.showError(message: "Can not download data", title: "Error")
                }
            }
        }
    }

    @IBAction func reloadButtonPressed(_ sender: Any) {
        getTheStudentLocation()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openLink(toOpen ?? "")
            }
        }
    }
}
