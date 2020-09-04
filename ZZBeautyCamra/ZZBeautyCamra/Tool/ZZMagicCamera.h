//
//  ZZMagicCamera.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import GPUImage;



typedef NS_ENUM(NSInteger,ZZMagicCaptureType){
    ZZMagicCaptureTypeStill = 0,
    ZZMagicCaptureTypeVideo = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZZMagicCamera : UIView

@property (nonatomic,strong) GPUImageStillCamera *stillCamera;
@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong) GPUImageFilter *currentFilter;
@property (nonatomic,strong) GPUImageView *captrueView;

@property (nonatomic,assign) ZZMagicCaptureType captureType;

- (instancetype)initWithFrame:(CGRect)frame type:(ZZMagicCaptureType)captureType;

- (void)switchFilter:(id<GPUImageInput>)filter;

- (void)switchCamera;

- (void)zz_startCameraCapture;

- (void)zz_stopCameraCapture;

- (void)capturePhotoAsJPEGCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
