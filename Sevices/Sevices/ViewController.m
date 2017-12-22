//
//  ViewController.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ViewController.h"
#import "AudioConverter.h"
#import "XMView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSString *wavSavePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *name = [NSString stringWithFormat:@"play.wav"];
    wavSavePath=[wavSavePath stringByAppendingPathComponent:name];
    [AudioConverter convertAmrToWavAtPath:@"path -autdo" wavSavePath:wavSavePath asynchronize:NO completion:^(BOOL success, NSString * _Nullable resultPath) {
        if (success) {
        }
    }];
    
    
    
    
    
    XMView  *vipPrivilege = [[XMView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
    [vipPrivilege initVipPrivilegeTtile:@[@"专属标识",@"访客记录",@"视频和图片",@"VIP专属推荐",@"访客记录"] vipIconImage:@[@"icon-zhuanshu",@"icon-fangkejilu",@"icon-mianfei",@"icon-VIPzhuanshu",@"icon-fangke"]];
    __weak typeof(self)weakSelf =self;
    vipPrivilege.PrivilegeVipBlock = ^(UIButton *sender) {
        @try {
            switch (sender.tag-100) {
                case 0:
                {
                    NSLog(@"点击了第一个");
                }
                    break;
                    
                default:
                    break;
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        } @finally {
            
        }
    };
    [self.view addSubview:vipPrivilege];
    
    [self addLineBtn];
}

- (void)addLineBtn {                //给button 添加下划线
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor yellowColor];
    btn.frame = CGRectMake(200, 300, 100, 30);
    [btn setTitle:@"按钮加下划线" forState:UIControlStateNormal];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"按钮加下划线"];
    NSRange strRange1 = {0,[str1 length]};
    //设置下划线范围
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [str1 addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:strRange1];
    [btn setAttributedTitle:str1 forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
