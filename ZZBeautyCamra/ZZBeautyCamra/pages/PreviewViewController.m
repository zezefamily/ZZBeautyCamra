//
//  PreviewViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/9.
//  Copyright © 2020 泽泽. All rights reserved.
//
#define BOTTOM_HEIGHT 80.0f

#import "PreviewViewController.h"
#import <PhotosUI/PhotosUI.h>
@import AVFoundation;
@interface PreviewViewController ()
@property (nonatomic,strong) AVPlayer *player;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playLayer];
    //开始播放
    [self.player play];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton *reCaptureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reCaptureBtn.frame = CGRectMake(15, BOTTOM_HEIGHT/2-25, 50, 50);
    [reCaptureBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    reCaptureBtn.backgroundColor = [UIColor lightGrayColor];
    reCaptureBtn.tag = 100;
    [reCaptureBtn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:reCaptureBtn];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(self.view.frame.size.width - 15 - 50, BOTTOM_HEIGHT/2-25, 50, 50);
    [saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor lightGrayColor];
    saveBtn.tag = 101;
    [saveBtn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:saveBtn];
    
}

- (void)bottomClicked:(UIButton *)sender
{
//    __weak typeof(self) weakSelf = self;
    if(sender.tag == 100){//重拍
        //直接返回
        [self.navigationController popViewControllerAnimated:YES];
    }else{//保存
       //保存提示 并 返回
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypeVideo fileURL:self.videoURL options:nil];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
}

@end

