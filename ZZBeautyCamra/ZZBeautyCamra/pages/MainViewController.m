//
//  MainViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/18.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "MainViewController.h"
#import "CamraViewController.h"
#import "CycleScrollVIew.h"
#import "LocalImageProcessViewController.h"
#import "SimpleVideoViewController.h"
@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *_bannerImgView;
    GPUImageView *filterView;
    GPUImageStillCamera *videoCamera;
    GPUImagePicture *sourcePicture;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
//    [self performSelector:@selector(todoSth) withObject:nil afterDelay:2];
}

- (void)todoSth
{
    NSLog(@"todoSth");
    
    filterView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    filterView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:filterView];
    videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = YES; //前置镜像
//    videoCamera.runBenchmark = YES;
//    GPUImageFilter *filter = [[GPUImageFilter alloc]init];
//    [videoCamera addTarget:filter];
//    [filter addTarget:filterView];
    GPUImageAddBlendFilter *addBlendFilter = [[GPUImageAddBlendFilter alloc]init];
    [videoCamera addTarget:addBlendFilter];
    
    UIImage *inputImage = [UIImage imageNamed:@"logo"];
    sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    [sourcePicture processImage];
    [sourcePicture addTarget:addBlendFilter];
    
    [addBlendFilter addTarget:filterView];
    
    [videoCamera startCameraCapture];
}


- (void)loadUI
{
    [self loadBannerView];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-30, self.view.frame.size.width, self.view.frame.size.height/2)];
//    contentView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:.95];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    [contentView.layer addSublayer:gradientLayer];
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:.85].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0.05, @0.12];
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [self.view addSubview:contentView];
    //相机
    UIButton *camraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    camraBtn.frame = CGRectMake(self.view.frame.size.width/2 - 45, contentView.frame.size.height - 90 - 10, 90, 90);
    camraBtn.backgroundColor = ThemeColor;
    [camraBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    camraBtn.layer.cornerRadius = 45;
    [camraBtn addTarget:self action:@selector(camraClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:camraBtn];
    //菜单
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, contentView.frame.size.width - 30, contentView.frame.size.height - 15 - 80 - 30)];
//    menuView.backgroundColor = [UIColor systemPinkColor];
    [contentView addSubview:menuView];
    
    float margin = 15;
    float width = menuView.frame.size.width/2 - 7.5;
    float height = 100;
    int colum = 2;
    NSArray *colors = @[
        [UIColor colorWithRed:0.96 green:0.74 blue:0.85 alpha:1.00],
        [UIColor colorWithRed:0.98 green:0.83 blue:0.83 alpha:1.00],
        [UIColor colorWithRed:0.72 green:0.87 blue:0.99 alpha:1.00],
        [UIColor colorWithRed:0.77 green:0.82 blue:0.98 alpha:1.00],
        [UIColor colorWithRed:0.99 green:0.86 blue:0.49 alpha:1.00],
        [UIColor colorWithRed:0.86 green:0.77 blue:0.99 alpha:1.00],
        [UIColor colorWithRed:0.76 green:0.90 blue:0.74 alpha:1.00]
    ];
    for(int i = 0;i<4;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i%colum * (width + margin), (height+margin)*(i / colum), width, height);
        btn.backgroundColor = colors[i];
        btn.layer.cornerRadius = 15.0f;
        [btn setTitle:@[@" 图片精修",@" 视频滤镜",@" 构建中",@" 构建中"][i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_icon",i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 400 + i;
        [menuView addSubview:btn];
    }
}

- (void)camraClick
{
    CamraViewController *camraVC = [[CamraViewController alloc]init];
//    [self presentViewController:camraVC animated:YES completion:nil];
    [self.navigationController pushViewController:camraVC animated:YES];
}

