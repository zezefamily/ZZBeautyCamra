//
//  CamraTopBar.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "CamraTopBar.h"

@implementation CamraTopBar
{
    UIButton *_cameraBtn;
    UIButton *_videoBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
//        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    //L:15 R:15
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(15, 5, self.frame.size.height-10, self.frame.size.height-10);
    [close setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    close.tag = 400;
    [close addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(self.frame.size.width - 15 - (self.frame.size.height-10) , 5, self.frame.size.height-10, self.frame.size.height-10);
    [switchBtn setImage:[UIImage imageNamed:@"swich_icon"] forState:UIControlStateNormal];
    switchBtn.tag = 401;
    [switchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchBtn];
    
    //分段按钮
    UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 40, 0, 80, self.frame.size.height)];
//    segmentView.backgroundColor = [UIColor redColor];
    [self addSubview:segmentView];
    NSArray *title = @[@"拍摄",@"视频"];
    for(int i = 0;i<title.count;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*40, 0, 40, self.frame.size.height);
        [btn setTitle:title[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [segmentView addSubview:btn];
        if(i == 0){
            _cameraBtn = btn;
            _cameraBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.25, 1.25);
        }
        if(i == 1){
            _videoBtn = btn;
        }
    }
}
- (void)segmentClick:(UIButton *)sender
{
    BOOL isCameraBtn = sender == _cameraBtn? YES : NO;
    CGAffineTransform bigTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.25, 1.25);
    CGAffineTransform samallTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView animateWithDuration:.2 animations:^{
        self->_cameraBtn.transform = isCameraBtn ? bigTransform : samallTransform;
        self->_videoBtn.transform = isCameraBtn ? samallTransform : bigTransform;
    }];
    NSInteger index = isCameraBtn ? 2 : 3;
    if([self.delegate respondsToSelector:@selector(camraTopBarItemDidSelected:)]){
        [self.delegate camraTopBarItemDidSelected:index];
    }
}

- (void)btnClick:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(camraTopBarItemDidSelected:)]){
        [self.delegate camraTopBarItemDidSelected:button.tag - 400];
    }
}
@end
