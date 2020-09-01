//
//  ImageFilterViewController.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImageFilterViewControllerDelegate <NSObject>

- (void)imageFilterVCUpdateFilter:(GPUImageFilter *)filter;

@end

@interface ImageFilterViewController : UIViewController

@property (nonatomic,assign) id<ImageFilterViewControllerDelegate> delegate;

@property (nonatomic,assign) CGSize contentSize;

@end

NS_ASSUME_NONNULL_END
