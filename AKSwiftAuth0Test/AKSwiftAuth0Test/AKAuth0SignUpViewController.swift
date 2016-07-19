//
//  AKAuth0SignUpViewController.swift
//  AKSwiftAuth0Test
//
//  Created by Iuliia Zhelem on 07.07.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

import UIKit
import Lock

let kAuth0ConnectionType = "Username-Password-Authentication"

class AKAuth0SignUpViewController: UIViewController {
    
    var lock: A0Lock!
    var delegate: A0LockEventDelegate!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func clickSignUpButton(sender: AnyObject) {
        if (self.emailTextField.text?.characters.count < 1) {
            self.showMessage("You need to eneter email")
            return;
        }
        if (self.usernameTextField.text?.characters.count < 1) {
            self.showMessage("You need to eneter username")
            return;
        }
        if (self.passwordTextField.text?.characters.count < 1) {
            self.showMessage("You need to eneter password")
            return;
        }
        
        let success = { (profile: A0UserProfile?, token: A0Token?) in
            print("Success: \(profile!.name)")
            self.delegate.userAuthenticatedWithToken(token!, profile: profile!)

        }
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
        }
        
        let client = A0Lock.sharedLock().apiClient()
        let params = A0AuthParameters.newDefaultParams()
        params[A0ParameterConnection] = kAuth0ConnectionType // Or your configured DB connection
        client.signUpWithEmail(self.emailTextField.text!, username: self.usernameTextField.text!, password: self.passwordTextField.text!, loginOnSuccess: true, parameters: params, success: success, failure: failure)

    }
    
    @IBAction func clickCloseButton(sender: AnyObject) {
        self.delegate.dismissLock();
    }
    
    @IBAction func clickBackButton(sender: AnyObject) {
        self.delegate.backToLock();
    }
    
    func showMessage(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
