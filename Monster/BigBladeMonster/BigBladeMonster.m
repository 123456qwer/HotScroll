//
//  BigBladeMonster.m
//  begin
//
//  Created by Mac on 2019/2/11.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BigBladeMonster.h"
#import "BigBladeModel.h"


@implementation BigBladeMonster
{
    BigBladeModel *_model;
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    self.delegate = self;
    self.monsterDelegate = self;
    self.min_X_Distance = 100;
    self.min_Y_Distance = 100;
    
    _model = (BigBladeModel *)model;
    [self createBlackCircle];
    self.model = _model;
    
    self.wdSpeed = 3;
    self.wdBlood = 400;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 80;
    
    //[self realBackGroundWithColor:[UIColor orangeColor]];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 100) center:CGPointMake(0, 0)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = 0;
    self.physicsBody = body;
    
    
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.6;
    self.yScale = 1.6;
    
}

- (void)setPhy{
    self.physicsBody.categoryBitMask = 0;
    self.physicsBody.contactTestBitMask = MONSTER_CONTACT;
    self.physicsBody.collisionBitMask = 0;
}



- (void)monsterAttackAction
{
    if ([self isCanNotAttack]) {
        return;
    }
    
    
    [self removeAllActions];
    SKAction *attack = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.1];
    SKAction *alpha  = [SKAction fadeAlphaTo:1 duration:0.15];
    SKAction *gro = [SKAction group:@[attack,alpha]];
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isAttackIng = NO;
    }];
    [self performSelector:@selector(attackAction) withObject:nil afterDelay:0.1 * 7];
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
    
    if (fabs(distanceX) < bigDistance && fabs(distanceY) < 150) {
        [self.personNode.delegate beAttackAction:isLeft attackCount:fudongNumber];
    }
}

- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count {
    
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

- (void)deadAction:(BOOL)attackerIsLeft
{
    [self deadAnimation:attackerIsLeft];
}




- (void)monsterMoveAction:(BaseNode *)personNode
{
    [self moveActionWithPersonNodePosition:personNode.position];
}

//一直靠近玩家移动
- (void)moveActionWithPersonNodePosition:(CGPoint)personPosition
{
    NSInteger xDirection = 1;
    CGFloat distanceX = self.position.x - personPosition.x;
    CGFloat distanceY = self.position.y - personPosition.y;
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
        bigX = personPosition.x;
    }
    
    if (distanceY > 0) {
        yDirection = -1;
        bigY = self.position.y;
    }else{
        yDirection = 1;
        bigY = personPosition.y;
    }
    
    CGFloat aDX = fabs(distanceX);
    CGFloat aDY = fabs(distanceY);
    //斜边英文。。。。等比计算
    CGFloat hypotenuse = sqrt(aDX * aDX + aDY * aDY);
    
    CGFloat moveX = self.wdSpeed * aDX / hypotenuse * xDirection;
    CGFloat moveY = self.wdSpeed * aDY / hypotenuse * yDirection;
    
    
    self.xScale = xDirection * fabs(self.xScale);
    self.position = CGPointMake(self.position.x + moveX, self.position.y + moveY);
    self.zPosition = 650 - self.position.y;
    
    if (!self.isMoveIng) {
        
        self.isMoveIng = YES;
        //6张
        SKAction *moveAction = [SKAction animateWithTextures:self.model.moveArr timePerFrame:0.2];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

@end
