//
//  UIButton+Ex.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 05/12/1442 AH.
//

import UIKit

extension UIButton {
    // Setup the appearance of the button
    func setupUI(){
        setTitleColor(.white, for: .normal)
        tintColor = mainColor
        backgroundColor = UIColor(rgb: 0x6fb7ce)
        layer.cornerRadius = 10
        clipsToBounds = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
}

