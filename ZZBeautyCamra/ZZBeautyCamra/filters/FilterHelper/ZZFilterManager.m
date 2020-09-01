//
//  ZZFilterManager.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/1.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZFilterManager.h"


@interface ZZFilterManager ()
@property (nonatomic,strong,readwrite) NSArray <ZZFilterModel *> *defaultFilters;
@property (nonatomic,strong,readwrite) NSArray <ZZFilterModel *> *customFilters;

@property (nonatomic, strong) NSDictionary *defaultFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *customFilterMaterialsInfo;

@property (nonatomic, strong) NSMutableDictionary *filterClassInfo;
@end
@implementation ZZFilterManager
static ZZFilterManager *_filterManager;

+ (ZZFilterManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filterManager = [[ZZFilterManager alloc]init];
    });
    return _filterManager;
}
- (instancetype)init
{
    if(self == [super init]){
        [self commonInit];
    }
    return self;
}
//根据filterId 获取滤镜
- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID
{
    NSString *className = self.filterClassInfo[filterID];
    Class filterClass = NSClassFromString(className);
    return [[filterClass alloc]init];
}

- (void)commonInit
{
    self.filterClassInfo = [NSMutableDictionary dictionary];
    [self setupDefaultFilter];
    [self setupCustomFilter];
}

- (void)setupDefaultFilter
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"DefaultFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    self.defaultFilterMaterialsInfo = [info copy];
}

- (void)setupCustomFilter
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"CustomFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    self.customFilterMaterialsInfo = [info copy];
}

- (NSArray<ZZFilterModel *> *)defaultFilters
{
    if(!_defaultFilters){
        _defaultFilters = [self setupFiltersWithInfo:self.defaultFilterMaterialsInfo];
    }
    return _defaultFilters;
}
- (NSArray<ZZFilterModel *> *)customFilters
{
    if(!_customFilters){
        _customFilters = [self setupFiltersWithInfo:self.customFilterMaterialsInfo];
    }
    return _customFilters;
}

- (NSArray<ZZFilterModel *> *)setupFiltersWithInfo:(NSDictionary *)info {
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    NSArray *defaultArray = info[@"Default"];
    for (NSDictionary *dict in defaultArray) {
        ZZFilterModel *model = [[ZZFilterModel alloc] init];
        model.filterID = dict[@"filter_id"];
        model.filterName = dict[@"filter_name"];
        [mutArr addObject:model];
        self.filterClassInfo[dict[@"filter_id"]] = dict[@"filter_class"];
    }
    return [mutArr copy];
}

@end
