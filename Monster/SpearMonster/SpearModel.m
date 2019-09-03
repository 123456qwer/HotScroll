//
//  SpearModel.m
//  begin
//
//  Created by Mac on 2019/4/22.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "SpearModel.h"

@implementation SpearModel
- (void)setTextures
{
    NSArray *images = [WDCalculateTool arrWithLine:3 arrange:6 imageSize:CGSizeMake(1020, 510) subImageCount:16 image:[UIImage imageNamed:@"spear"]];
    self.moveArr = [images subarrayWithRange:NSMakeRange(0, 6)];
    self.attack1Arr = [images subarrayWithRange:NSMakeRange(6, images.count - 6)];
}

@end
