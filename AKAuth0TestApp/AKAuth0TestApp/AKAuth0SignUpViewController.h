//
//  AKAuth0SignUpViewController.h
//  AKAuth0TestApp
//

#import <UIKit/UIKit.h>

@class A0Lock, A0LockEventDelegate;

@interface AKAuth0SignUpViewController : UIViewController

@property (weak, nonatomic)A0Lock *lock;
@property (weak, nonatomic)A0LockEventDelegate *delegate;

@end
