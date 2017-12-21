//
//  CJXBarButtonItem.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "CJXBarButtonItem.h"
@interface CJXBarButtonItem ()
@property(nonatomic,strong)UIImageView *badValueImage;
@end

@implementation CJXBarButtonItem

//实现创建文字按钮
+ (instancetype)buttonWithTitle:(NSString *)buttonTitle target:(id)target selector:(SEL)sel
{
    //初始化
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeSystem];
    //动态计算按钮宽度
    CGSize buttonSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:FontPingFangSC(15)}];
    //限制按钮的最大宽度为（中文4个字的宽度：68）
    buttonSize.width = buttonSize.width + 15*2;
    
    barButtonItem.frame = CGRectMake(0, 0, buttonSize.width, Number(44));
    
    //按钮文字过长截断方式
    barButtonItem.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [barButtonItem setTitle:buttonTitle forState:UIControlStateNormal];
    //按钮字体颜色默认为白色
    barButtonItem.tintColor = UIColorFromRGB(0x909090);
    barButtonItem.titleLabel.font = FontPingFangSC(15);
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return barButtonItem;
}

//实现创建图标按钮
+ (instancetype)buttonWithImageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected target:(id)target selector:(SEL)sel
{
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    barButtonItem.frame = CGRectMake(12, 0, 30, 30);
    [barButtonItem setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [barButtonItem setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    barButtonItem.clipsToBounds = YES;
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}
+ (instancetype)BadValueButtonWithImageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected target:(id)target selector:(SEL)sel{
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    barButtonItem. badValueImage =[UIImageView new];
    barButtonItem. badValueImage = [[UIImageView alloc] init];
    barButtonItem. badValueImage.backgroundColor = TABARHIGHTLIGHTCOLOR;
    barButtonItem. badValueImage.layer.masksToBounds =YES;
    barButtonItem. badValueImage.layer.cornerRadius =3;
    barButtonItem. badValueImage.contentMode = UIViewContentModeScaleAspectFit;
    [barButtonItem addSubview: barButtonItem. badValueImage];
    [barButtonItem.badValueImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(barButtonItem.mas_top);
        make.right.mas_equalTo(barButtonItem.mas_right).offset(Number(6));
        make.size.mas_equalTo(CGSizeMake(Number(6), Number(6)));
    }];
    barButtonItem.badValueImage.hidden =YES;
    barButtonItem.frame = CGRectMake(12, 0, 44, 44);
    [barButtonItem setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [barButtonItem setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return barButtonItem;
}
-(void)setIsHideBadValue:(BOOL)isHideBadValue{
    _isHideBadValue = isHideBadValue;
    self.badValueImage.hidden =isHideBadValue;
}
//实现创建图标按钮
+ (instancetype)newbuttonWithImageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected target:(id)target selector:(SEL)sel
{
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    barButtonItem.frame = CGRectMake(0, 0, 22, 22);
    [barButtonItem setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [barButtonItem setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    barButtonItem.clipsToBounds = YES;
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}

+ (instancetype)buttonWithImageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected imageHightlight:(NSString *)imageHighlight target:(id)target selector:(SEL)sel
{
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    barButtonItem.frame = CGRectMake(0, 0, 44, 44);
    [barButtonItem setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [barButtonItem setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    [barButtonItem setImage:[UIImage imageNamed:imageHighlight] forState:UIControlStateHighlighted];
    barButtonItem.clipsToBounds = YES;
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}

+ (instancetype)buttonWithTitle:(NSString *)buttonTitle ImageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected target:(id)target selector:(SEL)sel
{
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    CGSize buttonSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}];
    //限制按钮的最大宽度为（中文4个字的宽度：68）
    buttonSize.width = buttonSize.width + 15*2;
    
    barButtonItem.frame = CGRectMake(0, 0, buttonSize.width, 44);
    
    [barButtonItem setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [barButtonItem setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateHighlighted];
    barButtonItem.imageView.contentMode = UIViewContentModeCenter;
    barButtonItem.clipsToBounds = YES;
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB(0xf0f0f0);
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = buttonTitle;
    [barButtonItem addSubview:label];
    
    return barButtonItem;
}

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor image:(NSString *)image target:(id)target selector:(SEL)sel
{
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    [barButtonItem setTitleColor:titleColor forState:UIControlStateNormal];
    barButtonItem.titleLabel.font = font;
    [barButtonItem setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    barButtonItem.backgroundColor = backgroundColor;
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target selector:(SEL)sel
{
    CJXBarButtonItem *barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    [barButtonItem setTitleColor:titleColor forState:UIControlStateNormal];
    barButtonItem.titleLabel.font = font;
    barButtonItem.backgroundColor = backgroundColor;
    [barButtonItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}


@end
