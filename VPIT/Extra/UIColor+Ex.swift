//
//  UIColor+Ex.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 05/12/1442 AH.
//

import UIKit
extension UIColor {
    // Making the use of rgb colors more easier with this function
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

let mainColor = UIColor(rgb: 0x6fb7ce)


