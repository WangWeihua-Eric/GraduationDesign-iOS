//
//  ViewController.m
//  GraduationDesign
//
//  Created by Eric on 2018/2/26.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "ViewController.h"
#import "CGXPickerView.h"
#import "SearchPojo.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *departureTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressTitle;
@property (weak, nonatomic) IBOutlet UILabel *toAddressTitle;
@property (weak, nonatomic) IBOutlet UILabel *seatTitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr = [fmt stringFromDate:now];
    _departureTimeTitle.text = nowStr;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)departureTimeBtn:(id)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowStr = [fmt stringFromDate:now];
    
    [CGXPickerView showDatePickerWithTitle:@"出发时间" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        NSLog(@"%@",selectValue);
        _departureTimeTitle.text = selectValue;
    }];
}

- (IBAction)fromAddressBtn:(id)sender {
    [CGXPickerView showAddressPickerWithTitle:@"请选择你的出发城市" DefaultSelected:@[@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
        NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
        _fromAddressTitle.text = [NSString stringWithFormat:@"%@", selectAddressArr[0]];
    }];
}

- (IBAction)toAddressBtn:(id)sender {
    [CGXPickerView showAddressPickerWithTitle:@"请选择你的到达城市" DefaultSelected:@[@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
        NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
        _toAddressTitle.text = [NSString stringWithFormat:@"%@", selectAddressArr[0]];
    }];
}

- (IBAction)seatBtn:(id)sender {
    [CGXPickerView showStringPickerWithTitle:@"选择舱位" DataSource:@[@"舱位不限", @"经济舱", @"头等/商务舱"] DefaultSelValue:@"舱位不限" IsAutoSelect:NO ResultBlock:^(id selectValue, id selectRow) {
        NSLog(@"%@",selectValue);
        _seatTitle.text = selectValue;
    }];
}

- (IBAction)searchBtn:(id)sender {
    SearchPojo *searchPojo = [SearchPojo sharedInstance];
    [searchPojo setFromAddress:_fromAddressTitle.text];
    [searchPojo setToAddress:_toAddressTitle.text];
    [searchPojo setDepartureTimee:_departureTimeTitle.text];
    [searchPojo setSeat:_seatTitle.text];
}

@end