- (void)menuClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 400;
    
    switch (tag) {
        case 0:
        {
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc]init];
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerVC.delegate = self;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
            break;
        case 1:
        {
            SimpleVideoViewController *simpleVideoVC = [[SimpleVideoViewController alloc]init];
            [self.navigationController pushViewController:simpleVideoVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"info == %@",info);
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    LocalImageProcessViewController *localImgPVC = [[LocalImageProcessViewController alloc]init];
    localImgPVC.image = pickImage;
    [self.navigationController pushViewController:localImgPVC animated:YES];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadBannerView
{
    _bannerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2 + 50)];
    _bannerImgView.backgroundColor = [UIColor systemGreenColor];
    [self.view addSubview:_bannerImgView];
    
    NSArray *imagesURLStrings = @[
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599047085019&di=f284f04d43a8b8e884381cd9ab21f2d7&imgtype=0&src=http%3A%2F%2Ft7.baidu.com%2Fit%2Fu%3D3616242789%2C1098670747%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D900%26h%3D1350",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599047139157&di=bda517ff25d45551ef0d2669c44f790d&imgtype=0&src=http%3A%2F%2Ft7.baidu.com%2Fit%2Fu%3D1393772274%2C4173716047%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D900%26h%3D900",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599047203691&di=85f1afdef0ea832f8f07727d43585a0a&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D3571592872%2C3353494284%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1200%26h%3D1290",
        @"https://t7.baidu.com/it/u=781514496,1938122541&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1599642597&t=542e14b3db72c1f4027553a959022112",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599048101792&di=9d9551c4adbd42901e9f4e467aff14b7&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D2128172938%2C4264128967%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D900%26h%3D1350"
    ];
    
    CycleScrollView *cycleScrollView = [CycleScrollView initCycleScrollViewWithFrame:CGRectMake(0, 0, _bannerImgView.frame.size.width, _bannerImgView.frame.size.height) delegate:nil placeholderImage:nil];
    cycleScrollView.onlyDisplayText = NO;//是否只展示文字
    cycleScrollView.hidesForSinglePage= NO;//当只有一页的时候是否隐藏pageControl
    cycleScrollView.imageUrlArray = imagesURLStrings;//设置图片链接数组
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;//设置轮播图为系统经典模式
    cycleScrollView.pageDotColor = [UIColor blueColor];//设置不是当前分页控件小图标的颜色
    cycleScrollView.autoScrollTimeInterval = 4;//设置循环滚动的时长
    cycleScrollView.autoScroll = YES;//设置是不是自动循环滚动
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
    cycleScrollView.showPageControl = YES;//是不是显示分页控件
    [_bannerImgView addSubview:cycleScrollView];
    
    /// 娱乐一下
    CGRect appNameFrame;
    CGRect smallNameFrame;
    if(kIsBangsScreen){
        appNameFrame =  CGRectMake(12, 44, 80, 25);
        smallNameFrame =  CGRectMake(12, 44+25, 80, 20);
    }else{
        appNameFrame =  CGRectMake(12, 20, 80, 25);
        smallNameFrame =  CGRectMake(12, 20+25, 80, 20);
    }
    UILabel *appName = [[UILabel alloc]initWithFrame:appNameFrame];
    appName.backgroundColor = [UIColor lightGrayColor];
    appName.text = @"泽泽相机";
    appName.textAlignment = 1;
    appName.font = [UIFont boldSystemFontOfSize:18];
    appName.textColor = [UIColor whiteColor];
    [_bannerImgView addSubview:appName];
    UILabel *appSamllName = [[UILabel alloc]initWithFrame:smallNameFrame];
    appSamllName.backgroundColor = [UIColor blackColor];
    appSamllName.text = @"吹 牛 更 专 业";
    appSamllName.textAlignment = 1;
    appSamllName.font = [UIFont systemFontOfSize:12];
    appSamllName.textColor = [UIColor whiteColor];
    [_bannerImgView addSubview:appSamllName];
    //个人中心
    UIButton *personalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personalBtn.frame = CGRectMake(_bannerImgView.frame.size.width - 12 - 36, kIsBangsScreen ? 44 : 20 , 36, 36);
    personalBtn.backgroundColor = [UIColor whiteColor];
    personalBtn.layer.cornerRadius = 18.f;
    [personalBtn setImage:[UIImage imageNamed:@"personal_icon"] forState:UIControlStateNormal];
    [personalBtn addTarget:self action:@selector(personalClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bannerImgView addSubview:personalBtn];
    
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
//    [_bannerImgView addSubview:view];
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = CGRectMake(0, 0, 200, 200);
//    [view.layer addSublayer:gradientLayer];
//    //set gradient colors
//
//    gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:.85].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//    //@[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id) [UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
//    //set locations
//    gradientLayer.locations = @[@0.1, @0.25];
//    //set gradient start and end points
//    gradientLayer.startPoint = CGPointMake(0.5, 0);
//    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    
}

- (void)personalClicked
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
