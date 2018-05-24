//
//  RightViewController.m
//  PadProject
//
//  Created by SansiMac on 2018/5/17.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "RightViewController.h"


static NSString *const kCellID = @"CELLID";

@interface RightViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRandomColor;
    [self setupNav];
    
}

- (void)setupNav{
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"请选择要播放的文件";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forBarMetrics:UIBarMetricsDefault];
    
    UIButton * refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(0, 0, 44, 30);
    @weakify(self)
    [[refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
    }];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel * playListLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    playListLab.textColor = [UIColor blackColor];
    playListLab.text = @"PLAY LIST";//选择字体、字号
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:playListLab];
    self.navigationItem.leftBarButtonItem = leftItem;

}

- (void)viewWillLayoutSubviews{
    [self.view addSubview:self.collectionView];
}

#pragma mark -- collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.backgroundColor = kRandomColor;
    return cell;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat viewW = self.view.frame.size.width;
        CGFloat w = (viewW-50*4)/3;
        flowLayout.itemSize = CGSizeMake(w, 150);
        
        flowLayout.minimumLineSpacing = 35;
        flowLayout.minimumInteritemSpacing = 50;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor purpleColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 50, 0, 50);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    }
    return _collectionView;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGRect frame = CGRectZero;
    CGFloat w = (size.width-50*4)/3;
    flow.itemSize = CGSizeMake(w, 150);
    if (size.width > size.height) {
        NSLog(@"============= 横屏");
        frame = CGRectMake(0, 0, size.width, size.height);
    }else{
        NSLog(@"========------ 竖屏");
        frame = CGRectMake(0, 0, size.width, size.height);
    }
    _collectionView.frame = frame;
    _collectionView.collectionViewLayout = flow;
}
@end
