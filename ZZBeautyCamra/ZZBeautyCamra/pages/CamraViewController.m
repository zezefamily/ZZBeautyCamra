
//
//  CamraViewController.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "CamraViewController.h"
#import "GPUImage.h"
//#import <PhotosUI/PhotosUI.h>
//#import <AssetsLibrary/ALAssetsLibrary.h>
#import "CamraTopBar.h"

@interface CamraViewController ()<CamraTopBarDelegate>
{
    GPUImageStillCamera *stillCamera;
    GPUImageFilter *grayFilter;
}
@property(strong,nonatomic) GPUImageVideoCamera *vCamera;
@property(strong,nonatomic) GPUImageStillCamera *mCamera;
@property(strong,nonatomic) GPUImageFilter *mFilter;
@property(strong,nonatomic) GPUImageView *mGPUImgView;


@property (nonatomic,strong) CamraTopBar *cameraTopBar;




@end

@implementation CamraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self demo1];
    
    [self addTopBar];
    //添加GPUImage
//    [self addFiterCamera];
    
    //添加一个按钮触发拍照
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-80)*0.5, self.view.bounds.size.height-120, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addFiterCamera
{
    //1.
    //第一个参数表示相片的尺寸，第二个参数表示前、后摄像头 AVCaptureDevicePositionFront/AVCaptureDevicePositionBack
    _mCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    
    //2.切换摄像头
    [_mCamera rotateCamera];
    
    //3.竖屏方向
    _mCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //4.设置滤镜对象
    GPUImageiOSBlurFilter *filter = [[GPUImageiOSBlurFilter alloc] init];
    
    //5.
    _mGPUImgView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mGPUImgView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [_mCamera addTarget:filter];
    [filter addTarget:_mGPUImgView];
    [self.view addSubview:_mGPUImgView];
    
    [self performSelector:@selector(doSomething) withObject:self afterDelay:3.0];
    
}

- (void)doSomething
{
    //6.
    [_mCamera startCameraCapture];
}

-(void)takePhoto{
    
    [stillCamera removeAllTargets];
//    [grayFilter removeAllTargets];
    GPUImageFilter *filter = [[GPUImageGrayscaleFilter alloc]init];
    [stillCamera addTarget:filter];
    [filter addTarget:_mGPUImgView];
//    [stillCamera startCameraCapture];
//    [filter notifyTargetsAboutNewOutputTexture];
//    [self.mCamera notifyTargetsAboutNewOutputTexture];
//    //7.将图片通过PhotoKit add 相册中
//    [_mCamera capturePhotoAsJPEGProcessedUpToFilter:_mFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//
//            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:processedJPEG options:nil];
//
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//
//        }];
//        //获取拍摄的图片
//        UIImage * image = [UIImage imageWithData:processedJPEG];
//    }];
    

}

- (void)demo1
{
    //第一步：创建预览View 即必须的GPUImageView
    self.mGPUImgView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mGPUImgView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    _mGPUImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_mGPUImgView];
    //第二步：创建滤镜 即这里我们使用的 GPUImageSketchFilter(黑白反色)
    GPUImageiOSBlurFilter *filter = [[GPUImageiOSBlurFilter alloc] init];
//    grayFilter = [[GPUImageSketchFilter alloc] init];
    //第三步：创建Camera 即我们要用到的GPUImageStillCamera
    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
    stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    //设置相机方向
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //第四步： addTarget 并开始处理startCameraCapture
    [stillCamera addTarget:filter];
    [filter addTarget:_mGPUImgView];
    [stillCamera startCameraCapture]; // 开始捕获

}

- (void)addTopBar
{
    if(kIsBangsScreen){
        
    }
    CamraTopBar *cameraTopBar = [[CamraTopBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    cameraTopBar.delegate = self;
    [self.view addSubview:cameraTopBar];
}
- (void)camraTopBarItemDidSelected:(NSInteger)index
{
    [stillCamera stopCameraCapture];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
