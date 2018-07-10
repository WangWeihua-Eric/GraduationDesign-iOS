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
#import "FlightInfosPojo.h"
#import "NetInterfaceManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *departureTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressTitle;
@property (weak, nonatomic) IBOutlet UILabel *toAddressTitle;
@property (weak, nonatomic) IBOutlet UILabel *seatTitle;

@property (nonatomic, strong) NSArray *cityName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _cityName = @[@"北京", @"上海", @"重庆", @"昆明", @"成都", @"西安", @"深圳", @"厦门", @"杭州", @"青岛", @"哈尔滨", @"郑州", @"广州", @"海口", @"贵阳", @"长沙", @"乌鲁木齐", @"济南", @"天津", @"南京"];
    _fromAddressTitle.text = @"北京";
    _toAddressTitle.text = @"上海";
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr = [fmt stringFromDate:now];
    _departureTimeTitle.text = nowStr;
    [self preSearch];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
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
        [self preSearch];
    }];
}

- (IBAction)fromAddressBtn:(id)sender {
    [CGXPickerView showStringPickerWithTitle:@"请选择你的出发城市" DataSource:_cityName DefaultSelValue:@"北京" IsAutoSelect:NO ResultBlock:^(id selectValue, id selectRow) {
        NSLog(@"%@",selectValue);
        _fromAddressTitle.text = selectValue;
        [self preSearch];
    }];
}

- (IBAction)toAddressBtn:(id)sender {
    [CGXPickerView showStringPickerWithTitle:@"请选择你的到达城市" DataSource:_cityName DefaultSelValue:@"上海" IsAutoSelect:NO ResultBlock:^(id selectValue, id selectRow) {
        NSLog(@"%@",selectValue);
        _toAddressTitle.text = selectValue;
        [self preSearch];
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

- (void)preSearch{
    NSDictionary *params = @{
                             @"goDate": _departureTimeTitle.text,
                             @"depCity": _fromAddressTitle.text,
                             @"arrCity": _toAddressTitle.text
                             };
    [[NetInterfaceManager sharedInstance] wExtraParams:params
                                          wResultBlock:^(NSURLSessionDataTask *task, EQDRequestStatus status, id data, NSNumber *returnCode) {
                                              if (EQDRequestStatusSuccess == status && [returnCode integerValue] == 0) {
                                                  //                                                  [JFToast showToastTo:self.view withText:@"获取验证码成功"];
                                                  QDNetResultBaseModel* resultBaseModel = data;
                                                  [FlightInfosPojo sharedInstance].flightInfoList = [resultBaseModel networkData];
                                              }else if (EQDRequestStatusSuccess == status || EQDRequestStatusFail == status) {
                                                  NSString *errStr = nil;
                                                  if ([data isKindOfClass:[QDNetResultBaseModel class]]) {
                                                      QDNetResultBaseModel* resultBaseModel = data;
                                                      errStr = resultBaseModel.networkStatus.returnDesc;
                                                  }
                                                  
                                                  //                                                  if (StringIsNullOrEmpty(errStr)) {
                                                  //                                                      errStr = @"获取验证码失败，请检查网络";
                                                  //                                                  }
                                                  //                                                  [JFToast showToastTo:self.view withText:errStr];
                                                  //
                                                  //
                                                  //                                                  [QTrackingManager avAnalyticsEvent:kAVEvent_id_login label:@"label_vcoed_fail"];
                                              }
                                          }];
}

@end
