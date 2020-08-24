//
//  ZZMagicCamera.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import GPUImage;

NS_ASSUME_NONNULL_BEGIN

@interface ZZMagicCamera : UIView

- (instancetype)initWithFrame:(CGRect)frame options:(id)options;

- (void)switchFilter:(id<GPUImageInput>)filter;

- (void)switchCamera;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
