//
//  AKAuth0SignUpViewController.swift
//  AKSwiftAuth0Test
//

import UIKit
import Lock

let kAuth0ConnectionType = "Username-Password-Authentication"

class AKAuth0SignUpViewController: UIViewController {
    
    var lock: A0Lock!
    var delegate: A0LockEventDelegate!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func clickSignUpButton(sender: AnyObject) {
        if (self.emailTextField.text?.characters.count < 1) {
            self.showMessage("Please eneter an email")
            return
        }
        if (self.passwordTextField.text?.characters.count < 1) {
            self.showMessage("Pelase eneter a password")
            return
        }
        
        let success = { (profile: A0UserProfile?, token: A0Token?) in
            // Calls `onAuthenticationBlock` of `A0LockViewController` with token and profile
            if let actualToken = token {
                if let actualProfile = profile {
                    self.delegate.userAuthenticatedWithToken(actualToken, profile: actualProfile)
                } else {
                    self.delegate.userAuthenticatedWithToken(actualToken, profile: A0UserProfile())
                }
            } else {
                self.delegate.userAuthenticatedWithToken(A0Token(), profile: A0UserProfile())
            }
        }
        
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
        }
        
        let client = self.lock.apiClient()
        let params = A0AuthParameters.newDefaultParams()
        params[A0ParameterConnection] = kAuth0ConnectionType // Or your configured DB connection
        
        client.signUpWithEmail(self.emailTextField.text!, password: self.passwordTextField.text!, loginOnSuccess: true, parameters: params, success: success, failure: failure)
    }
    
    @IBAction func clickCloseButton(sender: AnyObject) {
        // Dismiss A0LockViewController, like tapping the close button if `closable` is true
        self.delegate.dismissLock()
    }
    
    @IBAction func clickBackButton(sender: AnyObject) {
        // Dismiss all custom UIViewControllers pushed inside Lock and shows it's main UI.
        self.delegate.backToLock()
    }
    
    func showMessage(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
