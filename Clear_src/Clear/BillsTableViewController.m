//
//  BillsTableViewController.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "BillsTableViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "BillViewController.h"
#import "AppDelegate.h"
#import "GuestViewController.h"

@interface BillsTableViewController (){
    NSArray *billArr;
    BOOL isFirstRun;
    int selectedIndex;
}
@property (weak, nonatomic) IBOutlet UIRefreshControl *refreshCntrl;

@end

@implementation BillsTableViewController

- (IBAction)refresh:(id)sender {
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)menuBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!isFirstRun) {
        [self reloadData];
        isFirstRun = YES;
    }
}

-(void)reloadData{
    [_refreshCntrl beginRefreshing];
    [SVProgressHUD showWithStatus:@"Loading..."];
    // Generate a NSURLRequest object from the address of the API we are trying to reach
    NSURL *url = [NSURL URLWithString:@"https://congress.api.sunlightfoundation.com/upcoming_bills?order=scheduled_at&per_page=50&apikey=e10c8bfe815f4dd580f4933da8fcf493"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Send the request!
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // Check to make sure there are no errors
                               if (error) {
                                   [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error in updateInfoFromServer: %@ %@", error, [error localizedDescription]]];
                               } else if (!response) {
                                   [SVProgressHUD showErrorWithStatus:@"Could not reach server!"];
                               } else if (!data) {
                                   [SVProgressHUD showErrorWithStatus:@"Server did not return any data!"];
                               } else {
                                   NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   billArr = responseDict[@"results"];
                                   NSLog(@"%@", billArr);
                                   [SVProgressHUD dismiss];
                                   [self.tableView reloadData];
                               }
                               [_refreshCntrl endRefreshing];
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return billArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    NSDictionary *billDic = billArr[indexPath.row];
    
    [(UILabel *)[cell viewWithTag:1100] setText:[billDic[@"description"] length]?billDic[@"description"]:billDic[@"context"]];
    [(UILabel *)[cell viewWithTag:1111] setText:[billDic[@"context"] length]?billDic[@"context"]:billDic[@"description"]];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.guestLogin) {
        GuestViewController *vuCntrl = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestViewController"];
        NSDictionary *billDic = billArr[indexPath.row];
        [vuCntrl setBillDic:billDic];
        [vuCntrl setIndex:(int)indexPath.row];
        [self.navigationController pushViewController:vuCntrl animated:YES];
    }else{
        BillViewController *vuCntrl = [self.storyboard instantiateViewControllerWithIdentifier:@"BillViewController"];
        NSDictionary *billDic = billArr[indexPath.row];
        [vuCntrl setBillDic:billDic];
        [vuCntrl setIndex:(int)indexPath.row];
        [self.navigationController pushViewController:vuCntrl animated:YES];
    }
}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
