//
//  PassDoorModel.m
//  begin
//
//  Created by Mac on 2018/11/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "PassDoorModel.h"

@implementation PassDoorModel
- (void)setTextures
{
    self.animationArr = [self textureArrayWithName:@"passDoor_" count:20];
    self.name = @"passDoor";
}
@end
