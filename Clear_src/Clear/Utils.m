//
//  Utils.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "Utils.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AppDelegate.h"

@implementation Utils

+(void)checkBiometricWithSender:(UIViewController *)sender{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error){
                              if (error){
                                  [[[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"There was a problem verifying your identity."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil] show];
                                  return;
                              }
                              
                              if (success){
                                  [Utils postBiometricCheckWithSender:sender];
                              }else {
                                  [[[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"You are not the device owner."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil] show];
                              }
                          }];
    }else {
        [Utils postBiometricCheckWithSender:sender];
    }
}

+(void)postBiometricCheckWithSender:(UIViewController *)sender{
    [sender dismissViewControllerAnimated:YES completion:nil];
    UINavigationController *navCntrl = [sender.storyboard instantiateViewControllerWithIdentifier:@"BillsNavCntrl"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navCntrl animated:YES completion:nil];
}

@end
