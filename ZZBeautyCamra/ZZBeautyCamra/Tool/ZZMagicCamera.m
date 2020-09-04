//
//  ZZMagicCamera.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZMagicCamera.h"

@interface ZZMagicCamera ()

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
//    _captrueView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
//    _captrueView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [self addSubview:_captrueView];
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
    self.currentFilter = filter;
    //AVCaptureSessionPresetMedium
    //AVCaptureSessionPreset1280x720
//    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
//    _stillCamera.horizontallyMirrorFrontFacingCamera = YES; //前置镜像
//    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;  //竖屏
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.horizontallyMirrorFrontFacingCamera = YES; //前置镜像
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;  //竖屏
    self.captureType = ZZMagicCaptureTypeVideo;
    //第四步： addTarget 并开始处理startCameraCapture
    [_videoCamera addTarget:filter];
    [filter addTarget:_captrueView];
//    [_stillCamera startCameraCapture]; // 开始捕获
}

- (void)zz_startCameraCapture
{
    if(self.captureType == ZZMagicCaptureTypeStill){
        [_stillCamera startCameraCapture]; // 开始捕获
    }else{
        [_videoCamera startCameraCapture];
    }
}
- (void)zz_stopCameraCapture
{
    if(self.captureType == ZZMagicCaptureTypeStill){
        [_stillCamera stopCameraCapture]; // 开始捕获
    }else{
        [_videoCamera stopCameraCapture];
    }
}

- (void)switchFilter:(id<GPUImageInput>)filter
{
    //切换滤镜
    self.currentFilter = filter;
//    [_stillCamera removeAllTargets];
//    [_stillCamera addTarget:filter];
    [self.currentFilter addTarget:_captrueView];
}

- (void)capturePhotoAsJPEGCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block
{
    [_stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.currentFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        if(block){
            block(processedJPEG,error);
        }
    }];
}

- (void)switchCamera
{
    [self.stillCamera rotateCamera];
}
- (void)destroy
{
    [self.stillCamera stopCameraCapture];
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

@end
