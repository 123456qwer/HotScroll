//
//  ShooterModel.m
//  HotSchool
//
//  Created by 吴冬 on 2018/7/29.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "ShooterModel.h"

@implementation ShooterModel

- (void)setTextures{
    self.arrowTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"arrow"]];
    [self setMoveArrWithPicName:@"bowman_move_" count:5];
    self.attack1Arr = [self textureArrayWithName:@"bowman_attack_" count:10];
    self.beAttackTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"bowman_beAttack"]];
    self.arrowMusicAction = [SKAction playSoundFileNamed:@"arrow" waitForCompletion:NO];
    self.name = @"射手";
}

@end
