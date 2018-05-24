//
//  LoginButtonView.m
//  PadProject
//
//  Created by SansiMac on 2018/5/18.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "LoginButtonView.h"

#define kButtonTitleColor [UIColor colorWithHexString:@"0x007AFF"]
#define kButtonColor [UIColor colorWithHexString:@"0x007AFF"]


@interface LoginButtonView ()

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *loadingLayer;
@property (nonatomic, strong) CAShapeLayer *clickCircleLayer;

@end

@implementation LoginButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMainView];
    }
    return self;
}
- (void)setupMainView {
    if (!_button) {
        _button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = self.bounds;
            [button setTitle:kButtonTitle forState:UIControlStateNormal];
            [button setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
            button.titleLabel.font = kButtonTitleFontSize;
            [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button;
        });
    }
    
    _shapeLayer = [self drawMask:self.bounds.size.height/2];
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = kButtonColor.CGColor;
    _shapeLayer.lineWidth = 2;
    [self.layer addSublayer:_shapeLayer];
    
    [self.layer addSublayer:self.maskLayer];
}

- (CAShapeLayer *)drawMask:(CGFloat)x {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = [self drawBezierPath:x].CGPath;
    return shapeLayer;
}
- (UIBezierPath *)drawBezierPath:(CGFloat)x {
    CGFloat radius = self.bounds.size.height/2-2;
    CGFloat right = self.bounds.size.width - x;
    CGFloat left = x;
    
    UIBezierPath *bezierPaht = [UIBezierPath bezierPath];
    bezierPaht.lineJoinStyle = kCGLineJoinRound;
    bezierPaht.lineCapStyle = kCGLineCapRound;
    [bezierPaht addArcWithCenter:CGPointMake(right, self.bounds.size.height/2) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    [bezierPaht addArcWithCenter:CGPointMake(left, self.bounds.size.height/2) radius:radius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:YES];
    [bezierPaht closePath];
    return bezierPaht;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.opacity = 0;
        _maskLayer.fillColor = kButtonColor.CGColor;
        _maskLayer.path = [self drawBezierPath:self.frame.size.width/2].CGPath;
    }
    return _maskLayer;
}

- (void)clickButton {
    if ([self.delegate performSelector:@selector(loginButtonViewActivated)]) {
        [self.delegate loginButtonViewActivated];
    }
    [self clickAnimation];
}
- (void)clickAnimation {
    CAShapeLayer *clickCircleLayer = [CAShapeLayer layer];
    clickCircleLayer.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 5, 5);
    clickCircleLayer.fillColor = kButtonColor.CGColor;
    clickCircleLayer.path = [self drawclickCircleBezierPath:0].CGPath;
    [self.layer addSublayer:clickCircleLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.25f;
    basicAnimation.toValue = (__bridge id)([self drawclickCircleBezierPath:(self.bounds.size.height - 10*2)/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [clickCircleLayer addAnimation:basicAnimation forKey:@"clickCircleAnimation"];
    _clickCircleLayer = clickCircleLayer;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(basicAnimation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickNextAnimation];
    });
}
- (void)clickNextAnimation {
    _clickCircleLayer.fillColor = [UIColor clearColor].CGColor;
    _clickCircleLayer.strokeColor = kButtonColor.CGColor;
    _clickCircleLayer.lineWidth = 10;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.25f;
    basicAnimation.toValue = (__bridge id)([self drawclickCircleBezierPath:(self.bounds.size.height - 10*2)].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.3;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = basicAnimation1.beginTime + basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    
    [_clickCircleLayer addAnimation:animationGroup forKey:@"clickCicrleAnimation1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationGroup.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startMaskAnimation];
    });
}
- (void)startMaskAnimation {
    _maskLayer.opacity = 0.5;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.2f;
    basicAnimation.toValue = (__bridge id)([self drawBezierPath:self.frame.size.height/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_maskLayer addAnimation:basicAnimation forKey:@"maskAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((basicAnimation.duration + 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAnimation];
    });
}
- (void)dismissAnimation {
    [self hideSubViews];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.2;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:self.frame.size.width/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.2;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    animationGroup.duration = basicAnimation1.beginTime+basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [_shapeLayer addAnimation:animationGroup forKey:@"dismissAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationGroup.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadingAnimation];
    });
}
- (void)loadingAnimation {
    _loadingLayer = [CAShapeLayer layer];
    _loadingLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _loadingLayer.fillColor = [UIColor clearColor].CGColor;
    _loadingLayer.strokeColor = kButtonColor.CGColor;
    _loadingLayer.lineWidth = 2;
    _loadingLayer.path = [self drawLoadingBezierPath].CGPath;
    [self.layer addSublayer:_loadingLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI*2);
    basicAnimation.duration = 0.3;
    basicAnimation.repeatCount = LONG_MAX;
    basicAnimation.removedOnCompletion = NO;
    [_loadingLayer addAnimation:basicAnimation forKey:@"loadingAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self waitForRequest];
    });
}
- (void)waitForRequest {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (void)removeAllAnimation {
    [self removeSubViews];
}

- (void)hideSubViews {
    _button.hidden = YES;
    [_clickCircleLayer removeFromSuperlayer];
    [_maskLayer removeFromSuperlayer];
    [_loadingLayer removeFromSuperlayer];
}

- (void)removeSubViews {
    [_button removeFromSuperview];
    [_clickCircleLayer removeFromSuperlayer];
    [_maskLayer removeFromSuperlayer];
    [_loadingLayer removeFromSuperlayer];
}

- (void)restoreSubViews {
    [_loadingLayer removeFromSuperlayer];
    _button.hidden = NO;
    
    _shapeLayer = [self drawMask:self.bounds.size.height/2];
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = kButtonColor.CGColor;
    _shapeLayer.lineWidth = 2;
    [self.layer addSublayer:_shapeLayer];
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.opacity = 0;
    _maskLayer.fillColor = kButtonColor.CGColor;
    _maskLayer.path = [self drawBezierPath:self.frame.size.width/2].CGPath;
    [self.layer addSublayer:_maskLayer];
}

- (UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return bezierPath;
}

- (UIBezierPath *)drawLoadingBezierPath {
    CGFloat radius = self.bounds.size.height/2 - 3;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:M_PI_2 endAngle:M_PI_2+M_PI_2 clockwise:YES];
    return bezierPath;
}
@end
