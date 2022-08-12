//
//  UIViewControllerExtensions.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/4/22.
//

import Foundation
import UIKit

extension UIViewController {

    func showError(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }

    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showError(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

    func showActivityCircle(_ activityCircle: UIActivityIndicatorView) {
        activityCircle.isHidden = false
        activityCircle.startAnimating()
    }

    func hideActivityCircle(_ activityCircle: UIActivityIndicatorView) {
        activityCircle.isHidden = true
        activityCircle.stopAnimating()
    }
}
