//
//  KanaModel.m
//  begin
//
//  Created by Mac on 2019/2/12.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "KanaModel.h"

@implementation KanaModel

- (void)setTextures
{
    NSMutableArray *skill1 = [self textureArrayWithName:@"kana_skill1_" count:5];
    [skill1 addObject:[SKTexture textureWithImage:[UIImage imageNamed:@"kana_skill1_5"]]];
    //[skill1 addObject:[SKTexture textureWithImage:[UIImage imageNamed:@"kana_skill1_5"]]];
    _beAttack = [SKTexture textureWithImage:[UIImage imageNamed:@"kana_beAttack"]];
    _skill1Arr = skill1;
    self.beAttackArr = [self textureArrayWithName:@"kana_dead_" count:3];
    _skill2Arr = [self textureArrayWithName:@"kana_skill2_" count:7];
    _skill3Arr = [self textureArrayWithName:@"kana_skill3_" count:13];
    _skill4Arr = [self textureArrayWithName:@"kana_skill4_" count:8];

    _attack1Arr = [self textureArrayWithName:@"kana_attack1_" count:9];
    _attack2Arr = [self textureArrayWithName:@"kana_attack2_" count:9];

    self.stayArr = [self textureArrayWithName:@"kana_stay_" count:4];
    self.moveArr = [self textureArrayWithName:@"kana_move_" count:8];
    self.winArr  = [self textureArrayWithName:@"kana_win_" count:6];
}

@end
