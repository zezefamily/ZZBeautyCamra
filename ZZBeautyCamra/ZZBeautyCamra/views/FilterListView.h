//
//  FilterListView.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol FilterListViewDelegate <NSObject>

- (void)filterListViewDidSelectedFilter:(GPUImageOutput<GPUImageInput> *)filter;

@end

@interface FilterListView : UIView

@property (nonatomic,weak) id<FilterListViewDelegate> delegate;

- (void)loadListWithGPUImageFilterGroup:(GPUImageFilterGroup *)filterGroup;

@end

NS_ASSUME_NONNULL_END
