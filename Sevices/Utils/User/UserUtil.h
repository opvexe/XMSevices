//
//  UserUtil.h
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface UserUtil : NSObject

/**
 账户信息存储
 
 @param user 账户信息
 @return 是否存储成功
 */
+ (BOOL)saveUser:(User *)user;

/**
 账户信息获取
 
 @return 账户信息
 */
+ (User *)getUser;

/**
 账户信息删除
 
 @return 是否删除成功
 */
+ (BOOL)deleteUser;

@end
