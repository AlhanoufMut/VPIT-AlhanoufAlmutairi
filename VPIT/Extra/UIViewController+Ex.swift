//
//  UIViewController+Ex.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 07/12/1442 AH.
//

import Foundation
import UIKit

var aView : UIView?
extension UIViewController {
    
    //MARK: - Show alert function
    func showAlert(title: String, message: String, actionStr: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionStr, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Functions to move view above keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.color = mainColor
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: {_ in self.removeSpinner()})
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
    
}
