//
//  InputStudentLocationDataViewController.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/4/22.
//

import Foundation
import UIKit
import MapKit

class InputStudentLocationDataViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var inputAcitivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var enterLocationTextField: UITextField!

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }

    var objectId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        enterLocationTextField.delegate = self
        hideActivityCircle(inputAcitivityIndicator)
    }

    @IBAction func findTheLocation(sender: UIButton) {
        let location = enterLocationTextField.text
        theGeocodePosition(newLocation: location ?? "")
    }

     func theGeocodePosition(newLocation: String) {
        showActivityCircle(inputAcitivityIndicator)
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showError(message: error.localizedDescription, title: "Location Not Found")
                print("Location not found.")
            } else {
                var location: CLLocation?

                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }

                if let location = location {
                    self.navigateToConfirm(location: location.coordinate)
                } else {
                    self.showError(message: "Please try again later.", title: "Error")
                    print("There was an error.")
                }
            }
            self.hideActivityCircle(self.inputAcitivityIndicator)
        }
    }

    func navigateToConfirm(location: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "addStudentViewController") as! AddStudentViewController
        controller.studentInformation = buildStudentInfo(location)
        self.navigationController?.pushViewController(controller, animated: true)
    }

     func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> TheStudentInformation {
        var studentInfo = [
            "uniqueKey": APIClient.Auth.key,
            "firstName": APIClient.Auth.firstName,
            "lastName": APIClient.Auth.lastName,
            "mapString": enterLocationTextField.text!,
            "mediaURL": "",
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
            ] as [String: AnyObject]

        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }
        return TheStudentInformation(studentInfo)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterLocationTextField.resignFirstResponder()
        return true
    }
}
