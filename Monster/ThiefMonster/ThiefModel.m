//
//  ThiefModel.m
//  HotSchool
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "ThiefModel.h"

@implementation ThiefModel
- (void)setTextures{
  _attack1Arr = [self textureArrayWithName:@"thief_attack_" count:6];
    _hiddenArr  = [self textureArrayWithName:@"thief_smoke_" count:6];
    self.stayArr = [self textureArrayWithName:@"thief_stay_" count:4];
    _dropTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"thief_drop"]];
   NSMutableArray *arr = [self textureArrayWithName:@"thief_move_" count:6];
    [arr removeObjectAtIndex:3];
    self.moveArr = arr;
    self.name = @"盗贼";
}
@end
