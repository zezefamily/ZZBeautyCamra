//
//  ZZTransitionAnimation.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface ZZTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>
- (instancetype)initWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
