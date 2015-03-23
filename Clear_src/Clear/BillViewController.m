//
//  BillViewController.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "BillViewController.h"
#import <Firebase/Firebase.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface BillViewController ()
@property (weak, nonatomic) IBOutlet UIView *voteView;
@property (weak, nonatomic) IBOutlet UILabel *upVoteLbl;
@property (weak, nonatomic) IBOutlet UILabel *downVoteLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgVu;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtVu;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;

@end

@implementation BillViewController

-(NSArray *)getBillId{
    NSString *billID = self.billDic[@"bill_id"];
    NSUInteger index = [billID rangeOfString:@"-"].location;
    return @[[billID substringToIndex:index], [billID substringFromIndex:index+1]];
}

- (IBAction)ayeBtnPressed:(id)sender {
    [SVProgressHUD showWithStatus:@"Voting Up..." maskType:SVProgressHUDMaskTypeGradient];
    Firebase *upvotesRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://clear.firebaseio.com/votes/%@/aye", self.billDic[@"bill_id"]]];
    [self runTransaction:upvotesRef];
}

- (IBAction)nayBtnPressed:(id)sender {
    [SVProgressHUD showWithStatus:@"Voting Down..." maskType:SVProgressHUDMaskTypeGradient];
    Firebase *upvotesRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://clear.firebaseio.com/votes/%@/nay", self.billDic[@"bill_id"]]];
    [self runTransaction:upvotesRef];
}

- (IBAction)noteVotingBtnPressed:(id)sender {
    [SVProgressHUD showWithStatus:@"Not Voting..." maskType:SVProgressHUDMaskTypeGradient];
    Firebase *upvotesRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://clear.firebaseio.com/votes/%@/notvoting", self.billDic[@"bill_id"]]];
    [self runTransaction:upvotesRef];
}

-(void)runTransaction:(Firebase *)ref{
    [ref runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
        NSNumber *value = currentData.value;
        if (currentData.value == [NSNull null]) {
            value = 0;
        }
        [currentData setValue:[NSNumber numberWithInt:(1 + [value intValue])]];
        return [FTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"Vote Submitted"];
            [_voteBtn setTitle:@"VOTED" forState:UIControlStateNormal];
            [_voteBtn.titleLabel setTextColor:[UIColor greenColor]];
            [_voteBtn setEnabled:NO];
            [self cancelBtnPressed];
        }
    }];
}

- (IBAction)voteBtnPressed:(id)sender {
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    [bgView setBackgroundColor:[UIColor colorWithWhite:.4 alpha:.4]];
    [bgView setAlpha:0];
    [bgView setTag:5544];
    [self.view insertSubview:bgView belowSubview:self.voteView];
    [UIView animateWithDuration:.4 animations:^{
        _voteView.alpha = 1.f;
        [bgView setAlpha:1.f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.billDic[@"description"] length]?self.billDic[@"description"]:self.billDic[@"context"];
    _titleLbl.text = self.title;
    _subTitleLbl.text = self.billDic[@"bill_id"];
    
    _descriptionTxtVu.text = [self.billDic[@"context"] length]?self.billDic[@"context"]:self.billDic[@"description"];
    
    _imgVu.layer.cornerRadius = _imgVu.frame.size.width/2.f;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnPressed)]];
    _voteView.layer.cornerRadius = 8.f;
    
    [_imgVu setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pic%d.jpg", self.index%3]]];
    
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
    if ([snapshot.key isEqualToString:@"aye"]) {
        [_upVoteLbl setText:[NSString stringWithFormat:@"%d", [snapshot.value intValue]]];
    }else if ([snapshot.key isEqualToString:@"nay"]) {
        [_downVoteLbl setText:[NSString stringWithFormat:@"%d", [snapshot.value intValue]]];
    }else if ([snapshot.key isEqualToString:@"notvoting"]) {
        
    }
}

-(void)cancelBtnPressed{
    [UIView animateWithDuration:.4 animations:^{
        _voteView.alpha = 0.f;
        [[self.view viewWithTag:5544] setAlpha:0];
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:5544] removeFromSuperview];
    }];
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
