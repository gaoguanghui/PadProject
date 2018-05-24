//
//  LeftViewController.m
//  PadProject
//
//  Created by SansiMac on 2018/5/17.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "LeftViewController.h"
#import "LoginViewController.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRandomColor;
    [self setupNav];
}

- (void)setupNav{
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"我的设备";
    
    UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0, 0, 60, 30);
    @weakify(self)
    [[logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self showLogoutAlert];
    }];
    [logoutBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    self.navigationItem.leftBarButtonItem = leftItem;;
    
    
}
- (void)showLogoutAlert{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:UIApplication.sharedApplication.keyWindow animated:YES];
            LoginViewController * vc = [[LoginViewController alloc] init];
            UIApplication.sharedApplication.keyWindow.rootViewController = vc;
        });
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self createTableView];
}
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.rowHeight = 150;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    NSLog(@"===== %@", [NSString stringWithFormat:@"==%ld", indexPath.row]);
    cell.textLabel.text = [NSString stringWithFormat:@"==%ld", indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIViewController * vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.translucent = NO;
//    vc.title = @"title";
//    [self showDetailViewController:nav sender:self];
}

@end
