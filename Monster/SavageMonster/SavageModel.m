//
//  SavageModel.m
//  HotSchool
//
//  Created by Mac on 2018/8/22.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "SavageModel.h"

@implementation SavageModel
- (void)setTextures
{
    self.moveArr = [self textureArrayWithName:@"savage_move_" count:8];
    self.attack1Arr = [self textureArrayWithName:@"savage_attack_" count:6];
    self.attack2Arr = [self textureArrayWithName:@"savage_attack2_" count:6];
    self.attack3Arr = [self textureArrayWithName:@"savage_circleAttack_" count:4];
    self.rotateArr  = [self textureArrayWithName:@"thief_smoke_" count:6];
    self.name = @"野蛮人";
}
@end
