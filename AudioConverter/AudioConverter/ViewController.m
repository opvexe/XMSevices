//
//  ViewController.m
//  AudioConverter
//
//  Created by Facebook on 2017/12/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ViewController.h"
#import "AudioConverter.h"

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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
