//
//  SplitViewController.m
//  PadProject
//
//  Created by SansiMac on 2018/5/17.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "SplitViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "BaseNavigarionController.h"

@interface SplitViewController ()

@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LeftViewController * leftVC = [[LeftViewController alloc] init];
    UINavigationController * nav1 = [[UINavigationController  alloc] initWithRootViewController:leftVC];
    RightViewController * rightVC = [[RightViewController alloc] init];
    BaseNavigarionController * nav2 = [[BaseNavigarionController  alloc] initWithRootViewController:rightVC];
//    [nav2 setRightVCBar];
    self.viewControllers = @[nav1, nav2];
//    splitVc.delegate = (id)rightVC;
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
