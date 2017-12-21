//
//  ZTextField.h
//  deerkids
//
//  Created by Facebook的Mac Air on 2017/9/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 自定义UITextField左侧视图类
 **/
@interface ZTextField : UITextField


/**
 设置ZTextField的左侧视图

 @param image 左侧视图
 @param padding 边距
 @return ZTextField对象
 */
- (instancetype)initWithImage:(UIImage *)image padding:(CGFloat)padding;

@end
