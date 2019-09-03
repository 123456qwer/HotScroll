//
//  MapCollectionView.h
//  begin
//
//  Created by Mac on 2019/5/10.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,copy)NSArray *mapArr;
@property (nonatomic,copy)NSArray *starArr;
@property (nonatomic,copy)void (^selectSceneBlock)(NSInteger sceneIndex);

/** 第二页 starIndex为12 */
@property (nonatomic,assign)int starIndex;
@end

NS_ASSUME_NONNULL_END
