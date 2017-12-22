//
//  TSM_View.m
//  TSMDefine
//
//  Created by jieku on 2017/5/7.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import "XMView.h"
#import "XMButton.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FontPingFangSC(Size) [UIFont fontWithName:@"PingFangSC-Regular" size:Size]

@implementation XMView

-(void)initVipPrivilegeTtile:(NSArray *)title vipIconImage:(NSArray *)iconImageView{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (title.count>0) {
        [title enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XMButton *btn = [XMButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:obj forState:UIControlStateNormal];
            [btn setTitle:obj forState:UIControlStateSelected];
            [btn setTitle:obj forState:UIControlStateDisabled];
            [btn setTitle:obj forState:UIControlStateHighlighted];
            [btn setTitleColor:UIColorFromRGB(0x557b9a) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x557b9a) forState:UIControlStateDisabled];
            [btn setTitleColor:UIColorFromRGB(0x557b9a) forState:UIControlStateHighlighted];
            [btn setTitleColor:UIColorFromRGB(0x9367ff) forState:UIControlStateSelected];
            [btn.titleLabel setFont:FontPingFangSC(12)];
            [btn setImage:[UIImage imageNamed:iconImageView[idx]] forState:UIControlStateNormal];
            [btn setImage: [UIImage imageNamed:iconImageView[idx]] forState:UIControlStateHighlighted];
            btn.tag = 100+idx;
            [btn addTarget:self action:@selector(dothings:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            
            float width  = ([UIScreen mainScreen].bounds.size.width-80-10)/3;
            float height = width;
            obj.frame = CGRectMake((idx%3) * (width+5), (idx/3)* (width+5), height, height);
        }
    }];
}

-(void)dothings:(UIButton *)sender{
    if (self.PrivilegeVipBlock) {
        self.PrivilegeVipBlock(sender);
    }
}

@end
