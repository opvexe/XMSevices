//
//  VideoPickerUtil.h
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImagePickerDelegate.h"

@interface VideoPickerUtil : NSObject

+ (VideoPickerUtil *)defaultPicker;

- (void)startPickerWithController:(UIViewController<ImagePickerDelegate> *)viewController title:(NSString *)title;

@property (nonatomic,weak) id<ImagePickerDelegate> delegate;


@end
