//
//  AKAuth0SignUpViewController.h
//  AKAuth0TestApp
//
//  Created by Iuliia Zhelem on 27.06.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class A0Lock, A0LockEventDelegate;

@interface AKAuth0SignUpViewController : UIViewController

@property (weak, nonatomic)A0Lock *lock;
@property (weak, nonatomic)A0LockEventDelegate *delegate;

@end
