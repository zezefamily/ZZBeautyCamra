//
//  FilterCell.h
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterCell : UICollectionViewCell

- (void)addFilter:(GPUImageOutput<GPUImageInput> *)filter inputImage:(UIImage *)inputImage;

@end

NS_ASSUME_NONNULL_END
