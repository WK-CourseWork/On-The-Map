//
//  UITextFieldExtension.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/8/22.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var placeHolderColer: UIColor? {
        get {
            return self.placeHolderColer
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
