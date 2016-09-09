# Auth0LockUISignUp

This sample exposes how to create and use custom Sign Up View controller with Lock UI.

You have several ways to implement Sign Up functionality with Lock UI.
- You can just add or hide "Sign Up" button in Lock UI. For this you need to setup property "disableSignUp" of A0LockViewControllerwhich hides the Sign Up button. By default is NO.
- You can use A0LockSignUpViewController directly
- You can add your own Sign Up View Controller

You need to add the following to your `Podfile`:
```
pod 'Lock', '~> 1.26'
```

### Important Snippets
#### Step 1: Create Sign Up View Controller.
It which should contain delegate property (A0LockEventDelegate) and implement sign up logic with one of A0APIClient methods. Alos you can implement additional A0LockEventDelegate methods:
- (void)backToLock - Dismiss all custom UIViewControllers pushed inside Lock and shows it's main UI.
- (void)dismissLock - Dismiss A0LockViewController, like tapping the close button if `closable` is true

```Swif
var lock: A0Lock!
var delegate: A0LockEventDelegate!

let success = { (profile: A0UserProfile?, token: A0Token?) in
  // Calls `onAuthenticationBlock` of `A0LockViewController` with token and profile
  self.delegate.userAuthenticatedWithToken(token!, profile: profile!)
}
let client = self.lock.apiClient()
let params = A0AuthParameters.newDefaultParams()
params[A0ParameterConnection] = "Username-Password-Authentication" // Or your configured DB connection
client.signUpWithEmail(<email>, password: <password>, loginOnSuccess: true, parameters: params, success: success, failure: failure)
```

```Objective-C
@property (weak, nonatomic)A0Lock *lock;
@property (weak, nonatomic)A0LockEventDelegate *delegate;

A0APIClient *client = [self.lock apiClient];
A0APIClientSignUpSuccess success = ^(A0UserProfile *profile, A0Token *token) {
  // Calls `onAuthenticationBlock` of `A0LockViewController` with token and profile
  [self.delegate userAuthenticatedWithToken:token profile:profile];
};
A0APIClientError error = ^(NSError *error){
  NSLog(@"Oops something went wrong: %@", error);
};
A0AuthParameters *params = [A0AuthParameters newDefaultParams];
params[A0ParameterConnection] = @"Username-Password-Authentication"; // Or your configured DB connection
[client signUpWithEmail:<email>
               password:<password>
         loginOnSuccess:YES
             parameters:params
                success:success
                failure:error];
```

#### Step 2: Add the Sign Up View Controller to Lock UI

```Swift
let controller = A0Lock.sharedLock().newLockViewController()
controller.onAuthenticationBlock = { (profile, token) in
  // Do something with token & profile. e.g.: save them.
  // If loginAfterSignUp - NO, profile and token will be nil
  self.dismissViewControllerAnimated(true, completion: nil)
}

//Create custom SignUp view controller
controller.customSignUp = { (lock:A0Lock, delegate:A0LockEventDelegate) in
  let signUpVC = ...//create VC
  signUpVC.lock = lock
  signUpVC.delegate = delegate
  return signUpVC
}
        
let navController:UINavigationController = UINavigationController.init(rootViewController: controller)
if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
  navController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
}
        
self.presentViewController(navController, animated: true, completion: nil)
```

```Objective-C
A0Lock *lock = [A0Lock sharedLock];
A0LockViewController *controller = [lock newLockViewController];
controller.closable = YES;
controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
  // Do something with token & profile. e.g.: save them.
  [self dismissViewControllerAnimated:YES completion:nil];
};
    
//Create custom SignUp view controller
controller.customSignUp = ^ UIViewController *(A0Lock *lock, A0LockEventDelegate *delegate) {
  AKAuth0SignUpViewController *signUpVC = ...//create VC;
  signUpVC.lock = lock;
  signUpVC.delegate = delegate;
  return signUpVC;
};

UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
  navController.modalPresentationStyle = UIModalPresentationFormSheet;
}

[self presentViewController:navController animated:YES completion:nil];
```

Please make sure that you change some keys in `Info.plist` with your Auth0 data from [Auth0 Dashboard](https://manage.auth0.com/#/applications):
- Auth0ClientId
- Auth0Domain
- CFBundleURLSchemes
```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>auth0</string>
<key>CFBundleURLSchemes</key>
<array>
<string>a0{CLIENT_ID}</string>
</array>
```
For more information about Lock UI please check the following links:
- [Lock for Objective-C](https://auth0.com/docs/quickstart/native/ios-objc)
- [Lock for Swift](https://auth0.com/docs/quickstart/native/ios-swift)
