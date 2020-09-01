//
//  FilterCell.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "FilterCell.h"
#import "ZZFilterManager.h"
@interface FilterCell ()
@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) UILabel *titleLabel;
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
    //68 88
    self.imageView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [self addSubview:self.imageView];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = 1;
//    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.titleLabel];
    self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"17"]];
}
- (void)addFilter:(GPUImageOutput<GPUImageInput> *)filter inputImage:(UIImage *)inputImage
{
//    NSLog(@"filter == %@",filter);
//    if(filter == nil){
//        NSLog(@"filter == nil");
//        return;
//    }
//    [self.picture addTarget:filter];
//    [filter addTarget:bgView];
//
//    if (!self.superview) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.picture processImage];
//        });
//    } else {
//        [self.picture processImage];
//    }
}

- (void)setFilterModel:(ZZFilterModel *)filterModel
{
    _filterModel = filterModel;
    self.titleLabel.text = filterModel.filterName;
    GPUImageFilter *filter = [[ZZFilterManager shareManager]filterWithFilterID:filterModel.filterID];
    [self.picture addTarget:filter];
    [filter addTarget:self.imageView];
    if (!self.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.picture processImage];
        });
    } else {
        [self.picture processImage];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.picture removeAllTargets];
}

@end
