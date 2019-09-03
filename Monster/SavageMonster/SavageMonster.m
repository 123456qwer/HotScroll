//
//  SavageMonster.m
//  HotSchool
//
//  Created by Mac on 2018/8/22.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "SavageMonster.h"
#import "SavageModel.h"
@implementation SavageMonster
{
    __weak BaseNode *_personNode;
    CADisplayLink *_attackLink;
    SavageModel    *_model;
    NSInteger      _circleAttackCount; //记录转圈攻击次数
    NSInteger      _attackNumber;      //记录普攻次数
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    self.delegate = self;
    self.monsterDelegate = self;
    _model = (SavageModel *)model;
    
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    

    self.position = CGPointMake(x, y);
    self.xScale = 1.6;
    self.yScale = 1.6;
    
    self.wdSpeed = 2;
    self.wdBlood = 500;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 80;
    
    self.min_X_Distance = 150;
    self.min_Y_Distance = 100;
    
    self.imageWidth = self.size.width / 2.0;
    self.imageHeight = self.size.height / 2.0;
    
    [self setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
   // [self centerSprite:[UIColor cyanColor]];
   // [self physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(150, 130) position:CGPointMake(0, 0)];

}

- (void)rotateAttackAction
{
    [self stopAttckLink];
   
    _circleAttackCount = 10;

    _attackLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(circleAttack)];
    [_attackLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self removeAllActions];
    //4张图片 4 * 0.1 * 10
    SKAction *attack1 = [SKAction animateWithTextures:_model.attack3Arr timePerFrame:0.1];
    SKAction *repAction = [SKAction repeatAction:attack1 count:10];
    __weak typeof(self)weakSelf = self;
    [self runAction:repAction completion:^{
        weakSelf.isAttackIng = NO;
        [weakSelf stopAttckLink];
    }];
    
    //5张
    BaseNode *smokeNode = [BaseNode spriteNodeWithTexture:_model.rotateArr[0]];
    SKAction *action = [SKAction animateWithTextures:_model.rotateArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatAction:action count:7];
    [smokeNode runAction:[SKAction sequence:@[rep,[SKAction removeFromParent]]]];
    [self addChild:smokeNode];
    
    
    [self performSelector:@selector(circleAttackForDemage) withObject:nil afterDelay:0.2];
}

- (void)circleAttackForDemage
{
    _circleAttackCount -- ;
    if (_circleAttackCount <= 0) {
        return;
    }
    [self attackAction];
    [self performSelector:@selector(circleAttackForDemage) withObject:nil afterDelay:0.4];
    
}

- (void)stopAttckLink
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _circleAttackCount = 0;
    if (_attackLink) {
        [_attackLink invalidate];
        _attackLink = nil;
    }
}

- (void)monsterAttackAction
{
    if ([self isCanNotAttack]) {
        return;
    }

    _attackNumber ++;
    if (_attackNumber >= 2) {
        _attackNumber = 0;
        [self rotateAttackAction];
    }else{
        NSInteger random = arc4random() % 2;
        if (random == 0) {
            [self attack1Action];
        }else if(random == 1){
            [self attack2Action];
        }
    }
    

}

- (void)attack2Action
{
    [self removeAllActions];
    SKAction *attack2 = [SKAction animateWithTextures:_model.attack2Arr timePerFrame:0.15];
    __weak typeof(self)weakSelf = self;
    [self runAction:attack2 completion:^{
        weakSelf.isAttackIng = NO;
    }];
    
    [self performSelector:@selector(attackAction) withObject:nil afterDelay:0.15 * 3];
}

- (void)attack1Action
{
    [self removeAllActions];
    SKAction *attack1 = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.15];
    __weak typeof(self)weakSelf = self;
    [self runAction:attack1 completion:^{
        weakSelf.isAttackIng = NO;
    }];
    
    [self performSelector:@selector(attackAction) withObject:nil afterDelay:0.15 * 5];
}

- (void)attackAction
{
    if (self.isBeAttackIng) {
        return;
    }
    
    CGFloat distanceX = self.position.x - self.personNode.position.x;
    CGFloat distanceY = self.position.y - self.personNode.position.y;
    
    BOOL isLeft = NO;
    if (distanceX < 0) {
        isLeft = YES;
    }
    
    CGFloat fudongNumber = arc4random() % 40 + self.wdAttack;
    
    
    CGFloat bigDistance = 150;
    
    if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
        [self.personNode.delegate beAttackAction:isLeft attackCount:fudongNumber];
    }
    
}

- (void)monsterMoveAction:(BaseNode *)personNode
{
    if ([self isCanNotMove]) {
        return;
    }
    
    CGFloat distanceX = self.position.x - personNode.position.x;
    CGFloat distanceY = self.position.y - personNode.position.y;
    
    //距离太紧，直接攻击
    if (fabs(distanceX) < self.min_X_Distance && fabs(distanceY) < self.min_Y_Distance) {
        [self monsterAttackAction];
        return;
    }
    
    CGFloat bigX;
    CGFloat bigY;
    
    NSInteger xDirection = 1;
    NSInteger yDirection = 1;
    if (distanceX > 0) {
        bigX = self.position.x;
        xDirection = -1;
    }else{
        bigX = personNode.position.x;
        xDirection = 1;
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



- (void)circleAttack
{
    [self attackMove:self.personNode.position];
}

- (void)attackMove:(CGPoint)personPosition
{
    
    CGFloat distanceX = self.position.x - personPosition.x;
    CGFloat distanceY = self.position.y - personPosition.y;
 
    if (fabs(distanceX) < 100) {
        return;
    }
    
    CGFloat bigX;
    CGFloat bigY;
    
    NSInteger xDirection = 1;
    NSInteger yDirection = 1;
    if (distanceX > 0) {
        bigX = self.position.x;
        xDirection = -1;
    }else{
        bigX = personPosition.x;
        xDirection = 1;
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
    
    CGFloat moveX = (self.wdSpeed - 1)  * aDX / hypotenuse * xDirection;
    CGFloat moveY = (self.wdSpeed - 1)  * aDY / hypotenuse * yDirection;
    
    
    self.xScale = xDirection * fabs(self.xScale);
    self.position = CGPointMake(self.position.x + moveX, self.position.y + moveY);
    self.zPosition = 650 - self.position.y + 100;
}


- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count
{
    if (self.isDeadIng) {
        return;
    }
    
    if (self.isDeadIng) {
        return;
    }
    
    [WDActionTool demageAnimation:self point:CGPointMake(0, 10) scale:0.5 demagePic:@"demage1"];
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    
    self.wdNowBlood -= count;
    if (self.wdNowBlood <= 0) {
        self.isDeadIng = YES;
        [self.delegate deadAction:attackerIsLeft];
        return;
    }
    
    
    
    CGPoint point;
    if (attackerIsLeft) {
        point = CGPointMake(self.position.x + 40, self.position.y);
    }else{
        point = CGPointMake(self.position.x - 40, self.position.y);
    }
    
    self.position = point;
    
}


- (void)deadAction:(BOOL)attackerIsLeft
{
    [self deadAnimation:attackerIsLeft];
}

- (void)clearAction
{
    [super clearAction];
    
    [self stopAttckLink];
}

@end
