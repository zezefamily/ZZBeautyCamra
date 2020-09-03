//
//  CaptureImageResultViewController.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/3.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CaptureImageResultViewController;
@protocol CaptureImageResultViewControllerDelegate <NSObject>

- (void)captureImageResultViewCompleted:(CaptureImageResultViewController *)controller;

- (void)captureImageResultViewDismiss:(CaptureImageResultViewController *)controller;

@end

@interface CaptureImageResultViewController : UIViewController

@property (nonatomic,weak) id<CaptureImageResultViewControllerDelegate> delegate;

@property (nonatomic,strong) NSData *resultImgData;

@end

NS_ASSUME_NONNULL_END
