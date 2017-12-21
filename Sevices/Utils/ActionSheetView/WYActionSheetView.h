//
//  WYActionSheetView.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYActionSheetView;
typedef void(^WYActionSheetViewClickBlock)(WYActionSheetView *sheetView, NSInteger index, NSString *title);
@interface WYActionSheetView : UIView
- (instancetype)initWithtitle:(NSString *)titleMessage titleImage:(NSString *)titleImage CancelTitle:(NSString *)cancelTitle OtherTitles:(NSArray *)otherTitles;

- (void)show;

-(void)showWithClickBlock:(WYActionSheetViewClickBlock)clickBlock;

-(void)setImage:(NSString *)image withTitle:(NSString *)title;
@end
