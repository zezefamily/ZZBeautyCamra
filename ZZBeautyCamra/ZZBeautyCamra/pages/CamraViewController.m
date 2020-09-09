
//
//  CamraViewController.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//  Dissolve blend
#define Content_Size CGSizeMake(SCREEN_WIDTH, 220)


#import "CamraViewController.h"
#import "GPUImage.h"

#import "CamraTopBar.h"
#import "CameraBottomBar.h"
#import "ZZPresentationController.h"
#import "ImageFilterViewController.h"
#import "ZZMagicCamera.h"
#import "CustomFilters.h"
#import "CaptureImageResultViewController.h"
#import "PreviewViewController.h"
@interface CamraViewController ()<CamraTopBarDelegate,CameraBottomBarDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,ImageFilterViewControllerDelegate,CaptureImageResultViewControllerDelegate>
@property (nonatomic,strong) ZZMagicCamera *magicCamera;
@property (nonatomic,strong) CamraTopBar *cameraTopBar;
@property (nonatomic,strong) CameraBottomBar *cameraBottomBar;
@end

@implementation CamraViewController
{
    GPUImagePicture *sourcePicture;
    GPUImageUIElement *_inpuElement;
    GPUImageFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GPUImageFilter *filter = [[GPUImageFilter alloc]init];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.delegate = self;
    [self addFilterCamera];
    [self addTopBar];
}

#pragma mark - ImageFilterViewControllerDelegate
- (void)imageFilterVCUpdateFilter:(GPUImageFilter *)filter
{
    [self.magicCamera switchFilter:filter];
}

-(void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(ZZMagicCamera *) weakCamera = self.magicCamera;
    [self.magicCamera capturePhotoAsJPEGCompletionHandler:^(NSData * _Nonnull processedJPEG, NSError * _Nonnull error) {
        CaptureImageResultViewController *resultVC = [[CaptureImageResultViewController alloc]init];
        resultVC.resultImgData = processedJPEG;
        resultVC.delegate = weakSelf;
        resultVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:resultVC animated:NO completion:nil];
        [weakCamera zz_stopCameraCapture];
    }];
}

#pragma mark - CaptureImageResultViewControllerDelegate
- (void)captureImageResultViewDismiss:(CaptureImageResultViewController *)controller
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    [self.magicCamera zz_startCameraCapture];
}
- (void)captureImageResultViewCompleted:(CaptureImageResultViewController *)controller
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    [self.magicCamera zz_startCameraCapture];
}

//GPUImageCamera
- (void)addFilterCamera
{
    self.magicCamera = [[ZZMagicCamera alloc]initWithFrame:self.view.bounds type:ZZMagicCaptureTypeStill];
    [self.view addSubview:self.magicCamera];
    [self.magicCamera zz_startCameraCapture];
}

- (void)addTopBar
{
    CGRect topBarFrame;
    if(kIsBangsScreen){
        topBarFrame =  CGRectMake(0, 44, SCREEN_WIDTH, 40);
    }else{
        topBarFrame =  CGRectMake(0, 20, SCREEN_WIDTH, 40);
    }
    CamraTopBar *cameraTopBar = [[CamraTopBar alloc]initWithFrame:topBarFrame];
    cameraTopBar.delegate = self;
    [self.view addSubview:cameraTopBar];
    self.cameraTopBar = cameraTopBar;
    
    CameraBottomBar *bottomBar = [[CameraBottomBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 85, SCREEN_WIDTH, 60)];
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
    self.cameraBottomBar = bottomBar;
}

