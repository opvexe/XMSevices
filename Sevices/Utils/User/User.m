//
//  User.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "User.h"

@implementation User

//+(NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{@"ID":@"id"};
//}



//归档：说明对象哪些属性写入沙盒
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.communityName forKey:@"communityName"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
    
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeBool:self.isOnline forKey:@"isOnline"];
}

//反归档：说明对象的哪些属性从沙盒里取出来
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.uid = [aDecoder decodeIntegerForKey:@"uid"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.communityName = [aDecoder decodeObjectForKey:@"communityName"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
        
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.isOnline = [aDecoder decodeBoolForKey:@"isOnline"];
        
    }
    return self;
}

@end
