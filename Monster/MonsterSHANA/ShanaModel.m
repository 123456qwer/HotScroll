//
//  ShanaModel.m
//  HotSchool
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "ShanaModel.h"

@implementation ShanaModel
- (void)setTextures
{
    [self setMoveArrWithPicName:@"person2_move_" count:8];
    [self setStayArrWithPicName:@"person2_stay_" count:4];
    _beAttack = [SKTexture textureWithImage:[UIImage imageNamed:@"person2_beAttack"]];
    _skill1Arr  = [self attackArrWithName:@"person2_attack4_" count:13];
    _skill2Arr  = [self attackArrWithName:@"person2_attack5_" count:8];
    self.moveArr = [self attackArrWithName:@"person2_move_" count:8];
    NSMutableArray *arr = [NSMutableArray array];
    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"person2_attack7_1"]];
    [arr addObject:texture];
    [arr addObject:texture];
    
    for (int i = 0; i < 11; i ++) {
        NSString *picNameStr = [NSString stringWithFormat:@"person2_attack7_%d",i+1];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:picNameStr]];
        [arr addObject:texture];
    }
    
    _skill3Arr = arr;
    
    self.missArr = [self attackArrWithName:@"shana_miss_" count:8];
    self.winArr     = [self attackArrWithName:@"person2_win_" count:8];
    _attack1Arr = [self attackArrWithName:@"person2_attack_" count:5];
    _attack2Arr = [self attackArrWithName:@"person2_attack2_" count:9];
    _attack3Arr = [self attackArrWithName:@"person2_attack3_" count:7];
    _attack4Arr = [self attackArrWithName:@"person2_attack6_" count:11];
    self.beAttackArr = [self attackArrWithName:@"person2_beAttack_" count:6];

    self.beAttackTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"person2_beAttack"]];
    self.name = @"shana";
}

- (NSMutableArray <SKTexture *>*)attackArrWithName:(NSString *)name
                                             count:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        NSString *picNameStr = [NSString stringWithFormat:@"%@%d",name,i+1];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:picNameStr]];
        [arr addObject:texture];
    }
    
    return arr;
}

- (void)dealloc
{
    NSLog(@"夏娜model释放了！！！");
}

@end
