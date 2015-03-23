//
//  GuestViewController.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "GuestViewController.h"
#import <MagicPieLayer.h>
#import <Firebase/Firebase.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface GuestViewController (){
    PieLayer *pieLayer;
}

@end

@implementation GuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pieLayer = [[PieLayer alloc] init];
    pieLayer.frame = CGRectMake(120, 150, 200, 200);
    [pieLayer setShowTitles:ShowTitlesAlways];
    
    [self.view.layer addSublayer:pieLayer];
    
    [pieLayer addValues:@[[PieElement pieElementWithValue:0 color:[UIColor redColor]],
                          [PieElement pieElementWithValue:0 color:[UIColor greenColor]],
                          [PieElement pieElementWithValue:0 color:[UIColor grayColor]]] animated:NO];
    self.title = [self.billDic[@"description"] length]?self.billDic[@"description"]:self.billDic[@"context"];
    
    [self initFirebase];
}

-(void)initFirebase{
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://clear.firebaseio.com/votes/%@", self.billDic[@"bill_id"]]];
    // Attach a block to read the data at our posts reference
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot);
        [snapshot.children.allObjects enumerateObjectsUsingBlock:^(FDataSnapshot *obj, NSUInteger idx, BOOL *stop) {
            [self updateData:obj];
        }];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)updateData:(FDataSnapshot *)snapshot{
    PieElement *pieElem = nil;
    if ([snapshot.key isEqualToString:@"aye"]) {
        pieElem = pieLayer.values[1];
        [PieElement animateChanges:^{
            pieElem.val = [snapshot.value intValue];
        }];
    }else if ([snapshot.key isEqualToString:@"nay"]) {
        pieElem = pieLayer.values[0];
        [PieElement animateChanges:^{
            pieElem.val = [snapshot.value intValue];
        }];
    }else if ([snapshot.key isEqualToString:@"notvoting"]) {
        pieElem = pieLayer.values[2];
        [PieElement animateChanges:^{
            pieElem.val = [snapshot.value intValue];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
