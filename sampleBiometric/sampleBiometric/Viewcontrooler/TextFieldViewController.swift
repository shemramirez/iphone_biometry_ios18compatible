//
//  TextFieldViewController.swift
//  sampleBiometric
//
//  Created by ramirez on 2024/08/07.
//

import Foundation
import UIKit

struct AssociatedKeys {
    static var activeTextField: UInt8 = 0
    static var keyboardHeight: UInt8 = 1
}

class TextFieldViewController: UIViewController {

}


extension TextFieldViewController: UITextFieldDelegate {
    
    private(set) var activeTextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activeTextField) as? UITextField
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.activeTextField, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    private(set) var keyboardHeight: CGFloat? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.keyboardHeight) as? CGFloat else {
                return 0.0
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.keyboardHeight, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func disableUnoccludedTextField() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func enableUnoccludedTextField() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.keyboardHeight = 0.0
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.keyboardHeight = keyboardFrame.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.activeTextField = nil
    }
    
}
