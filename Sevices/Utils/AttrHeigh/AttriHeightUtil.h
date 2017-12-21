//
//  BaseUtil.h
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AttriHeightUtil : NSObject


/**
 生成随机数
 
 @param from 左侧区间
 @param to 右侧区间
 @return NSInteger
 */
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;

/**
 获取字符串高度
 
 @param width 宽度
 @param text 文本
 @param fontSize 字号
 @return CGFloat
 */
+ (CGFloat)requireHeightWithWidth:(CGFloat)width
                             text:(NSString *)text
                         fontSize:(CGFloat)fontSize;


/**
 获取属性字符串高度
 
 @param width 宽度
 @param attrText 属性文本
 @return CGFloat
 */
+(CGFloat)requireAttrHeightWithWidth:(CGFloat)width
                            attrText:(NSAttributedString *)attrText;


/**
 获取字符串宽度
 
 @param height 宽度
 @param text 文本
 @param fontSize 字号
 @return CGFloat
 */
+ (CGFloat)requireWidthWithHeight:(CGFloat)height
                             text:(NSString *)text
                         fontSize:(CGFloat)fontSize;


/**
 获取属性字符串高度
 
 @param height 宽度
 @param attrText 属性文本
 @return CGFloat
 */
+ (CGFloat)requireAttrWidthWithHeight:(CGFloat)height
                             attrText:(NSAttributedString *)attrText;
@end
