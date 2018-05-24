//
//  LoginButtonView.h
//  PadProject
//
//  Created by SansiMac on 2018/5/18.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtonTitle @"登   录"
#define kButtonTitleFontSize [UIFont systemFontOfSize:16.f]

@protocol LoginButtonViewDelegate <NSObject>

- (void)loginButtonViewActivated;

@end

@interface LoginButtonView : UIView
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) id<LoginButtonViewDelegate>delegate;
@property (nonatomic, copy) void(^finishBlock)(void);

- (void)clickButton;
- (void)removeAllAnimation;
- (void)restoreSubViews;
@end
