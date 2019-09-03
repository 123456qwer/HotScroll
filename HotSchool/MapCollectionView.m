//
//  MapCollectionView.m
//  begin
//
//  Created by Mac on 2019/5/10.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "MapCollectionView.h"
#import "MapCollectionViewCell.h"
@implementation MapCollectionView
{
    NSInteger _nowMapIndex;
}
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
{
    if ([super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
         _nowMapIndex = [[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex];
        [self registerNib:[UINib nibWithNibName:@"MapCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = UICOLOR_RANDOM;
    cell.mapImageView.image = [UIImage imageNamed:_mapArr[indexPath.row]];
    [cell setStarWithStarCount:[_starArr[indexPath.row]intValue]];
    if (indexPath.row + _starIndex <= _nowMapIndex) {
        cell.lockImageView.hidden = YES;
    }else{
        cell.lockImageView.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + _starIndex > _nowMapIndex) {
        return;
    }
    
    NSLog(@"%ld",indexPath.row);
    if (_selectSceneBlock) {
        _selectSceneBlock(indexPath.row + 1 + _starIndex);
    }
}

@end
