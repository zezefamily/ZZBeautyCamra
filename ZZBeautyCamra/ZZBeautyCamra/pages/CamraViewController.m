
//
//  CamraViewController.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "CamraViewController.h"
#import "GPUImage.h"

#import "CamraTopBar.h"
#import "CameraBottomBar.h"
#import "ZZPresentationController.h"
#import "ImageFilterViewController.h"
#import "ZZMagicCamera.h"

@interface CamraViewController ()<CamraTopBarDelegate,CameraBottomBarDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>
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
    [self demo1];
    [self addTopBar];
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

- (void)demo1
{

    self.magicCamera = [[ZZMagicCamera alloc]initWithFrame:self.view.bounds options:nil];
    [self.view addSubview:self.magicCamera];
}

- (void)addTopBar
{
    CGRect topBarFrame;
    if(kIsBangsScreen){
        topBarFrame =  CGRectMake(0, 44, SCREEN_WIDTH, 44);
    }else{
        topBarFrame =  CGRectMake(0, 20, SCREEN_WIDTH, 44);
    }
    CamraTopBar *cameraTopBar = [[CamraTopBar alloc]initWithFrame:topBarFrame];
    cameraTopBar.delegate = self;
    [self.view addSubview:cameraTopBar];
    self.cameraTopBar = cameraTopBar;
    
    CameraBottomBar *bottomBar = [[CameraBottomBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 70)];
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
    self.cameraBottomBar = bottomBar;
}

#pragma mark - CamraTopBarDelegate
- (void)camraTopBarItemDidSelected:(NSInteger)index
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - CameraBottomBarDelegate
- (void)cameraBottomBarItemSelected:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [self takePhoto];
        }
            break;
        case 2:
        {
            ImageFilterViewController *imgFilterVC = [[ImageFilterViewController alloc]init];
            imgFilterVC.modalPresentationStyle = UIModalPresentationCustom;
            imgFilterVC.transitioningDelegate = self;
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
    presentationController.contentSize = CGSizeMake(SCREEN_WIDTH, 200);
    return presentationController;
}

@end
