//
//  AnimationSquirrelNode.m
//  begin
//
//  Created by Mac on 2018/11/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AnimationSquirrelNode.h"

@implementation AnimationSquirrelNode
{
    NSTimer *_runTimer;
    __weak BaseNode *_personNode;
}
+ (AnimationSquirrelNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                        personNode:(BaseNode *)personNode
{
    WDTextureManager *manager = [WDTextureManager shareManager];
    AnimationSquirrelNode *node = [AnimationSquirrelNode spriteNodeWithTexture:manager.squirrelRunArr[0]];
    CGFloat x = 800  + arc4random() % 1500;
    CGFloat y = 170 + arc4random() % 170;
    node.position = CGPointMake(x, y);
    node.zPosition = 650 - y - 100;
    node.xScale = arc4random() % 2 == 0 ? 1 : -1;
    node.name = @"squirrel";
    [superNode addChild:node];
    
    SKAction *textureAnimation = [SKAction animateWithTextures:manager.squirrelStayArr timePerFrame:0.15];
    NSInteger count = arc4random() % 50 + 50;
    SKAction *rep = [SKAction repeatAction:textureAnimation count:count];
    [node setRunTimer];
    [node setPersonNode:personNode];
    
    [node runAction:rep completion:^{
        [node runAction];
    }];

    return  node;
}

- (void)setPersonNode:(BaseNode *)personNode
{
    _personNode = personNode;
}

- (void)setRunTimer{
    if (!_runTimer) {
        _runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(canRunAction:) userInfo:nil repeats:YES];
    }else{
        [_runTimer invalidate];
        _runTimer = nil;
    }
}

- (void)runAction{
    
    if (_runTimer) {
        [_runTimer invalidate];
        _runTimer = nil;
    }
    
    [self removeAllActions];
    WDTextureManager *manager = [WDTextureManager shareManager];
    SKAction *runAction = [SKAction animateWithTextures:manager.squirrelRunArr timePerFrame:0.1];
    SKAction *repAction = [SKAction repeatActionForever:runAction];
    [self runAction:repAction];
    
    
    BOOL personIsLeft = [WDCalculateTool personIsLeft:_personNode.position monsterPoint:self.position];
    NSInteger xScale = personIsLeft == YES ? -1 : 1;
    self.xScale = xScale;
    //反方向跑
    CGFloat xD = xScale * (700 + arc4random() % 200);
    CGPoint movePoint = CGPointMake(xD + self.position.x, self.position.y);
    SKAction *moveAction = [SKAction moveTo:movePoint duration:4];
    SKAction *waitAction = [SKAction waitForDuration:arc4random() % 4];
    SKAction *hiddenAction = [SKAction fadeAlphaTo:0 duration:0.2];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[moveAction,hiddenAction,waitAction,removeAction]];
    
    
    __weak typeof(self)weakSelf = self;
    [self runAction:seq completion:^{
        [weakSelf createNodeAgain];
    }];
}

- (void)canRunAction:(NSTimer *)timer
{
    CGFloat distanceX = _personNode.position.x - self.position.x;
    
    if (fabs(distanceX) < 100) {
        [self runAction];
    }
    
    if (_personNode == nil) {
        [timer invalidate];
    }
}

- (void)createNodeAgain
{
    if (_personNode && !_personNode.isDeadIng) {
         [AnimationSquirrelNode createNodeWithSuperNode:(BaseNode *)_personNode.parent personNode:_personNode];
    }
   
}

@end