#pragma mark - CamraTopBarDelegate
- (void)camraTopBarItemDidSelected:(NSInteger)index
{
    if(index == 0){ //退出
        [self.magicCamera destroy];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (index == 1){ //前后摄像头切换
        [self.magicCamera switchCamera];
    }else if  (index == 2){ //拍照
        self.cameraBottomBar.captureType = 0;
        self.magicCamera.captureType = ZZMagicCaptureTypeStill;
    }else if (index == 3){ //摄像
        self.cameraBottomBar.captureType = 1;
        self.magicCamera.captureType = ZZMagicCaptureTypeVideo;
    }
}
#pragma mark - CameraBottomBarDelegate
- (void)cameraBottomBarRecordStatus:(NSInteger)status
{
    if(status == 0){ //开始录制
        [self.magicCamera magic_startRecording];
    }else{ //结束录制
        [self.magicCamera magic_stopRecordWithHandler:^(NSURL * _Nonnull tempMovieURL) {
            PreviewViewController *previewVC = [[PreviewViewController alloc]init];
            previewVC.videoURL = tempMovieURL;
            [self.navigationController pushViewController:previewVC animated:YES];
        }];
    }
}
- (void)cameraTopBarScaleChanged:(CGRect)rect scale:(nonnull NSString *)scale
{
    [self.magicCamera changeCaptureViewScale:scale];
    GPUImageCropFilter *cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:rect];
    [self.magicCamera switchFilter:cropFilter];
}
- (void)cameraBottomBarItemSelected:(NSInteger)index
{
    switch (index) {
        case 0: //美颜开关
        {
            static BOOL openBeauty = NO;
            if(!openBeauty){
                
                ZZBeautyFilter *zzbeautyFilter = [[ZZBeautyFilter alloc]init];
                [self.magicCamera switchFilter:zzbeautyFilter];
                
//                GPUImageCropFilter *cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0, 0, 1.0, 1.0)];
//                [self.magicCamera switchFilter:cropFilter];
//                return;
//                GPUImageJFAVoronoiFilter *jfa = [[GPUImageJFAVoronoiFilter alloc]init];
//                [jfa setSizeInPixels:CGSizeMake(124.0, 124.0)];
//                [self.magicCamera switchFilter:jfa];
                
//                UIImage *inputImage = [UIImage imageNamed:@"logo"];
//                WatermarkFilter *filter = [[WatermarkFilter alloc]init];
//                sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:NO];
//                [sourcePicture processImage];
//                [sourcePicture addTarget:filter];
//                [self.magicCamera switchFilter:filter];
                
                //添加GPUImageAlphaBlendFilter
//                GPUImageDissolveBlendFilter
//                GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc]init];
//                blendFilter.mix = 1.0;
//                //GPUImageUIElement
//                UIView *contentView = [[UIView alloc]initWithFrame:self.view.bounds];
//                contentView.backgroundColor = [UIColor clearColor];
//                UIImage *inputImage = [UIImage imageNamed:@"logo"];
//                UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
//                logoView.center = contentView.center;
//                [contentView addSubview:logoView];
//                logoView.image = inputImage;
//                logoView.hidden = NO;
//                _inpuElement = [[GPUImageUIElement alloc]initWithView:contentView];
//                [self.magicCamera.currentFilter addTarget:blendFilter];
//                [_inpuElement addTarget:blendFilter];
//                [blendFilter addTarget:self.magicCamera.captrueView];
//
//                __weak typeof(GPUImageUIElement *) weakUIElement = _inpuElement;
//                [self.magicCamera.currentFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *filter, CMTime frameTime) {
////                    logoView.hidden = NO;
//                    [weakUIElement updateWithTimestamp:frameTime];
//                }];
                
            }else{
                GPUImageFilter *normalFilter = [[GPUImageFilter alloc]init];
                [self.magicCamera switchFilter:normalFilter];
            }
            openBeauty = !openBeauty;
        }
            break;
        case 1: //拍照
        {
            [self takePhoto];
        }
            break;
        case 2: //滤镜
        {
            ImageFilterViewController *imgFilterVC = [[ImageFilterViewController alloc]init];
            imgFilterVC.modalPresentationStyle = UIModalPresentationCustom;
            imgFilterVC.transitioningDelegate = self;
            imgFilterVC.contentSize = Content_Size;
            imgFilterVC.delegate = self;
            [self presentViewController:imgFilterVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    ZZPresentationController *presentationController = [[ZZPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    presentationController.contentSize = Content_Size;
    return presentationController;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
