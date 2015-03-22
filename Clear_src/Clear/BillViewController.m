//
//  BillViewController.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "BillViewController.h"

@interface BillViewController ()
@property (weak, nonatomic) IBOutlet UIView *voteView;
@property (weak, nonatomic) IBOutlet UILabel *upVoteLbl;
@property (weak, nonatomic) IBOutlet UILabel *downVoteLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgVu;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtVu;

@end

@implementation BillViewController

-(NSArray *)getBillId{
    NSString *billID = self.billDic[@"bill_id"];
    NSUInteger index = [billID rangeOfString:@"-"].location;
    return @[[billID substringToIndex:index], [billID substringFromIndex:index+1]];
}

- (IBAction)ayeBtnPressed:(id)sender {
    
}

- (IBAction)nayBtnPressed:(id)sender {
    
}

- (IBAction)noteVotingBtnPressed:(id)sender {
    
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
    
    _descriptionTxtVu.text = [self.billDic[@"context"] length]?self.billDic[@"context"]:self.billDic[@"description"];
    
    _imgVu.layer.cornerRadius = _imgVu.frame.size.width/2.f;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnPressed)]];
    _voteView.layer.cornerRadius = 8.f;
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
