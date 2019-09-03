//
//  NPCModel1.m
//  HotSchool
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "NPCModel1.h"

@implementation NPCModel1
- (void)setTextures
{
    self.stayArr = [self textureArrayWithName:@"npc_Base_stay_" count:9];
    self.sitArr  = [self textureArrayWithName:@"npc_Base_sit_" count:6];
    self.learnArr = [self textureArrayWithName:@"npc_Base_learn_" count:2];
    self.name = @"npc1Model";
}

- (void)dealloc
{
    NSLog(@"1");
}

@end
