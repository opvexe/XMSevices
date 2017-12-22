//
//  TSM_Button.m
//  TSMDefine
//
//  Created by jieku on 2017/5/7.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import "XMButton.h"

@implementation XMButton

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2
    ;
    center.y = self.imageView.frame.size.height/2;
    
    self.imageView.center  = center;
    
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame= newFrame;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


@end
