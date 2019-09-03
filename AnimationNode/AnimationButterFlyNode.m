//
//  AnimationButterFlyNode.m
//  HotSchool
//
//  Created by Mac on 2018/8/7.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AnimationButterFlyNode.h"

@implementation AnimationButterFlyNode
+ (AnimationButterFlyNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                             maxX:(CGFloat)maxX
                                             maxY:(CGFloat)maxY
{
    WDTextureManager *manager = [WDTextureManager shareManager];

    //1.5
    SKAction *flyAnimation = [SKAction animateWithTextures:manager.butterFlyFlyArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:flyAnimation];
    
    AnimationButterFlyNode *node = [AnimationButterFlyNode spriteNodeWithTexture:manager.butterFlyFlyArr[0]];
    node.zPosition = 10000;
    node.xScale = 0.2;
    node.yScale = 0.2;
    node.position = CGPointMake(maxX, maxY);
    node.name = @"butterFly";
    [superNode addChild:node];
    
    [node runAction:rep completion:^{
    }];
    
    return node;
    
}

@end
