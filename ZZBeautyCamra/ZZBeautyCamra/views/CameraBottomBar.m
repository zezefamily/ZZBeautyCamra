//
//  CameraBottomBar.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "CameraBottomBar.h"
#import "VideoButton.h"
@interface CameraBottomBar ()<VideoButtonDelegate>
@end
@implementation CameraBottomBar
{
    VideoButton *_videoButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    //拍摄按钮
    UIButton *captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    captureButton.frame = CGRectMake(self.frame.size.width/2-self.frame.size.height/2, 0, self.frame.size.height, self.frame.size.height);
    captureButton.backgroundColor = ThemeColor;
    captureButton.layer.cornerRadius = self.frame.size.height/2;
    [captureButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:captureButton];
    captureButton.tag = 401;
    
    _videoButton = [[VideoButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-self.frame.size.height/2, 0, self.frame.size.height, self.frame.size.height)];
    _videoButton.delegate = self;
    [self addSubview:_videoButton];
    _videoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    
    
    float margin = 15;
    float between = 20;
    float btnSize = self.frame.size.height - margin * 2;
    CGRect captureBtnFrame = captureButton.frame;
    //美颜
    UIButton *beautyFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautyFaceButton.frame = CGRectMake(captureBtnFrame.origin.x - between - btnSize, margin, btnSize, btnSize);
//    beautyFaceButton.backgroundColor = [UIColor systemTealColor];
    [beautyFaceButton setImage:[UIImage imageNamed:@"beauty_icon"] forState:UIControlStateNormal];
    [beautyFaceButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:beautyFaceButton];
    beautyFaceButton.tag = 400;
    
    //滤镜
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(captureBtnFrame.origin.x + captureBtnFrame.size.width + between, margin, btnSize, btnSize);
//    filterButton.backgroundColor = [UIColor systemTealColor];
    [filterButton setImage:[UIImage imageNamed:@"filter_icon"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filterButton];
    filterButton.tag = 402;
}
- (void)btnClick:(UIButton *)button
{
    NSInteger tag = button.tag - 400;
    if([self.delegate respondsToSelector:@selector(cameraBottomBarItemSelected:)]){
        [self.delegate cameraBottomBarItemSelected:tag];
    }
}

- (void)setCaptureType:(NSInteger)captureType
{
    _captureType = captureType;
    if(captureType == 0){ //拍摄
        [UIView animateWithDuration:.3 animations:^{
            self->_videoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        }];
    }else{ //视频
        [UIView animateWithDuration:.3 animations:^{
           self->_videoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        }];
    }
}

- (void)videoButtonRecordAnimationStatus:(NSInteger)status
{
    if([self.delegate respondsToSelector:@selector(cameraBottomBarRecordStatus:)]){
        [self.delegate cameraBottomBarRecordStatus:status];
    }
}

@end
