//
//  BigBladeModel.m
//  begin
//
//  Created by Mac on 2019/2/11.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BigBladeModel.h"

@implementation BigBladeModel
- (void)setTextures{
    _attack1Arr = [self textureArrayWithName:@"bigBlade_attack_" count:12];
    NSMutableArray *arr = [self textureArrayWithName:@"bigBlade_move_" count:6];
    [arr removeObjectAtIndex:3];
    self.moveArr = arr;
    self.name = @"大刀";
}
@end
