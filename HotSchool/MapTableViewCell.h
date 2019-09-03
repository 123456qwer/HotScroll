//
//  MapTableViewCell.h
//  begin
//
//  Created by Mac on 2019/4/23.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;


/** 根据星星数量显示黄色星星 */
- (void)setStarWithStarCount:(NSInteger)starCount;

@end

NS_ASSUME_NONNULL_END
