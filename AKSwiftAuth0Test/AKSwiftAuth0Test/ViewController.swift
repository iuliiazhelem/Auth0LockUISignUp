//
//  ViewController.swift
//  AKSwiftAuth0Test
//

import UIKit
import Lock

class ViewController: UIViewController {

    // Open Lock UI with Lock SignUp View
    @IBAction func clickLockVCButton(sender: AnyObject) {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.closable = true
        controller.loginAfterSignUp = true//false
        controller.onAuthenticationBlock = { (profile, token) in
            // Do something with token & profile. e.g.: save them.
            // If loginAfterSignUp - NO, profile and token will be nil
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        controller.onUserDismissBlock = { () in
            print("User closed Lock UI")
        }
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // Open Lock UI with Custom SignUp View
    @IBAction func clickCustomSighUpButton(sender: AnyObject) {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.onAuthenticationBlock = { (profile, token) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //Create custom SignUp view controller
        controller.customSignUp = { (lock:A0Lock, delegate:A0LockEventDelegate) in
            let signUpVC:AKAuth0SignUpViewController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("AKAuth0SignUpViewController") as! AKAuth0SignUpViewController
            signUpVC.lock = lock
            signUpVC.delegate = delegate

            return signUpVC
        }
        
        let navController:UINavigationController = UINavigationController.init(rootViewController: controller)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
            navController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        }
        
        self.presentViewController(navController, animated: true, completion: nil)
    }
}

