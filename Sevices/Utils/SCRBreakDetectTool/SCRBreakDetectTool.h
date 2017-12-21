//
//  SCRBreakDetectTool.h
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 检测设备是否越狱工具类
 */

@interface SCRBreakDetectTool : NSObject

/**
 * 判断当前设备是否越狱
 */
+ (BOOL)detectCurrentDeviceIsJailbroken;


@end
