//
//  FilterHelper.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/1.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "FilterHelper.h"
#import "ZZBeautyFilter.h"
@interface FilterHelper ()
@property (nonatomic, strong) NSMutableArray<GPUImageFilter *> *filters;
@property (nonatomic, strong) GPUImageCropFilter *currentCropFilter;
@property (nonatomic, weak) GPUImageFilter *currentBeautifyFilter;
@property (nonatomic, weak) GPUImageFilter *currentEffectFilter;
@property (nonatomic, strong) ZZBeautyFilter *defaultBeautifyFilter;
@property (nonatomic, strong) CADisplayLink *displayLink;  // 用来刷新时间
@end
@implementation FilterHelper

- (instancetype)init
{
    if(self == [super init]){
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _beautifyFilterDegree = 0.5f;
    self.filters = [[NSMutableArray alloc]init];
    [self addCropFilter];
    [self addBeautifyFilter];
    [self setupDisplaylink];
}

- (void)addCropFilter
{
    self.currentCropFilter = [[GPUImageCropFilter alloc]init];
    [self addFilter:self.currentEffectFilter];
}
- (void)addBeautifyFilter
{
    [self setBeautifyFilter:nil];
}
- (void)setBeautifyFilter:(GPUImageFilter *)filter
{
    if(!filter){
        filter = [[GPUImageFilter alloc]init];
    }
    if(!self.currentBeautifyFilter){
        [self addFilter:filter];
    }else{
        NSInteger index = [self.filters indexOfObject:self.currentBeautifyFilter];
        GPUImageOutput *source = index == 0 ? self.source : self.filters[index - 1];
        for(id<GPUImageInput> input in self.currentBeautifyFilter.targets){
            [filter addTarget:input];
        }
        [source removeTarget:self.currentBeautifyFilter];
        [self.currentBeautifyFilter removeAllTargets];
        [source addTarget:filter];
        self.filters[index] = filter;
    }
    self.currentBeautifyFilter = filter;
}

- (void)setupDisplaylink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)displayAction
{
    
}
/// 滤镜链第一个滤镜
- (GPUImageFilter *)firstFilter
{
    return self.filters.firstObject;
}
/// 滤镜链最后一个滤镜
- (GPUImageFilter *)lastFilter
{
    return self.filters.lastObject;
}
/// 设置裁剪比例，用于设置特殊的相机比例
- (void)setCropRect:(CGRect)rect
{
    self.currentCropFilter.cropRegion = rect;
}
/// 往末尾添加一个滤镜
- (void)addFilter:(GPUImageFilter *)filter
{
    NSArray *targets = self.filters.lastObject.targets;
    [self.filters.lastObject removeAllTargets];
    [self.filters.lastObject addTarget:filter];
    for(id<GPUImageInput> input in targets){
        [filter addTarget:input];
    }
    [self.filters addObject:filter];
}
/// 设置效果滤镜
- (void)setEffectFilter:(GPUImageFilter *)filter
{
    if(!filter){
        filter = [[GPUImageFilter alloc]init];
    }
    if(!self.currentEffectFilter){
        [self addFilter:filter];
    }else{
        NSInteger index = [self.filters indexOfObject:self.currentEffectFilter];
        GPUImageOutput *source = index == 0 ? self.source : self.filters[index - 1];
        for(id<GPUImageInput> input in self.currentEffectFilter.targets){
            [filter addTarget:input];
        }
        [source removeTarget:self.currentEffectFilter];
        [self.currentEffectFilter removeAllTargets];
        [source addTarget:filter];
        self.filters[index] = filter;
    }
    self.currentEffectFilter = filter;
    //记录应用的时间...
}

- (void)setBeautifyFilterDegree:(CGFloat)beautifyFilterDegree
{
    if(!self.beautifyFilterEnable){
        return;
    }
    _beautifyFilterDegree = beautifyFilterDegree;
    self.defaultBeautifyFilter.beautyLevel = beautifyFilterDegree;
}
- (void)setBeautifyFilterEnable:(BOOL)beautifyFilterEnable
{
    _beautifyFilterEnable = beautifyFilterEnable;
    [self setBeautifyFilter:beautifyFilterEnable ? (GPUImageFilter *)self.defaultBeautifyFilter :nil];
}

- (ZZBeautyFilter *)defaultBeautifyFilter
{
    if(!_defaultBeautifyFilter){
        _defaultBeautifyFilter = [[ZZBeautyFilter alloc]init];
    }
    return _defaultBeautifyFilter;
}

@end
