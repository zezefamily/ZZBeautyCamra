//
//  CameraBottomBar.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CameraBottomBarDelegate <NSObject>

- (void)cameraBottomBarItemSelected:(NSInteger)index;

- (void)cameraBottomBarRecordStatus:(NSInteger)status;

@end

@interface CameraBottomBar : UIView

@property (nonatomic,weak) id<CameraBottomBarDelegate> delegate;

@property (nonatomic,assign) NSInteger captureType;

@end

NS_ASSUME_NONNULL_END
