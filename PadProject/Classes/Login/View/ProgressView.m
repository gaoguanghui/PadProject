//
//  ProgressView.m
//  PadProject
//
//  Created by SansiMac on 2018/5/24.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//https://www.jianshu.com/p/1fb973af1cb9
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //fillpath填充
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = rect.size.width/2;
    CGFloat centerX = CGRectGetWidth(rect)*0.5;
    CGFloat centerY = CGRectGetHeight(rect)*0.5;
    CGFloat startAngle = M_PI_2*3;
    CGFloat changeAngle = _progress*2*M_PI;
    CGFloat endAngle = changeAngle + startAngle;
    CGContextMoveToPoint(context, centerX, centerY);
    CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, NO);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
     CGContextClosePath(context);
    CGContextFillPath(context);
    */
    // strokepath填充
    /*
    CGFloat radius = rect.size.width/2-5;
    CGFloat centerX = CGRectGetWidth(rect)*0.5;
    CGFloat centerY = CGRectGetHeight(rect)*0.5;
    CGFloat startAngle = M_PI_2*3;
    CGFloat changeAngle = _progress*2*M_PI;
    CGFloat endAngle = changeAngle + startAngle;
    CGFloat totalAngle = M_PI_2*3 + M_PI*2;

    UIBezierPath * bezierPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    UIBezierPath * bezierPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:startAngle endAngle:totalAngle clockwise:YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 5);
    CGContextAddPath(context, bezierPath2.CGPath);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 5);
    CGContextAddPath(context, bezierPath1.CGPath);
    CGContextStrokePath(context);
    */
}


@end
