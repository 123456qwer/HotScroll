//
//  Person1Model.m
//  HotSchool
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "Person1Model.h"

@implementation Person1Model

- (void)setStayArrWithPicName:(NSString *)stayPicName
                        count:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++ ) {
        NSString *moveNameStr = [NSString stringWithFormat:@"%@%d",stayPicName,i+1];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:moveNameStr]];
        [arr addObject:texture];
    }
    [arr removeObjectAtIndex:0];
    self.stayArr = arr;
}

- (void)setTextures
{
    self.name = @"person";
    _attack1MusicAction = [SKAction playSoundFileNamed:@"attack1" waitForCompletion:NO];
    _attack2MusicAction = [SKAction playSoundFileNamed:@"attack2" waitForCompletion:NO];
    _attack3MusicAction = [SKAction playSoundFileNamed:@"attack3" waitForCompletion:NO];
    _attack4MusicAction = [SKAction playSoundFileNamed:@"attack4" waitForCompletion:NO];

    _skill4MusicAction  = [SKAction playSoundFileNamed:@"skill4" waitForCompletion:NO];
    _skill1MusicAction  = [SKAction playSoundFileNamed:@"skill1" waitForCompletion:NO];
    _skill2MusicAction  = [SKAction playSoundFileNamed:@"skill2" waitForCompletion:NO];

    self.winArr     = [self attackArrWithName:@"person1_win_" count:5];
    _attack1Arr = [self attackArrWithName:@"person1_attack_" count:5]; //加速版
   
   // _attack1Arr = [self attackArrWithName:@"person1_attack_" count:8];   //完整版

    _attack2Arr = [self attackArrWithName:@"person1_attack2_" count:7];
    _skill1LightArr = [self attackArrWithName:@"person1_skill1_" count:6];
    _skill4LightArr = [self attackArrWithName:@"person1_skill4_" count:5];
    _skill3LightArr = [self attackArrWithName:@"person1_skill3_" count:11];
    _skill2LightArr = [self attackArrWithName:@"person1_skill22_" count:8];
    NSArray *j = [self attackArrWithName:@"person1_jump_" count:5];
    
    NSMutableArray *jump = [NSMutableArray arrayWithCapacity:j.count];
    for (NSInteger i = j.count - 1; i >=0; i--) {
        SKTexture *texture = j[i];
        [jump addObject:texture];
    }
    
    self.jumpArr = jump;
    
    [self setMoveArrWithPicName:@"person1_run_" count:8];
    [self setStayArrWithPicName:@"person1_staty_" count:3];
    NSMutableArray *arr3 = [self attackArrWithName:@"person1_attack3_" count:9];
    for (int i = 0; i < 3; i ++) {
        [arr3 removeObjectAtIndex:0];
    }
//    [arr3 removeLastObject];
//    [arr3 removeLastObject];
    _attack3Arr = arr3;
    
    _attack4Arr = [self attackArrWithName:@"person1_attack4_" count:8];
    
    
    _attack5Arr = [self attackArrWithName:@"person1_attack5_" count:9];
    NSMutableArray *arr2 = [NSMutableArray array];
    [arr2 addObjectsFromArray:self.attack1Arr];
    [arr2 addObjectsFromArray:self.attack2Arr];
    [arr2 addObjectsFromArray:self.attack3Arr];
    [arr2 addObjectsFromArray:self.attack4Arr];
    //[arr2 addObjectsFromArray:_attack5Arr];
    _attackFastArr = arr2;
    
    _skill1Arr = [self attackArrWithName:@"person1_skill_" count:9];
    _skill2Arr = [self attackArrWithName:@"person1_skill2_" count:9];
    self.beAttackArr = [self attackArrWithName:@"person1_beAttack_" count:6];
    self.beAttack = [SKTexture textureWithImage:[UIImage imageNamed:@"person1_beAttack2"]];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 10; i ++ ) {
        NSString *picNameStr;
        if (i >= 1) {
           picNameStr = [NSString stringWithFormat:@"person1_defense_%d",2];
        }else{
           picNameStr = [NSString stringWithFormat:@"person1_defense_%d",i+1];
        }
        
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:picNameStr]];
        [arr addObject:texture];
    }
    _defenseArr = arr;
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

@end
