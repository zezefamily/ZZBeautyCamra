//
//  FilterCell.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "FilterCell.h"
@interface FilterCell ()
{
    UIImageView *bgView;
}
@end
@implementation FilterCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
//    bgView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:bgView];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width)];
    title.textAlignment = 1;
    title.text = @"滤镜";
    title.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:title];
}

- (void)addFilter:(GPUImageOutput<GPUImageInput> *)filter inputImage:(UIImage *)inputImage
{
    __weak typeof(UIImageView *) weakImgView = bgView;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [filter useNextFrameForImageCapture];
        UIImage *outPutImg = [filter imageByFilteringImage:inputImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakImgView.image = outPutImg;
        });
    });
}

@end
