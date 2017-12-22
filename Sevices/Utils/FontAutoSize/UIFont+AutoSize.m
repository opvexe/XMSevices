//
//  UIFont+AutoSize.m
//  FontSize
//
//  Created by jieku on 2017/5/8.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import "UIFont+AutoSize.h"
#import <objc/runtime.h>

@implementation UIFont (AutoSize)

+(void)load{
    
    //获取系统的方法
    Method originalMethod = class_getClassMethod([self class], @selector(systemFontOfSize:));
    
    Method newMethod  = class_getClassMethod([self class], @selector(xm_systemFontOfSize:));
    
    method_exchangeImplementations(newMethod, originalMethod);
    
}

+(UIFont *)xm_systemFontOfSize:(CGFloat)fontSize{
    
    return  [UIFont xm_systemFontOfSize:fontSize*[UIScreen mainScreen].bounds.size.width /375 ];
    
    
}

@end
