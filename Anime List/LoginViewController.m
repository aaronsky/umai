//
//  LoginViewController.m
//  Anime List
//
//  Created by Aaron Sky on 4/23/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    UIActivityIndicatorView* activityIndicator;
    NSURLSession* _session;
    XMLDictionaryParser* _parser;
    UIViewController* _currentVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:self.view.frame];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    _passwordField.secureTextEntry = YES;
    
    // put image behind other elements
    [self.view sendSubviewToBack: _bgImage];
    
    if ([UserStore currentUser].username) {
        _userNameField.text = [UserStore currentUser].username;
    }
    _currentVC = self;
    _parser = [[XMLDictionaryParser alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self verifyCredentials];
    if ([UserStore currentUser].username && [UserStore currentUser].password) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"Login Successful" sender:self];
        }];
    } else {
        [UIView animateWithDuration:0.5f
                              delay:1.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _promptLabel.frame = CGRectMake(_promptLabel.frame.origin.x, _promptLabel.frame.origin.y - 50, _promptLabel.frame.size.width, _promptLabel.frame.size.height);
                             [activityIndicator setAlpha:0.0f];
                         } completion:^(BOOL finished) {
                             [activityIndicator stopAnimating];
                             activityIndicator.hidden = YES;
                             _userNameField.hidden = _passwordField.hidden = _logInButton.hidden = NO;
                             [UIView animateWithDuration:0.5f
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  [_userNameField setAlpha:1.0f];
                                                  [_passwordField setAlpha:1.0f];
                                                  [_logInButton setAlpha:1.0f];
                                              } completion:^(BOOL finished) {
                                                  NSLog(@"No saved login was found");
                                              }];
                         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)verifyCredentials
{
    NSString* username;
    NSString* password;
    if ([UserStore currentUser].username && [UserStore currentUser].password) {
        username = [UserStore currentUser].username;
        password = [UserStore currentUser].password;
    } else if (![_userNameField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]) {
        username = _userNameField.text;
        password = _passwordField.text;
    } else {
        return;
    }
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSString* authInfo = [[[NSString stringWithFormat:@"%@:%@",username, password] dataUsingEncoding:NSASCIIStringEncoding] base64EncodedStringWithOptions:0];
    config.HTTPAdditionalHeaders = @{
                                     @"Authorization": [NSString stringWithFormat:@"Basic %@",authInfo]
                                    };
    _session = [NSURLSession sessionWithConfiguration:config];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *url = [NSURL URLWithString:@"http://myanimelist.net/api/account/verify_credentials.xml"];
    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
            if (httpResp.statusCode == 200) {
                NSDictionary* dictFromXml = [_parser dictionaryWithData:data];
                
                if (dictFromXml) {
                    if (![dictFromXml[@"username"] isEqualToString:username]) {
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        NSLog(@"Thanks");
                        [UserStore currentUser].username = username;
                        [UserStore currentUser].password = password;
                        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
                        [prefs setObject:[UserStore currentUser].username forKey:@"username"];
                        [prefs setObject:[UserStore currentUser].password forKey:@"password"];
                        [self performSegueWithIdentifier:@"Login Successful" sender:self];
                    });
                }
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    [dataTask resume];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_currentVC == self) {
            NSLog(@"Timed out");
        }
    });
}

- (IBAction)verifyLogin:(id)sender {
    if (![_userNameField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]) {
        [self verifyCredentials];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    _promptLabel.text = @"Logged in!";
    _currentVC = [segue destinationViewController];
    // Pass the selected object to the new view controller.
}


@end
