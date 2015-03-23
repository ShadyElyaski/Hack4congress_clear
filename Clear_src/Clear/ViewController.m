//
//  ViewController.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "AppDelegate.h"
#import <OpenSans/UIFont+OpenSans.h>

@interface ViewController (){
    BOOL isFirstRun;
}
@property (weak, nonatomic) IBOutlet UIButton *guestBtn;

@end

@implementation ViewController

- (IBAction)guestLoginBtnPressed:(id)sender {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate setGuestLogin:YES];
    [Utils postBiometricCheckWithSender:self];
}

- (IBAction)loginBtnPressed:(id)sender {
    [self login:YES];
}

-(void)login:(BOOL)force{
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if (!force && email.length && password.length) {
        [SVProgressHUD showWithStatus:@"Logging In..."];
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://clear.firebaseio.com"];
        [ref authUser:email password:password
  withCompletionBlock:^(NSError *error, FAuthData *authData) {
      if (error) {
          // There was an error logging in to this account
          [SVProgressHUD showErrorWithStatus:@"Error"];
          NSLog(@"%@", error);
      } else {
          // We are now logged in
          [[NSUserDefaults standardUserDefaults] setObject:authData.auth forKey:@"auth"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          [SVProgressHUD dismiss];
          [Utils checkBiometricWithSender:self];
      }
  }];
    }else{
        UINavigationController *navCntl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavCntrl"];
        [self presentViewController:navCntl animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [_guestBtn.titleLabel setFont:[UIFont openSansFontOfSize:16]];
    // Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!isFirstRun) {
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
        if (email.length && password.length)
            [self login:NO];
        
        isFirstRun = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
