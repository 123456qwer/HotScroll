//
//  MapCollectionViewCell.m
//  begin
//
//  Created by Mac on 2019/5/10.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "MapCollectionViewCell.h"

@implementation MapCollectionViewCell
{
    UIImage *_yellowStar;
    UIImage *_blackStar;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _yellowStar = [UIImage imageNamed:@"star"];
    _blackStar  = [UIImage imageNamed:@"star_black"];
}

- (void)setStarWithStarCount:(NSInteger)starCount
{
    if (starCount == 3) {
        _star1.image = _yellowStar;
        _star2.image = _yellowStar;
        _star3.image = _yellowStar;
    }else if(starCount == 2){
        _star1.image = _blackStar;
        _star2.image = _yellowStar;
        _star3.image = _yellowStar;
    }else if(starCount == 1){
        _star1.image = _blackStar;
        _star2.image = _blackStar;
        _star3.image = _yellowStar;
    }else{
        _star1.image = _blackStar;
        _star2.image = _blackStar;
        _star3.image = _blackStar;
    }
}

@end
