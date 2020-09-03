//
//  SimpleVideoViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/3.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "SimpleVideoViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <PhotosUI/PhotosUI.h>
@interface SimpleVideoViewController ()
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
}
@end

@implementation SimpleVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];

        videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        videoCamera.horizontallyMirrorFrontFacingCamera = NO;
        videoCamera.horizontallyMirrorRearFacingCamera = NO;

        filter = [[GPUImageSepiaFilter alloc] init];
      
    //    filter = [[GPUImageTiltShiftFilter alloc] init];
    //    [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:0.65];
    //    [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:0.85];
    //    [(GPUImageTiltShiftFilter *)filter setBlurSize:1.5];
    //    [(GPUImageTiltShiftFilter *)filter setFocusFallOffRate:0.2];
        
    //    filter = [[GPUImageSketchFilter alloc] init];
    //    filter = [[GPUImageColorInvertFilter alloc] init];
    //    filter = [[GPUImageSmoothToonFilter alloc] init];
    //    GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRightFlipVertical];
        
        [videoCamera addTarget:filter];
    GPUImageView *filterView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:filterView];
    //    filterView.fillMode = kGPUImageFillModeStretch;
    //    filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        // Record a movie for 10 s and store it in /Documents, visible via iTunes file sharing
        
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1080.0, 1920.0)];
        [filter addTarget:movieWriter];
        [filter addTarget:filterView];
        
        [videoCamera startCameraCapture];
        
        double delayToStartRecording = 0.5;
        dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
        dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Start recording");

            self->videoCamera.audioEncodingTarget = self->movieWriter;
            [self->movieWriter startRecording];

    //        NSError *error = nil;
    //        if (![videoCamera.inputCamera lockForConfiguration:&error])
    //        {
    //            NSLog(@"Error locking for configuration: %@", error);
    //        }
    //        [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
    //        [videoCamera.inputCamera unlockForConfiguration];

            double delayInSeconds = 10.0;
            dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){

                [self->filter removeTarget:self->movieWriter];
                self->videoCamera.audioEncodingTarget = nil;
                [self->movieWriter finishRecording];
                NSLog(@"Movie completed");
//                PHPhotoLibrary *library0 = [PHPhotoLibrary sharedPhotoLibrary];
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:movieURL])
                {
                    [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{

                             if (error) {
                                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Video Saving Failed: %@",error] preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                 [alert addAction:enterAction];
                                 [self presentViewController:alert animated:YES completion:nil];
                             } else {
                                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Video Saving Success" preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                 [alert addAction:enterAction];
                                 [self presentViewController:alert animated:YES completion:nil];
                             }
                         });
                     }];
                }

    //            [videoCamera.inputCamera lockForConfiguration:nil];
    //            [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
    //            [videoCamera.inputCamera unlockForConfiguration];
            });
        });
}


@end
