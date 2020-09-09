//
//  CamraTopBar.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//  //比例设置 9:16 3:4 1:1 Full

#import "CamraTopBar.h"

@implementation CamraTopBar
{
    UIButton *_cameraBtn;
    UIButton *_videoBtn;
    NSArray *_scaleArray;
    UIButton *_scaleButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
//        self.backgroundColor = [UIColor whiteColor];
        _scaleArray = @[@"9:16",@"3:4",@"1:1",@"Full"];
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    CGSize itemSize = CGSizeMake(self.frame.size.height-10, self.frame.size.height-10);
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
    
    _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scaleButton.frame = CGRectMake(self.frame.size.width - 15 - itemSize.width - 20 - itemSize.width, 10, self.frame.size.height, self.frame.size.height-20);
    [_scaleButton setTitle:_scaleArray[3] forState:UIControlStateNormal];
    _scaleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _scaleButton.layer.cornerRadius = 2.0f;
    _scaleButton.layer.borderWidth = 1.0f;
    _scaleButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_scaleButton addTarget:self action:@selector(scaleClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scaleButton];
    
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

- (void)scaleClick
{
    static int index = 3;
    index++;
    if(index > 3){
        index = 0;
    }
    NSString *title = [_scaleArray objectAtIndex:index];
    [_scaleButton setTitle:title forState:UIControlStateNormal];
    
    //@[@"9:16",@"3:4",@"1:1",@"Full"];
    CGFloat width = SCREEN_WIDTH;
    CGFloat height;
    if(index == 0){
        height = width/9 * 16;
    }else if (index == 1){
        height = width/3 * 4;
    }else if (index == 2){
        height = width/1 * 1;
    }else {
        height = SCREEN_HEIGHT;
    }
    CGRect rect = CGRectMake(0, 0, width/SCREEN_WIDTH, height/SCREEN_HEIGHT);
    if([self.delegate respondsToSelector:@selector(cameraTopBarScaleChanged:scale:)]){
        [self.delegate cameraTopBarScaleChanged:rect scale:@[@"9:16",@"3:4",@"1:1",@"Full"][index]];
    }
}

@end
