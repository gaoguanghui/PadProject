//
//  LoginViewModel.h
//  PadProject
//
//  Created by SansiMac on 2018/5/18.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject
@property (nonatomic,strong) RACSignal *loginSignal;
@property (nonatomic, copy  ) NSString *userName;
@property (nonatomic, copy  ) NSString *password;

@end
