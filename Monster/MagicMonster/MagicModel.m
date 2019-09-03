//
//  MagicModel.m
//  begin
//
//  Created by Mac on 2018/11/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "MagicModel.h"

@implementation MagicModel
- (void)setTextures
{
    self.moveArr = [self textureArrayWithName:@"magicMan_move_" count:6];
    self.attack1Arr = [self textureArrayWithName:@"magicMan_attack_" count:10];
    self.shadowTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"meteoriteShadow"]];
    self.meteoriteArr1 = [self textureArrayWithName:@"wuqishi_mete_star" count:5];
    self.meteoriteArr2 = [self textureArrayWithName:@"wuqishi_mete2_" count:6];

    self.name = @"法师";
}
@end
