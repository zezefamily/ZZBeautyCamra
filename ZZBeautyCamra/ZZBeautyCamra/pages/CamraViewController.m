
//
//  CamraViewController.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "CamraViewController.h"
#import "GPUImage.h"

#import <PhotosUI/PhotosUI.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface CamraViewController ()
@property(strong,nonatomic)GPUImageVideoCamera *vCamera;
@property(strong,nonatomic)GPUImageStillCamera *mCamera;
@property(strong,nonatomic) GPUImageFilter *mFilter;
@property(strong,nonatomic) GPUImageView *mGPUImgView;
@end

@implementation CamraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self demo1];
    
    //添加GPUImage
    [self addFiterCamera];
    
    //添加一个按钮触发拍照
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-80)*0.5, self.view.bounds.size.height-120, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    
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
    //这个滤镜你可以换其它的，官方给出了不少滤镜
    _mFilter = [[GPUImageGrayscaleFilter alloc] init];
    
    //5.
    _mGPUImgView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [_mCamera addTarget:_mFilter];
    [_mFilter addTarget:_mGPUImgView];
    [self.view addSubview:_mGPUImgView];
    
    //6.
    [_mCamera startCameraCapture];
    
}

-(void)takePhoto{
   
    //7.将图片通过PhotoKit add 相册中
    [_mCamera capturePhotoAsJPEGProcessedUpToFilter:_mFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:processedJPEG options:nil];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
        }];
        
        //获取拍摄的图片
        UIImage * image = [UIImage imageWithData:processedJPEG];
        
    }];
    

}

- (void)demo1
{
//    GPUImageView *imageView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
//    imageView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:imageView];
//
//
//    GPUImageStillCamera *stillCamera = [[GPUImageStillCamera alloc]init];
//    //[[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
//    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
////    [stillCamera rotateCamera];
//
//    GPUImageGrayscaleFilter *grayFilter = [[GPUImageGrayscaleFilter alloc]init];
//    [stillCamera addTarget:grayFilter];
//    [grayFilter addTarget:imageView];
    
    
//    [stillCamera startCameraCapture];
    
    
//    //第一步：创建预览View 即必须的GPUImageView
//    GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:primaryView];
//     //第二步：创建滤镜 即这里我们使用的 GPUImageSketchFilter(黑白反色)
//    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
//    //第三步：创建Camera 即我们要用到的GPUImageStillCamera
//    GPUImageStillCamera* stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
//    //设置相机方向
//    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    //第四步： addTarget 并开始处理startCameraCapture
//    [stillCamera addTarget:filter];
//    [filter addTarget:primaryView];
//    [stillCamera startCameraCapture]; // 开始捕获
    
//    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
//    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//
//    GPUImageFilter *customFilter = [[GPUImageSketchFilter alloc] init];
//    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
//
//    // Add the view somewhere so it's visible
//
//    [videoCamera addTarget:customFilter];
//    [customFilter addTarget:filteredVideoView];
//
//    [videoCamera startCameraCapture];
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
