//
//  AnimationSeagullNode.m
//  HotSchool
//
//  Created by 吴冬 on 2018/7/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AnimationSeagullNode.h"

@implementation AnimationSeagullNode

+ (AnimationSeagullNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                             maxX:(CGFloat)maxX
                                             maxY:(CGFloat)maxY
{
    WDTextureManager *manager = [WDTextureManager shareManager];
    CGFloat randomX = arc4random() % (NSInteger)(maxX);
    
    //1.5
    SKAction *flyAnimation = [SKAction animateWithTextures:manager.seagullArr timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatAction:flyAnimation count:4];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(randomX, maxY + 100) duration:5.0];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *group = [SKAction group:@[repeatAction,moveAction]];
    SKAction *seq = [SKAction sequence:@[group,removeAction]];
    
    
    AnimationSeagullNode *node = [AnimationSeagullNode spriteNodeWithTexture:manager.seagullArr[0]];
    node.zPosition = 0;
    node.xScale = 3.0;
    node.yScale = 3.0;
    node.position = CGPointMake(0, 0);
    node.name = @"seagull";
    [superNode addChild:node];
    
    [node runAction:seq completion:^{
       // NSLog(@"%@",node);
    }];
    
    return node;
    
}


@end
