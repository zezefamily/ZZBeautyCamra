//
//  LocalImageProcessViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/3.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "LocalImageProcessViewController.h"

@interface LocalImageProcessViewController ()
{
    UIImageView *imageView;
    NSArray <ZZFilterModel *>*_filters;
    UIImage *_targetImage;
}
@end

@implementation LocalImageProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, Margin_Top, self.view.frame.size.width,self.view.frame.size.height - Margin_Top)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.image;
    [self.view addSubview:imageView];
    _filters =  [ZZFilterManager shareManager].defaultFilters;
    //这里简单测试一下
    for(int i = 0;i < 5; i++){
        ZZFilterModel *filterModel = _filters[i];
        UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        filterBtn.frame = CGRectMake(10+60*i, self.view.frame.size.height - 50, 50, 30);
        [filterBtn setTitle:filterModel.filterName forState:UIControlStateNormal];
        filterBtn.tag = 500 + i;
        [filterBtn addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:filterBtn];
    }
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(15, Margin_Top, 30, 30);
    [close setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
}

- (void)closeClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)filterClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 500;
    ZZFilterModel *filterModel = _filters[tag];
    GPUImageFilter *filter = [[ZZFilterManager shareManager]filterWithFilterID:filterModel.filterID];
    UIImage *resultImg = [self processImageWithFilter:filter inputImage:self.image];
    imageView.image = resultImg;
}

- (UIImage *)processImageWithFilter:(GPUImageFilter *)filter inputImage:(UIImage *)inputImg
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImg];
    [stillImageSource addTarget:filter];
    [filter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *currentFilteredVideoFrame = [filter imageFromCurrentFramebuffer];
    return currentFilteredVideoFrame;
}


@end
