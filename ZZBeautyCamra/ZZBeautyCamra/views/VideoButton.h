//
//  VideoButton.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/8.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VideoButtonDelegate <NSObject>

- (void)videoButtonRecordAnimationStatus:(NSInteger)status;

@end

@interface VideoButton : UIView

@property (nonatomic,weak) id<VideoButtonDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
