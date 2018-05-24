//
//  LoginViewModel.m
//  PadProject
//
//  Created by SansiMac on 2018/5/18.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (RACSignal *)loginSignal{
    if (!_loginSignal) {
        WEAKSELF
        _loginSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [RequestUtil requestLoginUserName:weakSelf.userName Password:weakSelf.password andBlock:^(BOOL isSuccess, NSError *error) {
                if (isSuccess) {
                    [subscriber sendNext:@"model"];
                    [subscriber sendCompleted];
                }else{
                    [subscriber sendNext:error];
                    [subscriber sendCompleted];
                }
                NSLog(@"===============asdfasdf123");
            }];
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }
    return _loginSignal;
}

@end
