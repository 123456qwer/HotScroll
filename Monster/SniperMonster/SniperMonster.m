//
//  SniperMonster.m
//  begin
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "SniperMonster.h"
#import "SniperModel.h"
@implementation SniperMonster
{
    CADisplayLink *_starMoveLink;
    NSTimer       *_timer;
    BaseNode    *_star;
    SniperModel *_model;
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
    _model = (SniperModel *)model;
    
    self.imageWidth = 90;
    self.imageHeight = 110;
    [self createBlackCircle];
    [self setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
    
    self.wdSpeed = 1;
    self.wdBlood = 100;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 30;
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
        [weakSelf stopStarTimer];
    }];
    
    [self performSelector:@selector(createSniperStar) withObject:nil afterDelay:0.7];

}

- (void)stopStarTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)createSniperStar
{
    _star = [BaseNode spriteNodeWithTexture:_model.star];
    _star.position = _personNode.position;
    _star.xScale = 2.0;
    _star.yScale = 2.0;
    _star.zPosition = 100000;
    _star.alpha    = 0.7;
    [self.parent addChild:_star];
    
    [_starMoveLink invalidate];
    
    [_timer invalidate];
    _timer = nil;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(starMoveAction) userInfo:nil repeats:YES];

    [self starAttack];
}

- (void)starAttack{

 
    __weak typeof(self)weakSelf = self;
    [_star runAction:[SKAction waitForDuration:0.8] completion:^{
        [weakSelf stopStarTimer];
        [weakSelf laserAction];
    }];
}

- (void)laserAction
{
    [_star removeAllActions];
    SKAction *gr = [SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction removeFromParent]]];
    [_star runAction:gr];
    BaseNode *laserNodel = [BaseNode spriteNodeWithTexture:_model.circle];
    laserNodel.position = CGPointMake(self.directon * 90 + self.position.x, self.position.y);
    laserNodel.zPosition = 1000000;
    laserNodel.model = self.model;
    laserNodel.name = @"laser";
    [self.parent addChild:laserNodel];
    
    SKAction *move = [SKAction moveTo:_star.position duration:0.4];
    [laserNodel setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, 1, 1)];

    [laserNodel runAction:[SKAction sequence:@[move,[SKAction removeFromParent]]]];
}

- (void)starMoveAction
{
    CGFloat personX = _personNode.position.x;
    CGFloat monsterX = self.position.x;
    NSInteger distanceX = personX - monsterX;
  
    if (distanceX > 0) {
        self.xScale = 1 * fabs(self.xScale);
    }else if(distanceX < 0){
        self.xScale = -1 * fabs(self.xScale);
    }
    
    int xDirection;
    int yDirection;
    if (arc4random() % 2 == 0) {
        xDirection = 1;
    }else{
        xDirection = -1;
    }
    
    if (arc4random() % 2 == 0) {
        yDirection = 1;
    }else{
        yDirection = -1;
    }
    
    CGFloat smallM = arc4random() % 30;
    CGFloat x = _personNode.position.x + xDirection * smallM;
    CGFloat y = _personNode.position.y + yDirection * smallM;
    SKAction *move = [SKAction moveTo:CGPointMake(x, y) duration:0.05];
    //_star.position = CGPointMake(x,y);
    [_star runAction:move];
}

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

- (void)clearAction
{
    [super clearAction];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(createSniperStar) object:nil];
    [_star removeFromParent];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
