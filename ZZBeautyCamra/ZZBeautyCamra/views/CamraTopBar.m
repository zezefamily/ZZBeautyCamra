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
//        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    //L:15 R:15
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(15, 5, self.frame.size.height-10, self.frame.size.height-10);
    [close setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    close.tag = 400;
    [close addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(self.frame.size.width - 15 - (self.frame.size.height-10) , 5, self.frame.size.height-10, self.frame.size.height-10);
    [switchBtn setImage:[UIImage imageNamed:@"swich_icon"] forState:UIControlStateNormal];
    switchBtn.tag = 401;
    [switchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchBtn];
    
}
- (void)btnClick:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(camraTopBarItemDidSelected:)]){
        [self.delegate camraTopBarItemDidSelected:button.tag - 400];
    }
}
@end
