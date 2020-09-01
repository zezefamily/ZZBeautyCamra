//
//  ImageFilterViewController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ImageFilterViewController.h"
#import "FilterListView.h"

@interface ImageFilterViewController ()<FilterListViewDelegate>
{
    UIView *btnsView;
    UIView *selectView;
    UIView *bottomView;
    FilterListView *_listView;
    UIButton *_normalFilterBtn;
    UIButton *_customFilterBtn;
    
    NSArray *_filterArray;
}
@end

@implementation ImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildViews];
    [self addButtons];
    [self addListView];
    [self addBottomItems];
    [self loadFilters];
}

- (void)loadFilters
{
    
    _filterArray = [ZZFilterManager shareManager].defaultFilters;
    _listView.itemList = _filterArray;
    
//    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc]init];
//    [filterGroup addFilter:[[GPUImageFilter alloc]init]];  //无
//    [filterGroup addFilter:[[GPUImageSketchFilter alloc]init]]; //素描
//    [filterGroup addFilter:[[GPUImageSepiaFilter alloc]init]];  //复古
//    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc]init];
//    brightnessFilter.brightness = 0.5;
//    [filterGroup addFilter:brightnessFilter]; //亮度
//    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc]init];
//    contrastFilter.contrast = 3.0;
//    [filterGroup addFilter:contrastFilter]; //对比度
//    [filterGroup addFilter:[[GPUImageCropFilter alloc]initWithCropRegion:CGRectMake(0.25, 0.25, 0.25, 0.25)]];    // 裁剪
//    [filterGroup addFilter:[[GPUImageCrosshatchFilter alloc]init]]; // 交叉影线
//    [filterGroup addFilter:[[GPUImageDilationFilter alloc]initWithRadius:3]];
//    [filterGroup addFilter:[[GPUImageDirectionalNonMaximumSuppressionFilter alloc]init]];
//    [filterGroup addFilter:[[GPUImageColorPackingFilter alloc]init]];
//    [filterGroup addFilter:[[GPUImageVignetteFilter alloc]init]]; //周围阴影
//    [filterGroup addFilter:[[TwoSplitScreenFilter alloc]init]];  //二分屏
//    [filterGroup addFilter:[[ThreeSplitScreenFilter alloc]init]]; //三分屏
//    [filterGroup addFilter:[[FourSplitScreenFilter alloc]init]]; //四分屏
//    [filterGroup addFilter:[[SixSplitScreenFilter alloc]init]]; //六分屏
//    [filterGroup addFilter:[[NineSplitScreenFilter alloc]init]]; //九分屏
//    [filterGroup addFilter:[[GPUImageSphereRefractionFilter alloc]init]]; //球形折射
//    [filterGroup addFilter:[[GPUImageGlassSphereFilter alloc]init]]; //水晶球
//    [filterGroup addFilter:[[GPUImagePolarPixellateFilter alloc]init]]; //像素化
//    [filterGroup addFilter:[[GPUImagePixellateFilter alloc]init]];  //像素化2
//    [filterGroup addFilter:[[GPUImageSmoothToonFilter alloc]init]]; //卡通
//    [filterGroup addFilter:[[GPUImageToonFilter alloc]init]];//卡通2
    //GPUImageVignetteFilter
//    [_listView loadListWithGPUImageFilterGroup:filterGroup];
}

- (void)addBottomItems
{
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(self.contentSize.width/2 - 23, 10, 46, 46);
    cameraBtn.layer.cornerRadius = 23;
    cameraBtn.backgroundColor = ThemeColor;
    [cameraBtn addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cameraBtn];
}

#pragma mark - FilterListViewDelegate
- (void)filterListView:(id)listView didSelected:(NSInteger)index
{
    ZZFilterModel *model = _filterArray[index];
    GPUImageFilter *filter =  [[ZZFilterManager shareManager]filterWithFilterID:model.filterID];
//    if ([filter isKindOfClass:[GPUImagePolkaDotFilter class]]) {
//        ((GPUImagePolkaDotFilter *)filter).dotScaling = 1.00;
//    }
    if([self.delegate respondsToSelector:@selector(imageFilterVCUpdateFilter:)]){
        [self.delegate imageFilterVCUpdateFilter:filter];
    }
}
//- (void)filterListViewDidSelectedFilter:(GPUImageFilter *)filter
//{
//    if([self.delegate respondsToSelector:@selector(imageFilterVCUpdateFilter:)]){
//        [self.delegate imageFilterVCUpdateFilter:filter];
//    }
//}

- (void)addListView
{
    _listView = [[FilterListView alloc]initWithFrame:CGRectMake(0, 0, selectView.frame.size.width, selectView.frame.size.height)];
    [selectView addSubview:_listView];
    _listView.delegate = self;
}
- (void)addButtons
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.contentSize.width - 10 - 50, 0, 50, btnsView.frame.size.height);
    [closeBtn setTitle:@"收起" forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor blueColor];
    [closeBtn setTitleColor:TextColor forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [btnsView addSubview:closeBtn];
    
    _normalFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _normalFilterBtn.frame = CGRectMake(10, 0, 50, btnsView.frame.size.height);
    [_normalFilterBtn setTitle:@"常用" forState:UIControlStateNormal];
    [_normalFilterBtn setTitleColor:TextColor forState:UIControlStateNormal];
    [_normalFilterBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
//    _normalFilterBtn.backgroundColor = [UIColor blueColor];
    _normalFilterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_normalFilterBtn addTarget:self action:@selector(switchFilterType:) forControlEvents:UIControlEventTouchUpInside];
    _normalFilterBtn.tag = 300;
    _normalFilterBtn.selected = YES;
    [btnsView addSubview:_normalFilterBtn];
    
    _customFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customFilterBtn.frame = CGRectMake(10+50, 0, 50, btnsView.frame.size.height);
    [_customFilterBtn setTitle:@"自定义" forState:UIControlStateNormal];
    [_customFilterBtn setTitleColor:TextColor forState:UIControlStateNormal];
    [_customFilterBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
//    _customFilterBtn.backgroundColor = [UIColor blueColor];
    _customFilterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_customFilterBtn addTarget:self action:@selector(switchFilterType:) forControlEvents:UIControlEventTouchUpInside];
    _customFilterBtn.tag = 301;
    _customFilterBtn.selected = NO;
    [btnsView addSubview:_customFilterBtn];
}

- (void)switchFilterType:(UIButton *)sender
{
    _normalFilterBtn.selected = sender.tag == 300 ? YES : NO;
    _customFilterBtn.selected = sender.tag == 301 ? YES : NO;
    
    if(sender.tag == 300){//常用
        _filterArray = [ZZFilterManager shareManager].defaultFilters;
        _listView.itemList = _filterArray;
    }else{//自定义
        _filterArray = [ZZFilterManager shareManager].customFilters;
        _listView.itemList = _filterArray;
    }
    
}

- (void)buildViews
{
    //0.2:0.4:0.4
    btnsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height * 0.2)];
//    btnsView.backgroundColor = [UIColor systemRedColor];
    [self.view addSubview:btnsView];
    selectView = [[UIView alloc]initWithFrame:CGRectMake(0, btnsView.frame.size.height, self.contentSize.width, self.contentSize.height * 0.4)];
    selectView.backgroundColor = [UIColor systemTealColor];
    [self.view addSubview:selectView];
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, btnsView.frame.size.height + selectView.frame.size.height, self.contentSize.width, self.contentSize.height * 0.4)];
//    bottomView.backgroundColor = [UIColor systemPinkColor];
    [self.view addSubview:bottomView];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraClick
{
    
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
