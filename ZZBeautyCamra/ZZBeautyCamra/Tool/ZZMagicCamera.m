//
//  ZZMagicCamera.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZMagicCamera.h"
#import <PhotosUI/PhotosUI.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface ZZMagicCamera ()
@property (nonatomic,strong) GPUImageStillCamera *stillCamera;
@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong) GPUImageFilter *currentFilter;
@property (nonatomic,strong) GPUImageView *captrueView;
@end

@implementation ZZMagicCamera

- (instancetype)initWithFrame:(CGRect)frame options:(id)options
{
    if(self == [super initWithFrame:frame]){
        [self loadGPUImageMoudle];
    }
    return self;
}

- (void)loadGPUImageMoudle
{
    self.captrueView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _captrueView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    _captrueView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [self addSubview:_captrueView];
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
//    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc]init];
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetMedium cameraPosition:AVCaptureDevicePositionFront];
    _stillCamera.horizontallyMirrorFrontFacingCamera = YES; //前置镜像
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;  //竖屏
    //第四步： addTarget 并开始处理startCameraCapture
    [_stillCamera addTarget:filter];
    [filter addTarget:_captrueView];
    [_stillCamera startCameraCapture]; // 开始捕获
}

- (void)switchFilter:(id<GPUImageInput>)filter
{
    //切换滤镜
    self.currentFilter = filter;
    [_stillCamera removeAllTargets];
    [_stillCamera addTarget:filter];
    [self.currentFilter addTarget:_captrueView];
}

//    //7.将图片通过PhotoKit add 相册中
//    [stillCamera capturePhotoAsJPEGProcessedUpToFilter:_mFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
//        UIImage * image = [UIImage imageWithData:processedJPEG];
//
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//
//            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:processedJPEG options:nil];
//
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//
//        }];
//        [self->stillCamera stopCameraCapture];
//    }];

- (void)switchCamera
{
    [self.stillCamera rotateCamera];
}

- (void)destroy
{
    [self.stillCamera stopCameraCapture];
}

@end
