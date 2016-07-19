//
//  ViewController.m
//  AKAuth0TestApp
//
//  Created by Iuliia Zhelem on 27.06.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

#import "ViewController.h"
#import <Lock/Lock.h>
#import "AKAuth0SignUpViewController.h"

@interface ViewController ()
- (IBAction)clickLockVCButton:(id)sender;
- (IBAction)clickLockSignUpVCButton:(id)sender;
- (IBAction)clickCustomSignUpButton:(id)sender;

@end

@implementation ViewController

- (IBAction)clickLockVCButton:(id)sender
{
    A0Lock *lock = [A0Lock sharedLock];
    A0LockViewController *controller = [lock newLockViewController];
    controller.closable = YES;
    controller.loginAfterSignUp = YES;//NO
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        // Do something with token & profile. e.g.: save them.
        // If loginAfterSignUp - NO, profile and token will be nil
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    controller.onUserDismissBlock = ^(){
        NSLog(@"User closed Lock UI");
    };
    [self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)clickLockSignUpVCButton:(id)sender
{
    A0Lock *lock = [A0Lock sharedLock];
    A0LockSignUpViewController *controller = [lock newSignUpViewController];
    controller.loginAfterSignUp = NO;
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)clickCustomSignUpButton:(id)sender {
    A0Lock *lock = [A0Lock sharedLock];
    
    A0LockViewController *controller = [lock newLockViewController];
    controller.closable = YES;
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        // Do something with token & profile. e.g.: save them.
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    //Create custom SignUp view controller
    controller.customSignUp = ^ UIViewController *(A0Lock *lock, A0LockEventDelegate *delegate) {
        
        AKAuth0SignUpViewController *signUpVC = (AKAuth0SignUpViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AKAuth0SignUpViewController"];
        signUpVC.lock = lock;
        signUpVC.delegate = delegate;
        
        return signUpVC;
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:navController animated:YES completion:nil];
}
@end
