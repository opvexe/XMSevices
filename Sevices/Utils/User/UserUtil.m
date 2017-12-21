//
//  UserUtil.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UserUtil.h"

#define UserPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.archive"]

@implementation UserUtil

//账户信息存储
+ (BOOL)saveUser:(User *)user
{
    return [NSKeyedArchiver archiveRootObject:user toFile:UserPath];
}

//账户信息获取
+ (User *)getUser
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:UserPath];
}

//账户信息删除
+ (BOOL)deleteUser
{
    return [[NSFileManager defaultManager] removeItemAtPath:UserPath error:nil];
}

@end
