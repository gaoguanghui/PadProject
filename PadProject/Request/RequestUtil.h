//
//  RequestUtil.h
//  PadProject
//
//  Created by SansiMac on 2018/5/18.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUtil : NSObject
/**
 用户登录
 */
+ (void)requestLoginUserName:(NSString *)username Password:(NSString *)password andBlock:(void(^)(BOOL isSuccess, NSError *error))block;
/**
退出登录
*/
@end
