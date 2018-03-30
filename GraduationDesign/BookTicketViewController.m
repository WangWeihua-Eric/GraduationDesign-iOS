//
//  BookTicketViewController.m
//  GraduationDesign
//
//  Created by Eric on 2018/3/14.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "BookTicketViewController.h"
#import "DemoTableViewCell.h"
#import <Masonry/Masonry.h>
#import "SearchPojo.h"
#import "NetInterfaceManager.h"

@interface BookTicketViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *flightInfoList;

@end

@implementation BookTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NetInterfaceManager sharedInstance] wExtraParams:nil
                                          wResultBlock:^(NSURLSessionDataTask *task, EQDRequestStatus status, id data, NSNumber *returnCode) {
                                              if (EQDRequestStatusSuccess == status && [returnCode integerValue] == 0) {
                                                  //                                                  [JFToast showToastTo:self.view withText:@"获取验证码成功"];
                                                  QDNetResultBaseModel* resultBaseModel = data;
                                                  _flightInfoList = [resultBaseModel networkData];
                                                  [self.tableView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.rowHeight = 120;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:7/255. green:18/255. blue:71/255. alpha:1];
    SearchPojo *searchPojo = [SearchPojo sharedInstance];
    NSString *from = searchPojo.fromAddress;
    NSString *arrive = searchPojo.toAddress;
    self.title = [from stringByAppendingFormat:@" —— %@" ,arrive];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_flightInfoList == nil || _flightInfoList.count < 1){
        return 0;
    }
    return _flightInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DemoTableViewCell class])];
//    if (!cell) {
//        cell = [[DemoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DemoTableViewCell class])];
//    }
    
    SearchPojo *searchPojo = [SearchPojo sharedInstance];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
//    UIView *backgroundView = [UIView new];
//    backgroundView.backgroundColor = [UIColor whiteColor];
//    backgroundView.layer.cornerRadius = 10;
    
    UIView *uiView = [cell.contentView viewWithTag:1000];
    uiView.backgroundColor = [UIColor whiteColor];
    uiView.layer.cornerRadius = 10;
    
    [uiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc] initWithDictionary:[_flightInfoList objectAtIndex:indexPath.row]];
    NSString *name = [sourceDic objectForKey:@"name"];
    NSString *airCode = [sourceDic objectForKey:@"airCode"];
    NSString *depAirport = [sourceDic objectForKey:@"depAirport"];
    NSString *arrAirport = [sourceDic objectForKey:@"arrAirport"];
    NSString *depTime = [sourceDic objectForKey:@"depTime"];
    NSString *arrTime = [sourceDic objectForKey:@"arrTime"];
    NSString *depTerminal = [sourceDic objectForKey:@"depTerminal"];
    NSString *arrTerminal = [sourceDic objectForKey:@"arrTerminal"];
    
    UILabel *fromTime = [cell.contentView viewWithTag:1001];
    fromTime.text = depTime;
    
    UILabel *toTime = [cell.contentView viewWithTag:1002];
    toTime.text = arrTime;
    
    UILabel *fromAddress = [cell.contentView viewWithTag:1004];
    fromAddress.text = [depAirport stringByAppendingFormat:@"%@" ,depTerminal];
    
    UILabel *toAddress = [cell.contentView viewWithTag:1005];
    toAddress.text = [arrAirport stringByAppendingFormat:@"%@" ,arrTerminal];
    
    UILabel *fightDes = [cell.contentView viewWithTag:1006];
    fightDes.text = [name stringByAppendingFormat:@"%@" ,airCode];
    
    
//    [[cell contentView] addSubview:backgroundView];
//    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(20, 20, 20, 20));
//    }];
    return cell;
}

@end
