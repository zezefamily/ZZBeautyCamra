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
{
    UIImage *_currentInputImg;
    GPUImageSketchFilter *sketchFilter;
    GPUImageFilterGroup *_filterGroup;
}
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
    _currentInputImg = [UIImage imageNamed:@"17"];
    sketchFilter = [[GPUImageSketchFilter alloc]init];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return _filterGroup.filterCount;
    return self.itemList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    if(cell == nil){
        CGSize size = CGSizeMake(self.frame.size.height - 20, self.frame.size.height);
        cell = [[FilterCell alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }
    cell.filterModel = [self.itemList objectAtIndex:indexPath.row];
//    [cell addFilter:[_filterGroup filterAtIndex:indexPath.row] inputImage:_currentInputImg];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.height - 20, self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView:didSelectItemAtIndexPath:");
//    if([self.delegate respondsToSelector:@selector(filterListViewDidSelectedFilter:)]){
//        [self.delegate filterListViewDidSelectedFilter:[self.itemList objectAtIndex:indexPath.row]];
//    }
    if([self.delegate respondsToSelector:@selector(filterListView:didSelected:)]){
        [self.delegate filterListView:self didSelected:indexPath.row];
    }
}

- (void)loadListWithGPUImageFilterGroup:(GPUImageFilterGroup *)filterGroup
{
    _filterGroup = filterGroup;
    [self.collectionView reloadData];
}

- (void)setItemList:(NSArray<ZZFilterModel *> *)itemList
{
    _itemList = [itemList copy];
    [self.collectionView reloadData];
}

@end
