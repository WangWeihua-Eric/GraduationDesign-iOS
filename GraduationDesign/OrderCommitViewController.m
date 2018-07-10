//
//  OrderCommitViewController.m
//  GraduationDesign
//
//  Created by Eric on 2018/3/20.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "OrderCommitViewController.h"
#import "SearchPojo.h"

@interface OrderCommitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *toCtiy;
@property (weak, nonatomic) IBOutlet UILabel *fromCity;
@property (weak, nonatomic) IBOutlet UILabel *plantTime;

@end

@implementation OrderCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    SearchPojo *searchPojo = [SearchPojo sharedInstance];
    _toCtiy.text = searchPojo.toAddress;
    _fromCity.text = searchPojo.fromAddress;
    _plantTime.text = searchPojo.departureTimee;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
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
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
