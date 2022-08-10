//
//  LoginViewController.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/3/22.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var acitivityCircle: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideActivityCircle(acitivityCircle)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if email != "" && password != ""{
            showActivityCircle(acitivityCircle)
            APIClient.login(username: email, password: password, completion: handleTheLoginResponse(success:error:))
        } else {
            showError(message: "Please make sure you entered your username and password", title: "Input Error")
        }
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        UIApplication.shared.open(APIClient.APIEndpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func handleTheLoginResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            self.hideActivityCircle(self.acitivityCircle)
            if let error = error {
                DispatchQueue.main.async {
                    self.showError(message: error.localizedDescription, title: "Login Error")
                }
                return
            }
            if success {
                self.performSegue(withIdentifier: "Login", sender: nil)
            } else {
                self.showError(message: "Please enter a valid username and password.", title: "Login Error")
            }
        }
    }
}
