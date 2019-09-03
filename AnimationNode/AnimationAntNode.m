//
//  AnimationAntNode.m
//  HotSchool
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AnimationAntNode.h"

@implementation AnimationAntNode

+ (AnimationAntNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                               maxX:(CGFloat)maxX
                                               maxY:(CGFloat)maxY
{
    WDTextureManager *manager = [WDTextureManager shareManager];
    
    //1.5
    SKAction *flyAnimation = [SKAction animateWithTextures:manager.antUpMoveArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:flyAnimation];
    
    AnimationAntNode *node = [AnimationAntNode spriteNodeWithTexture:manager.antUpMoveArr[0]];
    node.zPosition = 10000;
    node.xScale = 0.5;
    node.yScale = 0.5;
    node.position = CGPointMake(1000, 400);
    node.name = @"ant";
    
    [superNode addChild:node];
    
    [node runAction:rep completion:^{
    }];
    
    return node;
    
}

@end
