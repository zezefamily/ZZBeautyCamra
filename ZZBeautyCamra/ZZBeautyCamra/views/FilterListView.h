//
//  FilterListView.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFilterModel.h"
NS_ASSUME_NONNULL_BEGIN
@class FilterListView;
@protocol FilterListViewDelegate <NSObject>

@optional
- (void)filterListViewDidSelectedFilter:(GPUImageFilter *)filter;
- (void)filterListView:(FilterListView *)listView didSelected:(NSInteger)index;

@end

@interface FilterListView : UIView

@property (nonatomic,weak) id<FilterListViewDelegate> delegate;

- (void)loadListWithGPUImageFilterGroup:(GPUImageFilterGroup *)filterGroup;

@property (nonatomic,copy) NSArray <ZZFilterModel *> *itemList;


@end

NS_ASSUME_NONNULL_END
