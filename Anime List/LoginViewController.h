//
//  LoginViewController.h
//  Anime List
//
//  Created by Aaron Sky on 4/23/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserStore.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end
