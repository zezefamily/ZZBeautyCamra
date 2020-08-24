//
//  ZZPresentationController.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZPresentationController.h"

@implementation ZZPresentationController

- (void)presentationTransitionWillBegin
{
//    NSLog(@"presentationTransitionWillBegin");
}
- (void)presentationTransitionDidEnd:(BOOL)completed
{
//    NSLog(@"presentationTransitionDidEnd:%d",completed);
}

- (CGRect)frameOfPresentedViewInContainerView
{
    return CGRectMake(0, SCREEN_HEIGHT - self.contentSize.height, self.contentSize.width, self.contentSize.height);
}

- (void)dismissalTransitionWillBegin
{
//    NSLog(@"dismissalTransitionWillBegin");
}
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
//    NSLog(@"dismissalTransitionDidEnd:%d",completed);
}

@end
