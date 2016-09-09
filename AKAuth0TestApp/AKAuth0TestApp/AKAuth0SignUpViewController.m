//
//  AKAuth0SignUpViewController.m
//  AKAuth0TestApp
//

#import "AKAuth0SignUpViewController.h"
#import <Lock/Lock.h>

static NSString *kAuth0ConnectionType = @"Username-Password-Authentication";

@interface AKAuth0SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)clickSignUpButton:(id)sender;
- (IBAction)clickCloseButton:(id)sender;
- (IBAction)clickBackButton:(id)sender;

@end

@implementation AKAuth0SignUpViewController

- (IBAction)clickSignUpButton:(id)sender {
    
    if (self.emailTextField.text.length < 1) {
        [self showMessage:@"Please eneter an email"];
        return;
    }
    if (self.passwordTextField.text.length < 1) {
        [self showMessage:@"Please eneter a password"];
        return;
    }
    
    A0APIClient *client = [self.lock apiClient];
    A0APIClientSignUpSuccess success = ^(A0UserProfile *profile, A0Token *token) {
        NSLog(@"Success: %@", profile.name);
        // Calls `onAuthenticationBlock` of `A0LockViewController` with token and profile
        [self.delegate userAuthenticatedWithToken:token profile:profile];
    };
    
    A0APIClientError error = ^(NSError *error){
        NSLog(@"Oops something went wrong: %@", error);
        [self showMessage:@"Oops something went wrong"];
    };
    
    
    A0AuthParameters *params = [A0AuthParameters newDefaultParams];
    params[A0ParameterConnection] = kAuth0ConnectionType; // Or your configured DB connection
    
    [client signUpWithEmail:self.emailTextField.text
                   password:self.passwordTextField.text
             loginOnSuccess:YES
                 parameters:params
                    success:success
                    failure:error];
}

- (IBAction)clickCloseButton:(id)sender {
    // Dismiss A0LockViewController, like tapping the close button if `closable` is true
    [self.delegate dismissLock];
}

- (IBAction)clickBackButton:(id)sender {
    // Dismiss all custom UIViewControllers pushed inside Lock and shows it's main UI.
    [self.delegate backToLock];
}

- (void)showMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Auth0" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
