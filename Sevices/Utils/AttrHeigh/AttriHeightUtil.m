//
//  BaseUtil.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AttriHeightUtil.h"

@implementation AttriHeightUtil


#pragma mark - 生成随机数
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - 获取字符串的自适应高度
+(CGFloat)requireHeightWithWidth:(CGFloat)width text:(NSString *)text fontSize:(CGFloat)fontSize
{
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.height;
}

#pragma mark - 获取属性字符串的自适应高度
+(CGFloat)requireAttrHeightWithWidth:(CGFloat)width attrText:(NSAttributedString *)attrText
{
    return [attrText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

#pragma mark - 获取字符串的自适应宽度
+ (CGFloat)requireWidthWithHeight:(CGFloat)height text:(NSString *)text fontSize:(CGFloat)fontSize
{
    return [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
}

#pragma mark - 获取属性字符串自适应宽度
+ (CGFloat)requireAttrWidthWithHeight:(CGFloat)height attrText:(NSMutableAttributedString *)attrText
{
    return [attrText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
}

@end
