//
//  ZZMagicCamera.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZMagicCamera.h"
@interface ZZMagicCamera ()
{
    GPUImagePicture *_sourcePicture;
    GPUImageFilterGroup *_filterGroup;
    GPUImageUIElement *_inpuElement;
    GPUImageMovieWriter *movieWriter;
    NSURL *movieURL;
    CGRect captureFrame;
}
@end

@implementation ZZMagicCamera

- (instancetype)initWithFrame:(CGRect)frame type:(ZZMagicCaptureType)captureType;
{
    if(self == [super initWithFrame:frame]){
        self.captureType = captureType;
        [self loadGPUImageMoudle];
    }
    return self;
}

- (void)loadGPUImageMoudle
{
    self.captrueView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [self.captrueView setBackgroundColorRed:1 green:1 blue:1 alpha:1];
    _captrueView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
//    _captrueView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [self addSubview:_captrueView];
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
    self.currentFilter = filter;
    //AVCaptureSessionPresetMedium
    //AVCaptureSessionPreset1280x720
    self.imageCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    _imageCamera.horizontallyMirrorFrontFacingCamera = YES; //前置镜像
    _imageCamera.outputImageOrientation = UIInterfaceOrientationPortrait;  //竖屏
    //addTarget 并开始处理startCameraCapture
    [_imageCamera addTarget:filter];
    [filter addTarget:_captrueView];
    
    _filterGroup = [[GPUImageFilterGroup alloc]init];
}

- (void)zz_startCameraCapture
{
    [_imageCamera startCameraCapture];
}
- (void)zz_stopCameraCapture
{
    [_imageCamera stopCameraCapture]; // 结束捕获
}

- (void)switchFilter:(id<GPUImageInput>)filter
{
    //切换滤镜
    [_imageCamera removeAllTargets];
    [_imageCamera addTarget:filter];
    self.currentFilter = filter;
    [self.currentFilter addTarget:_captrueView];
}

- (void)capturePhotoAsJPEGCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block
{
    [_imageCamera capturePhotoAsJPEGProcessedUpToFilter:self.currentFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        if(block){
            block(processedJPEG,error);
        }
    }];
}

- (void)switchCamera
{
    [_imageCamera rotateCamera];
}
- (void)destroy
{
    [_imageCamera stopCameraCapture];
}

#pragma mark - 组合滤镜#测试
- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter group:(GPUImageFilterGroup *)group
{
    [group addFilter:filter];
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    NSInteger count = group.filterCount;
    if (count == 1){ //当group的filterCount = 1 时,
        group.initialFilters = @[newTerminalFilter];
        group.terminalFilter = newTerminalFilter;
    }else{
        GPUImageOutput<GPUImageInput> *terminalFilter = group.terminalFilter;
        NSArray *initialFilters = group.initialFilters;
        [terminalFilter addTarget:newTerminalFilter];
        group.initialFilters = @[initialFilters[0]];
        group.terminalFilter = newTerminalFilter;
    }
}
- (void)setCaptureType:(ZZMagicCaptureType)captureType
{
    _captureType = captureType;
}

- (void)changeCaptureViewScale:(NSString *)scaleType
{
    //@"9:16",@"3:4",@"1:1",@"Full"
    CGRect frame = CGRectZero;
    CGFloat width = SCREEN_WIDTH;
    CGFloat height;
    GPUImageFillModeType fillModeType = kGPUImageFillModePreserveAspectRatioAndFill;
    if([scaleType isEqualToString:@"Full"]){
        frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }else{
        if ([scaleType isEqualToString:@"9:16"]){
            height = width/9 * 16;
            frame = CGRectMake(0, (self.frame.size.height - height)/2, width, height);
        }else if([scaleType isEqualToString:@"3:4"]){
            height = width/3 * 4;
            frame = CGRectMake(0, (self.frame.size.height - height)/2, width, height);
        }else{ //1:1
            height = width;
            frame = CGRectMake(0, (self.frame.size.height - height)/2, width, height);
        }
    }
    captureFrame = frame;
    [UIView animateWithDuration:.2 animations:^{
        [self.captrueView setFrame:frame];
    }completion:^(BOOL finished) {
        [self.captrueView setFillMode:fillModeType];
    }];
}


- (void)magic_startRecording
{
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    movieURL = [NSURL fileURLWithPath:pathToMovie];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    movieWriter.encodingLiveVideo = YES;
    [self.currentFilter addTarget:movieWriter];
    self.imageCamera.audioEncodingTarget = self->movieWriter;
    [movieWriter startRecording];
}

- (void)magic_stopRecordWithHandler:(void(^)(NSURL *tempMovieURL))handler
{
    [self.currentFilter removeTarget:self->movieWriter];
    self.imageCamera.audioEncodingTarget = nil;
    [self->movieWriter finishRecording];
    if(handler){
        handler(movieURL);
    }
}

@end
