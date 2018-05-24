//
//  LoginTextFieldView.m
//  PadProject
//
//  Created by SansiMac on 2018/5/18.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "LoginTextFieldView.h"

#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kCursonColor [UIColor colorWithHexString:@"0x007AFF"] // 光标和下划线颜色
#define kPlaceholderNormalColor [UIColor lightGrayColor] // 普通状态下placeholder颜色
#define kPlaceholderSelectColor [UIColor colorWithHexString:@"0x007AFF"] // 选中状态下placeholder颜色
#define kTextFontSize [UIFont systemFontOfSize:16.0f] // textField字体大小
#define kPlaceholderNormalFontSize [UIFont systemFontOfSize:16.0f] // 普通状态下placeholder字体大小
#define kPlaceholderSelectFontSize [UIFont systemFontOfSize:13.0f] // 选中状态下placeholder字体大小
#define kLineViewHeight 1 // 下划线高度
#define kXLength 5 // 左右移动距离
#define kYLength 2 // 上下移动距离

@interface LoginTextFieldView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, assign) BOOL isMoved;

@end

@implementation LoginTextFieldView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMainView];
    }
    return self;
}

- (void)setupMainView {
    if (!_textField) {
        _textField = ({
            UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectZero];
            textFiled.borderStyle = UITextBorderStyleNone;
            textFiled.font = kTextFontSize;
            textFiled.textColor = kTextColor;
            textFiled.tintColor = kCursonColor;
            textFiled.delegate = self;
            [self addSubview:textFiled];
            textFiled;
        });
    }
    
    if (!_placeholderLabel) {
        _placeholderLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = kPlaceholderNormalFontSize;
            label.textColor = kPlaceholderNormalColor;
            [self addSubview:label];
            label;
        });
    }
    
    if (!_lineView) {
        _lineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = kPlaceholderNormalColor;
            [self addSubview:view];
            view;
        });
    }
    
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.frame = CGRectMake(0, 0, 0, kLineViewHeight);
        _lineLayer.anchorPoint = CGPointMake(0, kLineViewHeight/2);
        _lineLayer.backgroundColor = kCursonColor.CGColor;
    }
    [_lineView.layer addSublayer:_lineLayer];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-kLineViewHeight);
    _placeholderLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-kLineViewHeight);
    _lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), kLineViewHeight);
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _textField = textField;
    CGFloat x = _placeholderLabel.center.x;
    CGFloat y = _placeholderLabel.center.y;
    if (!_isMoved) {
        [self moveAnimationX:x Y:y];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _textField = textField;
    CGFloat x = _placeholderLabel.center.x;
    CGFloat y = _placeholderLabel.center.y;
    if (textField.text.length == 0) {
        [self backAnimationX:x Y:y];
    }
}

- (void)moveAnimationX:(CGFloat)x Y:(CGFloat)y {
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    _placeholderLabel.font = kPlaceholderSelectFontSize;
    _placeholderLabel.textColor = kPlaceholderSelectColor;
    
    [UIView animateWithDuration:0.15f animations:^{
        moveY -= self->_placeholderLabel.frame.size.height/2 + kYLength;
        moveX -= kXLength;
        self->_placeholderLabel.center = CGPointMake(moveX, moveY);
        self->_isMoved = YES;
        self->_lineLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), kLineViewHeight);
        self->_lineView.backgroundColor = kPlaceholderSelectColor;
    }];
}

- (void)backAnimationX:(CGFloat)x Y:(CGFloat)y {
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    _placeholderLabel.font = kPlaceholderNormalFontSize;
    _placeholderLabel.textColor = kPlaceholderNormalColor;
    
    [UIView animateWithDuration:0.15f animations:^{
        moveY += self->_placeholderLabel.frame.size.height/2 + kYLength;
        moveX += kXLength;
        self->_placeholderLabel.center = CGPointMake(moveX, moveY);
        self->_isMoved = NO;
        self->_lineLayer.bounds = CGRectMake(0, 0, 0, kLineViewHeight);
        self->_lineView.backgroundColor = kPlaceholderNormalColor;
    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}
@end
