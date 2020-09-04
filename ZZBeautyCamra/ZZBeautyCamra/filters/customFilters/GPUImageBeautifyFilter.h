//
//  GPUImageBeautifyFilter.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/4.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN
@class GPUImageCombinationFilter;
@interface GPUImageBeautifyFilter : GPUImageFilterGroup
{
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}

@end

NS_ASSUME_NONNULL_END
