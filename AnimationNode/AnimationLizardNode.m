//
//  AnimationLizardNode.m
//  begin
//
//  Created by Mac on 2018/11/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AnimationLizardNode.h"

@implementation AnimationLizardNode
+ (AnimationLizardNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                            maxX:(CGFloat)maxX
                                            maxY:(CGFloat)maxY
{
    WDTextureManager *manager = [WDTextureManager shareManager];
    
    AnimationLizardNode *node = [AnimationLizardNode spriteNodeWithTexture:manager.lightArr[0]];
    CGFloat x = 1000 + arc4random() % 1000;
    CGFloat y = arc4random() % 10;
    node.position = CGPointMake(x, y);
    node.zPosition = 1;
    node.xScale = 0.15;
    node.yScale = 0.15;
    node.name = @"lizard";
    [superNode addChild:node];
    
    SKAction *textureAnimation = [SKAction animateWithTextures:manager.lizardArr timePerFrame:0.1];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(x - 400, 380) duration:14];
    SKAction *hiddenAction = [SKAction fadeAlphaTo:0 duration:0.15];
    SKAction *remo = [SKAction removeFromParent];
    SKAction *waitAction = [SKAction waitForDuration:arc4random() % 10];
    SKAction *seq = [SKAction sequence:@[moveAction,hiddenAction,waitAction,remo]];
    
    SKAction *repAction = [SKAction repeatActionForever:textureAnimation];
    
    [node runAction:repAction];
    [node runAction:seq completion:^{
        [AnimationLizardNode createNodeWithSuperNode:superNode maxX:maxX maxY:maxY];
    }];
    
    return node;
}


@end
