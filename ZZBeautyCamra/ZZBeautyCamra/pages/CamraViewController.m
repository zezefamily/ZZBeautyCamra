
//
//  CamraViewController.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//
#define Content_Size CGSizeMake(SCREEN_WIDTH, 220)


#import "CamraViewController.h"
#import "GPUImage.h"

#import "CamraTopBar.h"
#import "CameraBottomBar.h"
#import "ZZPresentationController.h"
#import "ImageFilterViewController.h"
#import "ZZMagicCamera.h"
#import "CustomFilters.h"

@interface CamraViewController ()<CamraTopBarDelegate,CameraBottomBarDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,ImageFilterViewControllerDelegate>
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
}


#pragma mark - ImageFilterViewControllerDelegate
- (void)imageFilterVCUpdateFilter:(GPUImageOutput<GPUImageInput> *)filter
{
    [self.magicCamera switchFilter:filter];
}

-(void)takePhoto
{
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc]init];
//    [stillCamera addTarget:filter];
//    [filter addTarget:_mGPUImgView];
//    _mFilter = filter;
    [self.magicCamera switchFilter:filter];
    
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
}

- (void)addFilterCamera
{
    self.magicCamera = [[ZZMagicCamera alloc]initWithFrame:self.view.bounds options:@{}];
    [self.view addSubview:self.magicCamera];
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
    if(index == 0){
        [self.magicCamera destroy];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (index == 1){
        [self.magicCamera switchCamera];
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
                ZZBeautyFilter *zzbeautyFilter = [[ZZBeautyFilter alloc]init];
                [self.magicCamera switchFilter:zzbeautyFilter];
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

@end
