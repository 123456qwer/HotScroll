//
//  ThiefMonster.m
//  HotSchool
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "ThiefMonster.h"
#import "ThiefModel.h"
@implementation ThiefMonster
{
    ThiefModel    *_model;
    NSInteger      _hiddenAttackPercent; //隐身攻击概率<攻击到<3-8>的随机次数，会发呆2秒钟任人宰割>
    NSInteger      _hiddenAttackCount;   //隐身估计触发次数
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    self.delegate = self;
    self.monsterDelegate = self;
    self.min_X_Distance = 100;
    self.min_Y_Distance = 100;
    
    _model = (ThiefModel *)model;
    [self createBlackCircle];
    self.model = _model;
    
    self.wdSpeed = 2;
    self.wdBlood = 100;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 15;
    
    //[self realBackGroundWithColor:[UIColor orangeColor]];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 100) center:CGPointMake(0, 0)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = MONSTER_CATEGORY;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = MONSTER_COLLISION;
    self.physicsBody = body;
    
    [self setRandomAttackNumber];
    
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.6;
    self.yScale = 1.6;
    
}

- (void)setPhy{
    self.physicsBody.categoryBitMask = MONSTER_CATEGORY;
    self.physicsBody.contactTestBitMask = MONSTER_CONTACT;
    self.physicsBody.collisionBitMask = MONSTER_COLLISION;
}

- (void)setRandomAttackNumber
{
    ///<2-4>
    _hiddenAttackPercent = arc4random() % 2 + 2;
    _hiddenAttackCount = 0;
//    _hiddenAttackPercent = 3;
}

- (void)monsterAttackAction
{
    if ([self isCanNotAttack]) {
        return;
    }
    
    if (_hiddenAttackCount >= _hiddenAttackPercent) {
        [self stayAction];
        return;
    }
    
    [self removeAllActions];
    SKAction *attack = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.1];
    SKAction *alpha  = [SKAction fadeAlphaTo:1 duration:0.15];
    SKAction *gro = [SKAction group:@[attack,_model.musicAttackAction,alpha]];
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isAttackIng = NO;
    }];
    [self performSelector:@selector(attackAction) withObject:nil afterDelay:0.1 * 3];
}

//破隐攻击
- (void)hiddenAndMoveAction
{
    if ([self isCanNotAttack]) {
        return;
    }
    
    //当隐身攻击次数触发最高点，触发发愣状态
    if (_hiddenAttackCount >= _hiddenAttackPercent) {
        [self stayAction];
        return;
    }
    
    _hiddenAttackCount ++;
    [self removeAllActions];
    SKSpriteNode *smokeNode = [SKSpriteNode spriteNodeWithTexture:_model.hiddenArr[0]];
    smokeNode.position = self.position;
    smokeNode.zPosition = 10000;
    smokeNode.alpha = 0;
    [self.parent addChild:smokeNode];
    
    SKAction *smokeA = [SKAction animateWithTextures:_model.hiddenArr timePerFrame:0.1];
    SKAction *repeatA  = [SKAction repeatAction:smokeA count:2];
    SKAction *smokeShow = [SKAction fadeAlphaTo:1 duration:0.3];
    SKAction *smokeHidden = [SKAction fadeAlphaTo:0 duration:0.9];
    SKAction *removeS = [SKAction removeFromParent];
    SKAction *seqS = [SKAction sequence:@[smokeShow,smokeHidden]];
    SKAction *groS = [SKAction group:@[seqS,repeatA]];
    SKAction *seqST = [SKAction sequence:@[_model.musicWindAction,groS,removeS]];
    
    SKAction *pAlpha = [SKAction fadeAlphaTo:0 duration:0.8];
    __weak typeof(self)weakSelf = self;
    [self runAction:pAlpha completion:^{
        [weakSelf hiddenMoveAction];
    }];
    
    [smokeNode runAction:seqST];
    
    
}

- (void)hiddenMoveAction
{
    SKAction *showPerson = [SKAction fadeAlphaTo:1 duration:0.2];
    self.position = self.personNode.position;
    __weak typeof(self)weakSelf = self;
    [self runAction:showPerson completion:^{
        weakSelf.isAttackIng = NO;
    }];
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
    
    
    CGFloat bigDistance = 150;
    
    if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
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


//这里特殊处理，隐身攻击后发呆0.2 * 4 * 4秒<3.2>
- (void)stayAction
{
    [self removeAllActions];
    
    SKAction *dropAction = [SKAction moveToY:0 duration:3.2 / 5.0];
    SKAction *alphaA = [SKAction fadeAlphaTo:0 duration:3.2 / 5.0];
    SKAction *gro = [SKAction group:@[dropAction,alphaA]];
    
    SKAction *dropAction2 = [SKAction moveToY:30 duration:0];
    SKAction *alphaB = [SKAction fadeAlphaTo:1 duration:0];
    SKAction *seqA = [SKAction sequence:@[dropAction2,alphaB]];
    
    SKAction *repC = [SKAction sequence:@[gro,seqA]];
    
    SKAction *repAction  = [SKAction repeatAction:repC count:5];
    
    SKAction *remo = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[repAction,remo]];
    
    BaseNode *dropNode = [BaseNode spriteNodeWithTexture:_model.dropTexture];
    dropNode.zPosition = 10000;
    dropNode.position = CGPointMake(dropNode.position.x, 30);
    dropNode.name = @"drop";
    [self addChild:dropNode];
    [dropNode runAction:seq];
    
    
    SKAction *stayAction = [SKAction animateWithTextures:_model.stayArr timePerFrame:0.2];
    SKAction *rep = [SKAction repeatAction:stayAction count:4];
    __weak typeof(self)weakSelf = self;
    [self runAction:rep completion:^{
        weakSelf.isAttackIng = NO;
        [weakSelf setRandomAttackNumber];
    }];
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
    
    //当隐身攻击次数触发最高点，触发发愣状态
    if (_hiddenAttackCount >= _hiddenAttackPercent) {
        self.isAttackIng = YES;
        [self stayAction];
        return;
    }
    
    
    if (fabs(distanceX) > 450 ) {
        [self hiddenAndMoveAction];
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

- (void)thiefMissAction
{
    [WDActionTool missAnimation:self];
    
    if ([self isCanNotAttack]) {
        return;
    }
    
    SKAction *missAction = [SKAction fadeAlphaTo:0.1 duration:0.15];
    SKAction *miss2 = [SKAction fadeAlphaTo:1 duration:0.15];
    SKAction *seq = [SKAction sequence:@[missAction,miss2]];
    __weak typeof(self)weakSelf = self;
    [self runAction:seq completion:^{
        weakSelf.isAttackIng = NO;
    }];
}



@end
