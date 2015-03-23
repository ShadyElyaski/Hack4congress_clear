//
//  LoginTableViewController.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "LoginTableViewController.h"
#import <Firebase/Firebase.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"

@interface LoginTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *signupBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtView;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtView;
@property (weak, nonatomic) IBOutlet UITextField *ssnTxtView;

@end

@implementation LoginTableViewController

- (IBAction)cancelBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signupBtnPressed:(id)sender {
    if ([self validateData]) {
        [SVProgressHUD showWithStatus:@"Logging In..."];
        
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://clear.firebaseio.com"];
        [ref authUser:_emailTxtView.text password:_passwordTxtView.text
  withCompletionBlock:^(NSError *error, FAuthData *authData) {
      if (error) {
          // There was an error logging in to this account
          [SVProgressHUD showErrorWithStatus:@"Error"];
      } else {
          // We are now logged in
          [SVProgressHUD dismiss];
          [[NSUserDefaults standardUserDefaults] setObject:_emailTxtView.text forKey:@"email"];
          [[NSUserDefaults standardUserDefaults] setObject:_passwordTxtView.text forKey:@"password"];
          [[NSUserDefaults standardUserDefaults] setObject:authData.uid forKey:@"uid"];
          [[NSUserDefaults standardUserDefaults] setObject:authData.auth forKey:@"auth"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          [Utils checkBiometricWithSender:self];
      }
  }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"Wrong email or empty password"];
    }
}



-(BOOL)validateData{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"] evaluateWithObject:_emailTxtView.text] && _passwordTxtView.text.length>4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
