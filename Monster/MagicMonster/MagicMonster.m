//
//  MagicMonster.m
//  begin
//
//  Created by Mac on 2018/11/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "MagicMonster.h"
#import "MagicModel.h"
@implementation MagicMonster
{
    MagicModel *_model;
    __weak BaseNode *_personNode;
    SKSpriteNode *_blackCircleNode;
    NSTimer  *_attackTimer;
    NSTimer  *_blinkTimer;
    CADisplayLink *_fireLink;
}



- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    self.delegate = self;
  
    self.monsterDelegate = self;
    _model = (MagicModel *)model;
    [self createBlackCircle];
    self.model = _model;
    
    self.wdSpeed = 2;
    self.wdBlood = 150;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 30;
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.7;
    self.yScale = 1.7;
    

    self.imageWidth = 50;
    self.imageHeight = 80;
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50 * 1.7, 80 * 1.7) center:CGPointMake(0, 0)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = 0;
    self.physicsBody = body;
    
    //_attackTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(aaa) userInfo:nil repeats:YES];
   // [self aaa];
    [self meteoriteAttack];
    /*
    _blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(blinkAction:) userInfo:nil repeats:YES];
     */
}

- (void)blinkAction:(NSTimer *)timer
{
    CGPoint personPosition = _personNode.position;
    CGFloat distanceX = self.position.x - personPosition.x;
    
    NSInteger direction = 1;
    if (distanceX > 0) {
        direction = 1;
    }else{
        direction = -1;
    }
    
    self.xScale = direction * -1 * fabs(self.xScale);
   
    
    CGFloat x = self.position.x + direction * 500;
    CGFloat y = arc4random() % 300 + self.imageHeight;
    if (x > 2885 - kScreenWidth / 2.0) {
        x = _personNode.position.x - 500 - kScreenWidth / 2.0;
    }else if(x < 0 + kScreenWidth / 2.0){
        x = _personNode.position.x + 500 + kScreenWidth / 2.0;
    }
    
    if (fabs(distanceX) < 250) {
        //[self removeAllActions];
        self.isAttackIng = NO;
        //self.alpha = 1;
        SKAction *alphaAction = [SKAction fadeAlphaTo:0 duration:0.2];
        SKAction *moveAction  = [SKAction moveTo:CGPointMake(x, y) duration:0.01];
        SKAction *apearAction = [SKAction fadeAlphaTo:1 duration:0.2];
        __weak typeof(self)weakSelf = self;
        [self runAction:[SKAction sequence:@[alphaAction,moveAction,apearAction]] completion:^{
            [weakSelf meteoriteAttack];
        }];
    }else{
        //[self aaa];
    }
}

- (void)meteoriteAttack{
  
    if ([self isCanNotAttack]) {
        return;
    }
    
    if ([self.personNode isDeadIng]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        return;
    }
    
    SKAction *attackAction = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.1];
    SKAction *repAction = [SKAction repeatAction:attackAction count:3];
    SKAction *gro = [SKAction group:@[_model.musicAttackAction,repAction]];

    //__weak typeof(self)weakSelf = self;
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:_model.attack1Arr.count * 0.1];
    [self runAction:gro completion:^{
        
    }];

}
   

- (void)setPersonNode:(BaseNode *)personNode
{
    [super setPersonNode:personNode];
    _personNode = personNode;
}


/** 陨石攻击 */
- (void)meteoriteAttackWithCount:(NSInteger)count
{
    BaseNode *meteoriteShadow = [BaseNode spriteNodeWithTexture:_model.shadowTexture];
    meteoriteShadow.zPosition = self.personNode.zPosition - 10;
    meteoriteShadow.position = CGPointMake(self.personNode.position.x + 5, self.personNode.position.y - 80);
    [self.personNode.parent addChild:meteoriteShadow];
    meteoriteShadow.name = @"meteoriteShadow";
    meteoriteShadow.alpha = 0.1;
    
    NSTimeInterval time = 1.5;
    
    SKAction *mShadowAlphaAction = [SKAction fadeAlphaBy:0.8 duration:time];
    SKAction *removeAction = [SKAction removeFromParent];
    
    SKAction *xyScale = [SKAction scaleXTo:2.0 y:2.0 duration:time];
    SKAction *seq = [SKAction sequence:@[mShadowAlphaAction,removeAction]];
    SKAction *gro = [SKAction group:@[xyScale,seq]];
    
    [meteoriteShadow runAction:gro];
    
    BaseNode *targetNode = [BaseNode new];
    targetNode.zPosition = 100000;
    targetNode.position = meteoriteShadow.position;
    targetNode.size = CGSizeMake(500, 500);
    targetNode.name = @"target";
    [self.parent addChild:targetNode];
    
    SKEmitterNode *fireNode = [SKEmitterNode nodeWithFileNamed:@"Fire"];
    fireNode.position = CGPointMake(self.personNode.position.x + 600, self.personNode.position.y + 600);
    fireNode.zPosition = 10000;
    fireNode.name     = @"fffff";
    fireNode.particleLifetimeRange = 0.5;
    [self.parent addChild:fireNode];
    
    fireNode.targetNode = targetNode;
    
    SKAction *moveAction = [SKAction moveTo:meteoriteShadow.position duration:time];
    SKAction *scaleAction = [SKAction scaleTo:15.0 duration:time];
    SKAction *gro2 = [SKAction group:@[moveAction,scaleAction]];
    SKAction *seq2 = [SKAction sequence:@[gro2,[SKAction removeFromParent]]];
    seq.timingMode = SKActionTimingEaseOut;
    
    __weak typeof(self)weakSelf = self;
    __block MagicModel *model = _model;
    __block BaseNode *parentNode = (BaseNode *)self.parent;
    [fireNode runAction:seq2 completion:^{
        [targetNode removeFromParent];
        weakSelf.isAttackIng = NO;
        BaseNode *boomNode = [BaseNode spriteNodeWithTexture:model.meteoriteArr2[1]];
        boomNode.position = CGPointMake(fireNode.position.x + 40, fireNode.position.y + 120);
        boomNode.zPosition = 2000;
        boomNode.xScale = 2.0;
        boomNode.yScale = 2.0;
        boomNode.name = @"meteorite1";
        boomNode.wdAttack = 30;
        boomNode.alpha = 0.6;
        [parentNode addChild:boomNode];
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100, 150) center:CGPointMake(0, 0)];
        body.allowsRotation = NO;
        body.affectedByGravity = NO;
        body.categoryBitMask = 0;
        body.contactTestBitMask = MONSTER_CONTACT;
        body.collisionBitMask = 0;
        boomNode.physicsBody = body;
        
        SKAction *fireAction2 = [SKAction animateWithTextures:[model.meteoriteArr2 subarrayWithRange:NSMakeRange(1, model.meteoriteArr2.count - 1)] timePerFrame:0.1];
        SKAction *removeAction = [SKAction removeFromParent];
        [boomNode runAction:[SKAction sequence:@[model.musicFireAction,fireAction2,removeAction]]];
    }];
}

