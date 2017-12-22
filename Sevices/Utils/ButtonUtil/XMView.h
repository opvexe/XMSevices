//
//  TSM_View.h
//  TSMDefine
//
//  Created by jieku on 2017/5/7.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMView : UIView

-(void)initVipPrivilegeTtile:(NSArray *)title vipIconImage:(NSArray *)iconImageView;

@property (nonatomic, copy)void(^PrivilegeVipBlock)(UIButton *sender);

@end
