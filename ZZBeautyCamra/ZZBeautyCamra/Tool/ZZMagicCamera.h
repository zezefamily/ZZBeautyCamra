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

@property (nonatomic,strong) GPUImageStillCamera *imageCamera;
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

- (void)changeCaptureViewScale:(NSString *)scaleType;

- (void)magic_startRecording;

//- (void)magic_stopRecordWithHandler:(void(^)(BOOL success,NSError * _Nullable error))handler;
- (void)magic_stopRecordWithHandler:(void(^)(NSURL *tempMovieURL))handler;

@end

NS_ASSUME_NONNULL_END
