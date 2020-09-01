//
//  ZZBeautyFilter.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/1.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZBeautyFilter : GPUImageFilter
{
    
}

@property (nonatomic, assign) CGFloat beautyLevel;
@property (nonatomic, assign) CGFloat brightLevel;
@property (nonatomic, assign) CGFloat toneLevel;

@end

NS_ASSUME_NONNULL_END
