//
//  WYActionSheetView.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "WYActionSheetView.h"
#define   BtnHeight 44
#define Margin 6
#define cancelTag 9999

#define titleTag 10000

#define highImageColor 0xF2F2F2
#define TextLinkColor 0x07afb2

#define TextWhiteColor 0xffffff

#define  ListTitleFont  [UIFont systemFontOfSize:14]

#define SeparatorColor 0xE2E2E2

@interface WYActionSheetView()
{
    int _btnTag;
}
@property (nonatomic ,copy) WYActionSheetViewClickBlock clickBlock;
@property (nonatomic, weak) WYActionSheetView       *actionSheet;
@property (nonatomic, weak) UIView                  *sheetView;

@property(nonatomic, strong) UIWindow *window;
@end

@implementation WYActionSheetView

- (instancetype)initWithtitle:(NSString *)titleMessage titleImage:(NSString *)titleImage CancelTitle:(NSString *)cancelTitle OtherTitles:(NSArray *)otherTitles{
    self = [super init];
    
    WYActionSheetView *actionSheet = self;
    
    self.actionSheet               = actionSheet;

    // 黑色遮盖
    actionSheet.frame           = [UIScreen mainScreen].bounds;
    actionSheet.backgroundColor = [UIColor blackColor];
    _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _window.windowLevel = UIWindowLevelAlert + 1;
    [_window makeKeyAndVisible]; //关键语句,显示window
    [_window addSubview:actionSheet];
    actionSheet.alpha           = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverClick)];
    [actionSheet addGestureRecognizer:tap];
    
    // sheet
    UIView *sheetView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    sheetView.backgroundColor     = UIColorFromRGB(0xEDF0F2);
    sheetView.alpha               = 0.9;
    sheetView.layer.cornerRadius  = 5;
    sheetView.layer.masksToBounds = YES;
    
    [_window addSubview:sheetView];


    self.sheetView   = sheetView;
    sheetView.hidden = YES;
    
    _btnTag = 1;
    
    if(titleMessage){
        [self setupBtnWithTitle:titleMessage isTitle:YES imageName:titleImage] ;
    }
    
    if(otherTitles.count )
    {
        for (NSString *title in otherTitles) {
            
        [self setupBtnWithTitle:title isTitle:NO imageName:nil];
            
        }
    }
    
    CGRect sheetViewF = sheetView.frame;
    
    if(cancelTitle!=nil){
        sheetViewF.size.height = BtnHeight * _btnTag + Margin;
    }else{
        sheetViewF.size.height = BtnHeight * (_btnTag-1);
    }
    sheetView.frame = sheetViewF;
    
    if(cancelTitle!=nil){
        // 取消按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, sheetView.frame.size.height - BtnHeight, SCREEN_WIDTH, BtnHeight)];
        [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(highImageColor)] forState:UIControlStateHighlighted];
        [btn setTitle:cancelTitle forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
        btn.titleLabel.font     = FontPingFangSC(14);
        btn.tag                 = cancelTag;
        btn.layer.cornerRadius  = 5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetView addSubview:btn];
    }
    return actionSheet;
}
#pragma private function
- (void)setupBtnWithTitle:(NSString *)title isTitle:(BOOL) isTitle imageName:(NSString *)image {
    // 创建按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnHeight * (_btnTag - 1) , SCREEN_WIDTH, BtnHeight)];
    [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(highImageColor)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateDisabled];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];

    [btn setTitleColor: UIColorFromRGB(0x777777) forState:UIControlStateNormal];

    if(isTitle){
        btn.titleLabel.font = FontPingFangSC(14);
        btn.enabled         = NO;
        btn.tag             = titleTag;
    }else{
        btn.titleLabel.font = FontPingFangSC(14);
        [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = _btnTag;
    }
    btn.layer.cornerRadius  = 5;
    btn.layer.masksToBounds = YES;
    btn.centerX             = self.sheetView.width *0.5;
    [self.sheetView addSubview:btn];

    // 最上面画分割线
    UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColorFromRGB(SeparatorColor);
    [btn addSubview:line];
    _btnTag ++;
}
- (void)coverClick{
    CGRect sheetViewF   = self.sheetView.frame;
    sheetViewF.origin.y = SCREEN_HEIGHT;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame   = sheetViewF;
        self.actionSheet.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.actionSheet removeFromSuperview];
        [self.sheetView removeFromSuperview];
    }];
}
// button的点击事件
- (void)sheetBtnClick:(UIButton *)btn{
    
    if (btn.tag == cancelTag) {
        [self coverClick];
        return;
    }
    if (self.clickBlock) {
        self.clickBlock(self,btn.tag,btn.titleLabel.text);
    }
    [self coverClick];
}
- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma public function
-(void)showWithClickBlock:(WYActionSheetViewClickBlock)clickBlock{
    
    [self show];
    self.clickBlock = clickBlock;
    
}
- (void)show{
    
    self.sheetView.hidden = NO;
    CGRect sheetViewF     = self.sheetView.frame;
    sheetViewF.origin.y   = SCREEN_HEIGHT;
    self.sheetView.frame  = sheetViewF;
    
    CGRect newSheetViewF   = self.sheetView.frame;
    newSheetViewF.origin.y = SCREEN_HEIGHT - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.sheetView.frame = newSheetViewF;
        
        self.actionSheet.alpha = 0.3;
    }];
}

-(void)setImage:(NSString *)image withTitle:(NSString *)title{
    
    [self.sheetView.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
            
            UIButton  *button = (UIButton *)obj;
            
            if ([button.titleLabel.text isEqualToString:title]) {
                [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                 *stop  =YES;
            }
        }
        
        
    }];
    
}
-(void)dealloc{

    _window  =nil;
    
}
@end
