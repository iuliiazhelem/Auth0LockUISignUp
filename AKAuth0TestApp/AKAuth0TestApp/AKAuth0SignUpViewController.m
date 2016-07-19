//
//  AKAuth0SignUpViewController.m
//  AKAuth0TestApp
//
//  Created by Iuliia Zhelem on 27.06.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

#import "AKAuth0SignUpViewController.h"
#import <Lock/Lock.h>

static NSString *kAuth0ConnectionType = @"Username-Password-Authentication";

@interface AKAuth0SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)clickSignUpButton:(id)sender;
- (IBAction)clickCloseButton:(id)sender;
- (IBAction)clickBackButton:(id)sender;

@end

@implementation AKAuth0SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickSignUpButton:(id)sender {
    
    if (self.emailTextField.text.length < 1) {
        [self showMessage:@"You need to eneter email"];
        return;
    }
    if (self.usernameTextField.text.length < 1) {
        [self showMessage:@"You need to eneter username"];
        return;
    }
    if (self.passwordTextField.text.length < 1) {
        [self showMessage:@"You need to eneter password"];
        return;
    }
    
    A0APIClient *client = [self.lock apiClient];
    A0APIClientSignUpSuccess success = ^(A0UserProfile *profile, A0Token *token) {
        NSLog(@"Success: %@", profile.name);
        [self.delegate userAuthenticatedWithToken:token profile:profile];
    };
    A0APIClientError error = ^(NSError *error){
        NSLog(@"Oops something went wrong: %@", error);
        [self showMessage:@"Oops something went wrong"];
    };
    
    
    A0AuthParameters *params = [A0AuthParameters newDefaultParams];
    params[A0ParameterConnection] = kAuth0ConnectionType; // Or your configured DB connection
    
    [client signUpWithEmail:self.emailTextField.text
                   username:self.usernameTextField.text
                   password:self.passwordTextField.text
             loginOnSuccess:YES
                 parameters:params
                    success:success
                    failure:error];

}

- (IBAction)clickCloseButton:(id)sender {
    [self.delegate dismissLock];
}

- (IBAction)clickBackButton:(id)sender {
    [self.delegate backToLock];
}

- (void)showMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Auth0" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
