//
//  VideoPickerUtil.m
//  Sevices
//
//  Created by Facebook on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "VideoPickerUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AlertUtil.h"

@interface VideoPickerUtil ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation VideoPickerUtil

+ (VideoPickerUtil *)defaultPicker
{
    static VideoPickerUtil *utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[self alloc] init];
    });
    return utils;
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}
- (void)startPickerWithController:(UIViewController<ImagePickerDelegate> *)viewController title:(NSString *)title
{
    self.delegate = viewController;
    //Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    //设置媒体类型为public.movie
    self.imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    
    __block UIImagePickerControllerSourceType sourceType ;
    __block NSInteger tag = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[AlertUtil shareInstance] showSheet:title.length > 0 ? title : @"添加视频" message:nil cancelTitle:@"取消" titleArray:@[@"拍摄",@"从手机相册选择"] viewController:viewController confirm:^(NSInteger buttonTag) {
            switch (buttonTag) {
                case 0:
                    //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    tag = 0;
                    break;
                case 1:
                    //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    tag = 1;
                    break;
                default:
                    //取消
                    return;
            }
            self.imagePicker.sourceType = sourceType;
            if(tag == 0){
                /* 如果是录像*/
                self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
                self.imagePicker.videoMaximumDuration = 30.0f; //录像最长时间
            }
            [viewController presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }
    else{
        [[AlertUtil shareInstance] showSheet:@"添加视频" message:nil cancelTitle:@"取消" titleArray:@[@"从手机相册选择"] viewController:viewController confirm:^(NSInteger buttonTag) {
            switch (buttonTag) {
                case 0:
                    //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    break;
                    
                default:
                    //取消
                    return;
            }
            self.imagePicker.sourceType = sourceType;
            [viewController presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }
}

#pragma mark - delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        
        //视频录像的URL
        //UIImagePickerControllerMediaURL
        //原件的URL，从本地选取的才有，也就是说拍照和录像都不存在这个
        //UIImagePickerControllerReferenceURL
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSURL *newVideoUrl = [NSURL fileURLWithPath:[self getVideoTempPath]]; //一般.mp4
//        [MBProgressHUD showHUDAddedTo:((UIViewController *)self.delegate).view animated:YES];
        
        UIImage *thumImage = [self thumbnailImageForVideo:videoURL atTime:1];
        [self convertVideoQuailtyWithInputURL:videoURL outputURL:newVideoUrl callback:^(NSURL *fileUrl, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat duration = [self getVideoLength:newVideoUrl];
                NSLog(@"时长：%f",duration);
                if(duration > 30){
                    [self cutVideosAtFileURLs:fileUrl startSecond:0 lengthSeconds:30 callback:^(NSURL *cutUrl, BOOL success) {
//                        [MBProgressHUD hideHUDForView:((UIViewController *)self.delegate).view animated:YES];
                        [self.delegate imagePickerDidFinishedWithInfo:info image:thumImage file:cutUrl type:ImagePickerDelegateVideo];
                    }];
                }else{
//                    [MBProgressHUD hideHUDForView:((UIViewController *)self.delegate).view animated:YES];
                    [self.delegate imagePickerDidFinishedWithInfo:info image:thumImage file:newVideoUrl type:ImagePickerDelegateVideo];
                }
            });
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

#pragma mark ---- 获取图片第一帧
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}


//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}//此方法可以获取视频文件的时长。



- (void)cutVideosAtFileURLs:(NSURL *)fileURL startSecond:(CGFloat)seconds lengthSeconds:(CGFloat)length callback:(void(^)(NSURL *fileUrl,BOOL success))callback{
    
    AVAsset *avAsset = [AVAsset assetWithURL:fileURL];
    CMTime assetTime = [avAsset duration];
    Float64 duration = CMTimeGetSeconds(assetTime);
    //    NSLog(@"视频时长 %f\n",duration);
    if(length>duration){
        length=duration;
        seconds=0;
    }else if(seconds>duration ||(seconds+length)>duration){
        seconds=duration-length;
    }else if(length<=0){
        length=duration;
        seconds=0;
    }
    
    AVMutableComposition *avMutableComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *avMutableCompositionTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    
    //前面的是开始时间,后面是裁剪多长 (我这裁剪的是从第二秒开始裁剪，裁剪2.55秒时长.)
    //    [avMutableCompositionTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(2.0f, 30), CMTimeMakeWithSeconds(2.55f, 30))
    //                                       ofTrack:avAssetTrack
    //                                        atTime:kCMTimeZero
    //                                         error:&error];
    
    AVAssetTrack *avAssetTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    
    NSError *error = nil;
    [avMutableCompositionTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(seconds, length), CMTimeMakeWithSeconds(length, length))
                                       ofTrack:avAssetTrack
                                        atTime:kCMTimeZero
                                         error:&error];
    
    NSArray *arr=[avAsset tracksWithMediaType:AVMediaTypeAudio];
    if(arr!=nil && arr.count>0){
        AVMutableCompositionTrack *avAudioMutableCompositionTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        // 没有音频会报空指针
        AVAssetTrack *audioTrack = [arr objectAtIndex:0];
        [avAudioMutableCompositionTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(seconds, length), CMTimeMakeWithSeconds(length, 30))
                                                ofTrack:audioTrack
                                                 atTime:kCMTimeZero
                                                  error:&error];
    }
    
    
    
    AVMutableVideoComposition *avMutableVideoComposition = [AVMutableVideoComposition videoComposition];
    // 这个视频大小可以由你自己设置。比如源视频640*480.而你这320*480.最后出来的是320*480这么大的，640多出来的部分就没有了。并非是把图片压缩成那么大了。
    //如果c是-1，代表旋转，tx代码偏移量，与宽相同
    //    WSLog(@"a:%f  b:%f  c:%f  d:%f  tx:%f ty:%f",avAssetTrack.preferredTransform.a,avAssetTrack.preferredTransform.b,avAssetTrack.preferredTransform.c,avAssetTrack.preferredTransform.d,avAssetTrack.preferredTransform.tx,avAssetTrack.preferredTransform.ty);
    //    WSLog(@"%@",NSStringFromCGSize(avAssetTrack.naturalSize));
    CGSize renderSize=CGSizeMake(0,0);
    if(avAssetTrack.preferredTransform.c==-1){
        //        avMutableVideoComposition.renderSize = CGSizeMake(avAssetTrack.naturalSize.height, avAssetTrack.naturalSize.width);
        renderSize=CGSizeMake(avAssetTrack.naturalSize.height, avAssetTrack.naturalSize.width);
    }else{
        //        avMutableVideoComposition.renderSize = avAssetTrack.naturalSize;
        renderSize = avAssetTrack.naturalSize;
    }
    CGFloat renderWidth=0;
    if(renderSize.width<renderSize.height){
        renderWidth=renderSize.width;
    }else{
        renderWidth=renderSize.height;
    }
    //    if(renderWidth>640){
    //        renderWidth=640;
    //    }
    CGFloat rate;
    rate = renderWidth/ MIN(avAssetTrack.naturalSize.width, avAssetTrack.naturalSize.height);
    
    CGAffineTransform layerTransform = CGAffineTransformMake(avAssetTrack.preferredTransform.a, avAssetTrack.preferredTransform.b, avAssetTrack.preferredTransform.c,avAssetTrack.preferredTransform.d, avAssetTrack.preferredTransform.tx * rate, avAssetTrack.preferredTransform.ty * rate);
    
    if (renderSize.width<renderSize.height) {
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(avAssetTrack.naturalSize.width - avAssetTrack.naturalSize.height+25.5) / 2.0));//向上移动取中部影响
    }else
    {
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1,-[UIScreen mainScreen].bounds.size.width/1.5,0));//向右移动取中部影响
    }
    
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
    
    
    
    avMutableVideoComposition.renderSize = CGSizeMake(renderWidth, renderWidth);
    avMutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    // 这句话暂时不用理会，我正在看是否能添加logo而已。
    //    [self addDataToVideoByTool:avMutableVideoComposition.animationTool];
    
    AVMutableVideoCompositionInstruction *avMutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [avMutableVideoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, [avMutableComposition duration])];
    
    AVMutableVideoCompositionLayerInstruction *avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:avAssetTrack];
    //    [avMutableVideoCompositionLayerInstruction setTransform:avAssetTrack.preferredTransform atTime:kCMTimeZero];
    [avMutableVideoCompositionLayerInstruction setTransform:layerTransform atTime:kCMTimeZero];
    avMutableVideoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];
    avMutableVideoComposition.instructions = [NSArray arrayWithObject:avMutableVideoCompositionInstruction];
    
    
    
    NSString *v_strSavePath=[self getVideoMergeFilePathString];
    //get save path
    NSURL *mergeFileURL = [NSURL fileURLWithPath:v_strSavePath];
    AVAssetExportSession *avAssetExportSession = [[AVAssetExportSession alloc] initWithAsset:avMutableComposition presetName:AVAssetExportPresetMediumQuality];
    if(renderSize.width<640){
        avAssetExportSession = [[AVAssetExportSession alloc] initWithAsset:avMutableComposition presetName:AVAssetExportPresetPassthrough];
        if(avAssetTrack.preferredTransform.c==-1){
            avAssetExportSession = [[AVAssetExportSession alloc] initWithAsset:avMutableComposition presetName:AVAssetExportPresetHighestQuality];
        }
    }
    [avAssetExportSession setVideoComposition:avMutableVideoComposition];
    [avAssetExportSession setOutputURL:mergeFileURL];
    [avAssetExportSession setOutputFileType:AVFileTypeMPEG4];
    [avAssetExportSession setShouldOptimizeForNetworkUse:YES];
    [avAssetExportSession exportAsynchronouslyWithCompletionHandler:^(void){
        if(avAssetExportSession.status==AVAssetExportSessionStatusCompleted){
            // 想做什么事情在这个做
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(callback){
                    callback(mergeFileURL,YES);
                }
            });
        }
    }];
    if (avAssetExportSession.status != AVAssetExportSessionStatusCompleted){
        if(avAssetExportSession.error!=nil && avAssetExportSession.status==4){
            if(callback){
                callback(mergeFileURL,NO);
            }
        }
    }
}


- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                                callback:(void(^)(NSURL *fileUrl,BOOL success))callback
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    // NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 
                 if(callback){
                     callback(outputURL,YES);
                 }
                 
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
}


- (NSString *)getVideoMergeFilePathString
{
    
    NSString *fileName = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSString stringWithFormat:@"modify.mp4"] lastPathComponent]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:fileName error:&error] == NO) {
            NSLog(@"removeitematpath %@ error :%@", fileName, error);
        }
    }
    
    
    return fileName;
}

-(NSString *)getVideoTempPath{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4",[self requireCurrentTimeSwamp]];
    
    return path;
}

#pragma mark - 获取当前的时间戳
- (NSString *)requireCurrentTimeSwamp
{
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
}

-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    
    //    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(time, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    return thumbnailImage;
}
@end
