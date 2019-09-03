//
//  SniperModel.m
//  begin
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "SniperModel.h"

@implementation SniperModel
- (void)setTextures
{
  
    self.moveArr = [self textureArrayWithName:@"sniper_move_" count:5];
    self.star = [SKTexture textureWithImage:[UIImage imageNamed:@"sniper_attack_star"]];
    self.circle = [SKTexture textureWithImage:[UIImage imageNamed:@"sniper_circle"]];
    self.blastArr = [self textureArrayWithName:@"sniper_blast_" count:6];
    //self.attack1Arr = [self textureArrayWithName:@"sniper_attack_" count:7];
    self.name = @"阻击手";
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 7; i ++) {
        NSString *name = [NSString stringWithFormat:@"sniper_attack_%d",i + 1];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:name]];
        [arr addObject:texture];
    }
    
    for (int i = 0; i < 12; i ++) {
        NSString *name = @"";
        if (i % 2 == 0) {
            name = @"sniper_attack_6";
        }else{
            name = @"sniper_attack_7";
        }
        
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:name]];
        [arr addObject:texture];
    }
    
    _attack1Arr = arr;
    
}
@end
