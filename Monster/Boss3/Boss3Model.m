//
//  Boss3Model.m
//  begin
//
//  Created by Mac on 2019/6/5.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "Boss3Model.h"

@implementation Boss3Model
- (void)setTextures
{
    self.moveArr = [self textureArrayWithName:@"boss3_move_" count:10];
    self.winArr  = [self textureArrayWithName:@"boss3_win_" count:10];
    self.diedArr = [self textureArrayWithName:@"boss3_died_" count:15];
    self.beAttackArr = [self textureArrayWithName:@"boss3_beAttack_" count:4];
    self.attackArr1 = [self textureArrayWithName:@"boss3_attack1_" count:20];
    self.attackArr2 = [self textureArrayWithName:@"boss3_attack2_" count:20];
    self.attackArr3 = [self textureArrayWithName:@"boss3_attack3_" count:20];
    self.attackArr4 = [self textureArrayWithName:@"boss3_attack4_" count:20];
    self.attackArr5 = [self textureArrayWithName:@"boss3_attack5_" count:20];
    self.attackArr6 = [self textureArrayWithName:@"boss3_attack6_" count:20];
    self.attackArr7 = [self textureArrayWithName:@"boss3_attack7_" count:14];
    self.attackArr8 = [self textureArrayWithName:@"boss3_attack8_" count:20];
    self.attackArr9 = [self textureArrayWithName:@"boss3_attack9_" count:20];
    self.shadowTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"meteoriteShadow"]];
    self.meteoriteArr1 = [self textureArrayWithName:@"wuqishi_mete_star" count:5];
    self.meteoriteArr2 = [self textureArrayWithName:@"wuqishi_mete2_" count:6];
    self.windArr = [self textureArrayWithName:@"boss3_wind_" count:12];
    self.cloudTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"wizard_cloud"]];
    self.flashArr = [self textureArrayWithName:@"wizard_flash_" count:3];
    [self questionArr];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 8; i ++) {
        int index = i + 7;
        NSString *name = [NSString stringWithFormat:@"boss3_attack7_%d",index];
        UIImage *image = [UIImage imageNamed:name];
        if (!image) {
            break;
        }
        SKTexture *texture = [SKTexture textureWithImage:image];
        [arr addObject:texture];
    }
    self.missArr = arr;
}

@end
