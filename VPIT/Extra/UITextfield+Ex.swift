//
//  UITextfield+Ex.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 07/12/1442 AH.
//

import Foundation
import UIKit

extension UITextField {
    // Setup the appearance of the textfield
    func setupUI(){
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
    }
}
