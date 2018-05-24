//
//  GuideViewController.m
//  PadProject
//
//  Created by SansiMac on 2018/5/16.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideCollectionViewCell.h"
#import "LoginViewController.h"

static NSString *const kGuideCellID = @"GuideCellID";
static NSInteger const pageCount = 4;
@interface GuideViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton * skipBtn;
@property(nonatomic,strong) UIButton *loginBtn;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

- (void)setupViews{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.skipBtn];
    [self.view addSubview:self.loginBtn];
}
- (void)viewWillLayoutSubviews{
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(150);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}
#pragma mark -- oratation
//- (BOOL)shouldAutorotate{
//    return YES;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark -- collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return pageCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuideCollectionViewCell *cell = (GuideCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGuideCellID forIndexPath:indexPath];
    cell.backgroundColor = kRandomColor;
    cell.describeLab.text = [NSString stringWithFormat:@"===%ld===", indexPath.item];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x+(kScreenWidth/2))/kScreenWidth;
    _pageControl.currentPage = index;
    if (index < pageCount-1) {
        _loginBtn.hidden = YES;
        _skipBtn.hidden = NO;
    }else{
        _loginBtn.hidden = NO;
        _skipBtn.hidden = YES;
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.view.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor purpleColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GuideCollectionViewCell class] forCellWithReuseIdentifier:kGuideCellID];
    }
    return _collectionView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    }
    return _pageControl;
}
- (UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.backgroundColor = kRandomColor;
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:kRandomColor forState:UIControlStateNormal];
        _skipBtn.layer.cornerRadius = 3;
        _skipBtn.layer.masksToBounds = YES;
        @weakify(self)
        [[_skipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self login];
        }];
    }
    return _skipBtn;
}
- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = kRandomColor;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kRandomColor forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 3;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.hidden = YES;
        @weakify(self)
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self login];
        }];
    }
    return _loginBtn;
}

- (void)login{
    LoginViewController *vc = [[LoginViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGRect frame = CGRectZero;
    flow.itemSize = size;
    if (size.width > size.height) {
        NSLog(@"============= 横屏");
        frame = CGRectMake(0, 0, size.width, size.height);
    }else{
        NSLog(@"========------ 竖屏");
        frame = CGRectMake(0, 0, size.width, size.height);
    }
    _collectionView.frame = frame;
    _collectionView.collectionViewLayout = flow;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_pageControl.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}


- (void)handleDeviceOrientationDidChange{
    UIDevice *device = [UIDevice currentDevice] ;
    switch (device.orientation) {//判断设备方向  而UIInterfaceOrientation判断当前页面方向
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
            
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"home键在左== %@--- %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(_collectionView.frame));
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"home键在右== %@--- %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(_collectionView.frame));
            
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"home键在下== %@--- %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(_collectionView.frame));
            
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"home键在上== %@--- %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(_collectionView.frame));
            break;
            
        default:
            NSLog(@"无法辨识");
            break;
    }
}

@end
