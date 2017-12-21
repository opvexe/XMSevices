//
//  ImagePickerDelegate.h
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ImagePickerDelegateType) {
    ImagePickerDelegateImage = 0,
    ImagePickerDelegateVideo = 1,
};

@protocol ImagePickerDelegate <NSObject>
- (void)imagePickerDidFinishedWithInfo:(NSDictionary *)info image:(UIImage *) thumIamge file:(NSURL *) url type:(ImagePickerDelegateType) type;
@end
