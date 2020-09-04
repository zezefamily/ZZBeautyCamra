
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

@interface CamraViewController ()<CamraTopBarDelegate,CameraBottomBarDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,ImageFilterViewControllerDelegate,CaptureImageResultViewControllerDelegate>
@property (nonatomic,strong) ZZMagicCamera *magicCamera;
@property (nonatomic,strong) CamraTopBar *cameraTopBar;
@property (nonatomic,strong) CameraBottomBar *cameraBottomBar;
@end

@implementation CamraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    [self addFilterCamera];
    [self addTopBar];
    
//    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////    filteredVideoView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:filteredVideoView];
//
//    GPUImageStillCamera *videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
//    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
////    videoCamera.horizontallyMirrorFrontFacingCamera = YES; //前置镜像
//
//    GPUImageSketchFilter *customFilter = [[GPUImageSketchFilter alloc]init];
//
//    // Add the view somewhere so it's visible
//    [videoCamera addTarget:customFilter];
//    [customFilter addTarget:filteredVideoView];
//
//    [videoCamera startCameraCapture];
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
    }else if (index == 2){ //拍照
        
    }else if (index == 3){ //摄像
        
    }
}
#pragma mark - CameraBottomBarDelegate
- (void)cameraBottomBarItemSelected:(NSInteger)index
{
    switch (index) {
        case 0: //美颜开关
        {
            static BOOL openBeauty = NO;
            if(!openBeauty){
//                GPUImageBeautifyFilter *zzbeautyFilter = [[GPUImageBeautifyFilter alloc]init];
//                [self.magicCamera switchFilter:zzbeautyFilter];
                
                
                
                UIImage *inputImage = [UIImage imageNamed:@"logo"];
                GPUImageAddBlendFilter *filter = [[GPUImageAddBlendFilter alloc]init];
                GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
                [sourcePicture processImage];
                [sourcePicture addTarget:filter];
//                [self.magicCamera.stillCamera removeAllTargets];
                [self.magicCamera.stillCamera addTarget:filter];
                [filter addTarget:self.magicCamera.captrueView];
                
                [self.magicCamera zz_startCameraCapture];
                
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