#pragma mark BaseDelegate
- (void)beAttackAction:(BOOL)attackerIsLeft attackCount:(CGFloat)count {
    
    if (!_personNode.isSkillAttackIng) {
        [WDActionTool missAnimation:self];
        return;
    }
    
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

#pragma mark MonsterDelegate
- (void)monsterMoveAction:(BaseNode *)personNode {
    if (self.isAttackIng || self.isBeAttackIng || self.isDeadIng) {
        return;
    }
    
    CGFloat personX = personNode.position.x;
    CGFloat personY = personNode.position.y;
    
    CGFloat monsterX = self.position.x;
    CGFloat monsterY = self.position.y;
    
    NSInteger distanceX = personX - monsterX;
    NSInteger distanceY = personY - monsterY;
    
    CGFloat moveX = monsterX;
    CGFloat moveY = monsterY;
    
    if (distanceX > 0) {
        
        self.xScale = 1 * fabs(self.xScale);
        if (fabs(distanceX) <= 400 && fabs(distanceX) >= 380) {
            moveX = monsterX;
        }else if (fabs(distanceX) >= 400) {
            moveX = monsterX + self.wdSpeed;
        }else{
            moveX = monsterX - self.wdSpeed;
        }
        
        //贴边的情况
        if (moveX <= 130 + kScreenWidth / 2.0) {
            SKAction *moveAction = [SKAction moveTo:CGPointMake(self.position.x + 300 / 2.0 + kScreenWidth / 2.0, personY) duration:0.6];
            [self runAction:moveAction completion:^{
            }];
            
            return;
        }
        
    }else if(distanceX < 0){
        
        self.xScale = -1 * fabs(self.xScale);
        if (fabs(distanceX) <= 400 && fabs(distanceX) >= 380) {
            moveX = monsterX;
            
            
        }else if (fabs(distanceX) >= 400) {
            moveX = monsterX - self.wdSpeed;
        }else{
            moveX = monsterX + self.wdSpeed;
        }
        
        //贴边的情况
        if (moveX >= 2370 - kScreenWidth / 2.0) {
            SKAction *moveAction = [SKAction moveTo:CGPointMake(self.position.x - 300 -  kScreenWidth / 2.0, personY) duration:0.6];
            [self runAction:moveAction completion:^{
            }];
            
            return;
        }
    }
    
    
    CGFloat farX = arc4random() % 500 + 400;
    CGFloat minX = arc4random() % 150 + 50;
    if (fabs(distanceY) < 10 && fabs(distanceX) > minX && fabs(distanceX) < farX) {
        [self monsterAttackAction];
        return;
    }else if(fabs(distanceY) < 10 && fabs(distanceY) > 0){
        moveY = monsterY;
    }else if(distanceY > 0){
        moveY = monsterY + self.wdSpeed;
    }else if(distanceY < 0){
        moveY = monsterY - self.wdSpeed;
    }
    
    CGPoint calculatePoint = [WDCalculateTool calculateMaxMoveXAndY:CGPointMake(moveX, moveY) maxX:2500 maxY:650 personSize:self.size];
    
    self.position = calculatePoint;
    self.zPosition = 650 - self.position.y;
    if (!self.isMoveIng) {
        
        self.isMoveIng = YES;
        //5张
        SKAction *moveAction = [SKAction animateWithTextures:_model.moveArr timePerFrame:0.15];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

- (void)monsterAttackAction
{
    [self meteoriteAttack];
}

- (void)clearAction
{
    [super clearAction];
   
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (_attackTimer) {
        [_attackTimer invalidate];
        _attackTimer = nil;
    }
    
    if (_blinkTimer) {
        [_blinkTimer invalidate];
        _blinkTimer = nil;
    }
}

@end
