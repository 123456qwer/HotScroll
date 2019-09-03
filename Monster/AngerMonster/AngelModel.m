//
//  AngelModel.m
//  HotSchool
//
//  Created by Mac on 2018/10/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AngelModel.h"

@implementation AngelModel

- (void)setTextures
{
    //angel_move_6
    self.moveArr = [self textureArrayWithName:@"angel_move_" count:6];
    self.attack1Arr = [self textureArrayWithName:@"angel_attack_" count:7];
    //self.skill1Arr = [self textureArrayWithName:@"angel_skill" count:10];
    //self.skill2Arr = [self textureArrayWithName:@"angel_skill_" count:4];
    //self.debuffForQuestion = [self questionArr];
    self.name = @"天使";
}
@end
