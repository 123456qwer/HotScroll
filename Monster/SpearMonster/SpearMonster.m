//
//  SpearMonster.m
//  begin
//
//  Created by Mac on 2019/4/22.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "SpearMonster.h"

@implementation SpearMonster
{
    SpearModel  *_model;
    __weak BaseNode *_personNode;
    
    
}
- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.7;
    self.yScale = 1.7;
    
    self.delegate = self;
    self.monsterDelegate = self;
    _model = (SpearModel *)model;
    
    self.imageWidth = 90;
    self.imageHeight = 110;
    [self createBlackCircle];
    self.blackCircleNode.position = CGPointMake(0, -40);

    [self setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
    
    self.wdSpeed = 1;
    self.wdBlood = 100;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 50;
    self.anchorPoint = CGPointMake(0.3, 0.5);

    self.min_X_Distance = 150;
    self.min_Y_Distance = 100;
}

- (void)setPersonNode:(BaseNode *)personNode
{
    [super setPersonNode:personNode];
    _personNode = personNode;
}

- (void)beAttackAction:(BOOL)attackerIsLeft attackCount:(CGFloat)count {
    
    if ([self isCanNotBeAttack]) {
        //return;
    }
    
    if (self.isDeadIng) {
        return;
    }
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(attackAction) object:nil];
    [WDActionTool demageAnimation:self point:CGPointMake(0, 10) scale:0.5 demagePic:@"demage1"];
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    
    self.wdNowBlood -= count;
    if (self.wdNowBlood <= 0) {
        self.isDeadIng = YES;
        [self deadAction:attackerIsLeft];
        return;
    }
    
    
    self.isBeAttackIng = YES;
    
    SKAction *moveTo;
    if (attackerIsLeft) {
        moveTo = [SKAction moveToX:self.position.x + 40 duration:0.3];
    }else{
        moveTo = [SKAction moveToX:self.position.x - 40 duration:0.3];
    }
    
    __weak typeof(self)weakSelf = self;
    [self runAction:moveTo completion:^{
        weakSelf.isBeAttackIng = NO;
    }];
}

- (void)deadAction:(BOOL)attackerIsLeft {
    [self clearAction];
    [self removeAllActions];
    
    SKAction *moveTo;
    if (attackerIsLeft) {
        moveTo = [SKAction moveToX:self.position.x + 150 duration:0.5];
    }else{
        moveTo = [SKAction moveToX:self.position.x - 150 duration:0.5];
    }
    SKAction *alphaAction  = [SKAction fadeAlphaTo:0 duration:0.5];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *gro = [SKAction group:@[moveTo,alphaAction]];
    SKAction *seq = [SKAction sequence:@[gro,removeAction]];
    __weak typeof(self)weakSelf = self;
    [self runAction:seq completion:^{
        if (weakSelf.deadBlock) {
            weakSelf.deadBlock(weakSelf.name);
        }
    }];
    
    return;
}

- (void)monsterAttackAction {
    
    if ([self isCanNotAttack]) {
        return;
    }
    
    SKAction *attackAction = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.1];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:attackAction completion:^{
        weakSelf.isAttackIng = NO;
    }];
    
     [self performSelector:@selector(attackAction) withObject:nil afterDelay:0.1 * 8];
}

- (void)attackAction
{
    
    CGFloat distanceX = self.position.x - self.personNode.position.x;
    CGFloat distanceY = self.position.y - self.personNode.position.y;
    
    BOOL isLeft = NO;
    if (distanceX < 0) {
        isLeft = YES;
    }
    
    CGFloat fudongNumber = arc4random() % 5 + self.wdAttack;
    
    
    CGFloat bigDistance = 200;
    
    if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
        [self.personNode.delegate beAttackAction:isLeft attackCount:fudongNumber];
    }
}

- (void)monsterMoveAction:(BaseNode *)personNode {
    
    NSInteger xDirection = 1;
    CGFloat distanceX = self.position.x - personNode.position.x;
    CGFloat distanceY = self.position.y - personNode.position.y;
    if (distanceX > 0) {
        xDirection = -1;
    }else{
        xDirection = 1;
    }
    self.xScale = xDirection * fabs(self.xScale);
   
    
    if ([self isCanNotMove]) {
        return;
    }

    
    //距离太紧，直接攻击
    if (fabs(distanceX) < self.min_X_Distance && fabs(distanceY) < self.min_Y_Distance) {
        [self monsterAttackAction];
        return;
    }
    
    CGFloat bigX;
    CGFloat bigY;
    
    NSInteger yDirection = 1;
    if (distanceX > 0) {
        bigX = self.position.x;
    }else{
        bigX = personNode.position.x;
    }
    
    if (distanceY > 0) {
        yDirection = -1;
        bigY = self.position.y;
    }else{
        yDirection = 1;
        bigY = personNode.position.y;
    }
    
    CGFloat aDX = fabs(distanceX);
    CGFloat aDY = fabs(distanceY);
    //斜边英文。。。。等比计算
    CGFloat hypotenuse = sqrt(aDX * aDX + aDY * aDY);
    
    CGFloat moveX = self.wdSpeed * aDX / hypotenuse * xDirection;
    CGFloat moveY = self.wdSpeed * aDY / hypotenuse * yDirection;
    
    
    self.xScale = xDirection * fabs(self.xScale);
    self.position = CGPointMake(self.position.x + moveX, self.position.y + moveY);
    self.zPosition = 650 - self.position.y + 100;
    
    if (!self.isMoveIng) {
        
        self.isMoveIng = YES;
        //6张
        SKAction *moveAction = [SKAction animateWithTextures:self.model.moveArr timePerFrame:0.2];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

- (void)clearAction
{
    [super clearAction];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(attackAction) object:nil];
  
}
@end
