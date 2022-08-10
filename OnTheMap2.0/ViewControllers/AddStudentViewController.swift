//
//  AddStudentViewController.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/3/22.
//

import Foundation
import UIKit
import MapKit

class AddStudentViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var addStudentMapView: MKMapView!
    @IBOutlet weak var enterALinkToShare: UITextField!

    var objectId: String?
    var studentInformation: TheStudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterALinkToShare.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let studentLocation = studentInformation {
            let studentLocation = Location(
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? ""
            )
            showTheLocations(location: studentLocation)
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        studentInformation?.mediaURL = enterALinkToShare.text
        if let studentLocation = studentInformation {
            if APIClient.Auth.objectId == "" {
                APIClient.addStudentLocation(information: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showError(message: error?.localizedDescription ?? "", title: "Error")
                        }
                    }
                }
            }
        }
    }
    
     func showTheLocations(location: Location) {
        addStudentMapView.removeAnnotations(addStudentMapView.annotations)
        if let coordinate = extractTheCoordinates(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            addStudentMapView.addAnnotation(annotation)
            addStudentMapView.showAnnotations(addStudentMapView.annotations, animated: true)
        }
    }
    
     func extractTheCoordinates(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterALinkToShare.resignFirstResponder()
        return true
    }
}
