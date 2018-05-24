//
//  RequestUtil.m
//  PadProject
//
//  Created by SansiMac on 2018/5/18.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "RequestUtil.h"

@implementation RequestUtil
+ (void)requestLoginUserName:(NSString *)username Password:(NSString *)password andBlock:(void(^)(BOOL isSuccess, NSError *error))block{
    block(YES, nil);
    /*
    //可能有加密  token验证  等等
    NSDictionary * paramsDic = @{};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:@"url链接" parameters:paramsDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * returnDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //处理得到模型
        block(YES, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //可以对error进行处理
        block(NO, error);
    }];
     */
}
@end
