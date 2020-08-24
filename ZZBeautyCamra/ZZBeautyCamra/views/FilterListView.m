//
//  FilterListView.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/20.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "FilterListView.h"
#import "FilterCell.h"
@interface FilterListView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@end
@implementation FilterListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self ==  [super initWithFrame:frame]){
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    [self addSubview:self.collectionView];
}
- (UICollectionView *)collectionView
{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(self.frame.size.height - 20, self.frame.size.height);
        flowLayout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[FilterCell class] forCellWithReuseIdentifier:@"FilterCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    if(cell == nil){
        CGSize size = CGSizeMake(self.frame.size.height - 20, self.frame.size.height);
        cell = [[FilterCell alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.height - 20, self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView:didSelectItemAtIndexPath:");
}

@end
