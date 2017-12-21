//
//  User.h
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

//准守NSCopying协议
@interface User : NSObject<NSCopying>

@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *name;
@property (nonatomic, assign) NSInteger countryId;
@property (nonatomic,copy) NSString *country;
@property (nonatomic,copy) NSString *communityName;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *createdTime;
@property (nonatomic, assign) NSInteger isFullInfo;     //判断用户信息是否填写完整，如果否，需要跳转到补全信息页面
@property (nonatomic,assign) BOOL isOnline;  //yes:表示在线 no:表示离线
@property (nonatomic,copy) NSString *phone;  //手机号

@end
