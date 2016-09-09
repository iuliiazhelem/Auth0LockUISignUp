//
//  ViewController.m
//  AKAuth0TestApp
//

#import "ViewController.h"
#import <Lock/Lock.h>
#import "AKAuth0SignUpViewController.h"

@interface ViewController ()

- (IBAction)clickLockVCButton:(id)sender;
- (IBAction)clickCustomSignUpButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ViewController

// Open Lock UI with Lock SignUp View
- (IBAction)clickLockVCButton:(id)sender {
    A0Lock *lock = [A0Lock sharedLock];
    A0LockViewController *controller = [lock newLockViewController];
    controller.closable = YES;
    controller.loginAfterSignUp = YES;//NO
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        // Do something with token & profile. e.g.: save them.
        // If loginAfterSignUp - NO, profile and token will be nil
        [self showUserProfile:profile];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    controller.onUserDismissBlock = ^(){
        NSLog(@"User closed Lock UI");
    };
    
    [self presentViewController:controller animated:YES completion:nil];
}

// Open Lock UI with Custom SignUp View
- (IBAction)clickCustomSignUpButton:(id)sender {
    A0Lock *lock = [A0Lock sharedLock];
    A0LockViewController *controller = [lock newLockViewController];
    controller.closable = YES;
    
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        // Do something with token & profile. e.g.: save them.
        [self showUserProfile:profile];
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

// Internal method
- (void)showUserProfile:(A0UserProfile *)profile {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.usernameLabel.text = profile.name;
        self.userIdLabel.text = profile.userId;
        self.emailLabel.text = profile.email;
    });
}

@end
