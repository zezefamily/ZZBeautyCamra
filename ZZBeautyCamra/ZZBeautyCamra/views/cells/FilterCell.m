//
//  FilterCell.m
//  ZZBeautyCamra
//
//  Created by wenmei on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    bgView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:bgView];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width)];
    title.textAlignment = 1;
    title.text = @"d123";
    title.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:title];
}
@end
