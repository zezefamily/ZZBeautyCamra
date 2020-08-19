//
//  CamraTopBar.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CamraTopBarDelegate <NSObject>

- (void)camraTopBarItemDidSelected:(NSInteger)index;

@end

@interface CamraTopBar : UIView

@property (nonatomic,weak) id<CamraTopBarDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
