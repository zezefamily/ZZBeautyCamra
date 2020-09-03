//
//  CaptureImageResultViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/3.
//  Copyright © 2020 泽泽. All rights reserved.
//
#define BOTTOM_HEIGHT 80.0f
#import "CaptureImageResultViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <PhotosUI/PhotosUI.h>
@interface CaptureImageResultViewController ()
@property (nonatomic,strong) UIImageView *resultView;
@end

@implementation CaptureImageResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton *reCaptureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reCaptureBtn.frame = CGRectMake(15, BOTTOM_HEIGHT/2-25, 50, 50);
//    [reCaptureBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    reCaptureBtn.backgroundColor = [UIColor lightGrayColor];
    reCaptureBtn.tag = 600;
    [reCaptureBtn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:reCaptureBtn];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(self.view.frame.size.width - 15 - 50, BOTTOM_HEIGHT/2-25, 50, 50);
//    [saveBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor lightGrayColor];
    saveBtn.tag = 601;
    [saveBtn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:saveBtn];
    
    
    [self addResultView];
    
}

- (void)addResultView
{
    CGFloat y = kIsBangsScreen ? 44:20;
    self.resultView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - BOTTOM_HEIGHT - y)];
    self.resultView.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageWithData:self.resultImgData];
    self.resultView.image = image;
    self.resultView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.resultView];
}

- (void)bottomClicked:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    if(sender.tag == 600){//重拍
        //直接返回
        if([self.delegate respondsToSelector:@selector(captureImageResultViewCompleted:)]){
            [self.delegate captureImageResultViewDismiss:self];
        }
    }else{//保存
       //保存提示 并 返回
        [self saveImage:^(BOOL success, NSError * _Nullable error) {
            if(!success){
                NSLog(@"保存失败");
            }
            if([weakSelf.delegate respondsToSelector:@selector(captureImageResultViewCompleted:)]){
                [weakSelf.delegate captureImageResultViewCompleted:weakSelf];
            }
        }];
    }
}

// 保存图片
- (void)saveImage:(void (^)(BOOL success, NSError * _Nullable error))block
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:self.resultImgData options:nil];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if(block){
            dispatch_async(dispatch_get_main_queue(), ^{
                 block(success,error);
            });
        }
    }];
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
