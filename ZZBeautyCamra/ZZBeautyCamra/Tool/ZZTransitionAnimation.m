//
//  ZZTransitionAnimation.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ZZTransitionAnimation.h"
#import "UIViewController+ZZAnimationTransitioningSnapshot.h"
@interface ZZTransitionAnimation ()
{
    NSInteger _type;
}
@end
@implementation ZZTransitionAnimation

// 0 push 1 pop
- (instancetype)initWithType:(NSInteger)type
{
    if(self == [super init]){
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return .3;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //目标vc
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //原vc
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = nil;
    UIView *fromView = nil;
    if([transitionContext respondsToSelector:@selector(viewForKey:)]){
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }else{
        toView = toVC.view;
        fromView = fromVC.view;
    }
    if(_type == 0){
//        UIView *view = [[UIView alloc]initWithFrame: toVC.view.bounds];
//        view.backgroundColor = [UIColor clearColor];
        toView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4);
        toView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.5];
        [[transitionContext containerView] addSubview:toVC.view];
//        [[toVC.navigationController.view superview] insertSubview:view belowSubview:toVC.navigationController.view];
        [UIView animateWithDuration:.3 animations:^{
            toView.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT * 0.4, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4);
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (_type == 1){
        fromView.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT * 0.4, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4);
        [[transitionContext containerView] addSubview:toVC.view];
        [UIView animateWithDuration:.3 animations:^{
            fromView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4);
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}


@end
