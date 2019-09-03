//
//  WizardModel.m
//  begin
//
//  Created by Mac on 2018/12/12.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WizardModel.h"

@implementation WizardModel

- (void)setTextures
{
    self.moveArr = [self textureArrayWithName:@"wizard_move_" count:6];
    self.attack1Arr = [self textureArrayWithName:@"wizard_attack_" count:11];
    self.flashArr = [self textureArrayWithName:@"wizard_flash_" count:3];
    self.shadowTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"meteoriteShadow"]];
    self.cloudTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"wizard_cloud"]];
    self.name = @"巫师";
}


@end
