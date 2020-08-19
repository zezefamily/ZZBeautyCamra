//
//  CamraTopBar.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/19.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "CamraTopBar.h"

@implementation CamraTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    //L:15 R:15
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 0, self.frame.size.height, self.frame.size.height);
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    btn.tag = 400;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)btnClick:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(camraTopBarItemDidSelected:)]){
        [self.delegate camraTopBarItemDidSelected:0];
    }
}
@end
