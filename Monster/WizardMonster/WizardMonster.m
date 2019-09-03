//
//  WizardMonster.m
//  begin
//
//  Created by Mac on 2018/12/12.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WizardMonster.h"
#import "WizardModel.h"
@implementation WizardMonster
{
    WizardModel *_model;
    __weak BaseNode *_personNode;
    
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.6;
    self.yScale = 1.6;
    
    self.delegate = self;
    self.monsterDelegate = self;
    _model = (WizardModel *)model;
    
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
    
    if ([_personNode isDeadIng]) {
        return;
    }
    
    SKAction *attackAction = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.15];
    __weak typeof(self)weakSelf = self;
    [self runAction:attackAction completion:^{
        weakSelf.isAttackIng = NO;
        [weakSelf createCloudNode];
    }];
    
}

- (void)createCloudNode
{
    BaseNode *cloudNode = [BaseNode spriteNodeWithTexture:_model.cloudTexture];
 
    cloudNode.xScale = 0.5;
    cloudNode.yScale = 0.5;
    cloudNode.alpha = 0;
    cloudNode.position = CGPointMake(_personNode.position.x, _personNode.position.y + _personNode.imageHeight + cloudNode.size.height);
    cloudNode.zPosition = 1000;
    cloudNode.name = @"cloud";
    [self.parent addChild:cloudNode];
    
    SKAction *scaleAction = [SKAction scaleTo:0.7 duration:0.5];
    SKAction *alphaA = [SKAction fadeAlphaTo:1 duration:0.5];
    
    SKAction *blinkA = [SKAction fadeAlphaTo:0.9 duration:0.15];
    SKAction *blinkB = [SKAction fadeAlphaTo:1.0 duration:0.15];
    
    SKAction *bSeq = [SKAction sequence:@[blinkA,blinkB]];
    SKAction *gro = [SKAction group:@[scaleAction,alphaA]];
    
    SKAction *rep = [SKAction repeatAction:bSeq count:3];
    SKAction *alphaB = [SKAction fadeAlphaTo:0 duration:0.5];
    SKAction *remo = [SKAction removeFromParent];
    SKAction *seq2 = [SKAction sequence:@[rep,alphaB,remo]];
    
    __weak typeof(self)weakSelf = self;
    [cloudNode runAction:gro completion:^{
        
        [cloudNode runAction:seq2];
        [weakSelf flash:cloudNode.position];
    }];

}

- (void)flash:(CGPoint)point{
    BaseNode *flashNode = [BaseNode spriteNodeWithTexture:_model.flashArr[0]];
    flashNode.position = CGPointMake(point.x, point.y - flashNode.size.height);
    flashNode.zPosition = 999;
    flashNode.xScale = 1.5;
    flashNode.yScale = 1.5;
    flashNode.alpha  = 0.8;
    flashNode.name = @"flash";
    [flashNode setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, flashNode.size.width / 2.0, flashNode.size.height)];
    [self.parent addChild:flashNode];
    //3张图 0.1 * 3 * 3
    SKAction *flashAction = [SKAction animateWithTextures:_model.flashArr timePerFrame:0.1];
    SKAction *repAction = [SKAction repeatAction:flashAction count:3];
    SKAction *seq2 = [SKAction sequence:@[repAction,REMOVE_ACTION]];
    
    [flashNode runAction:seq2 completion:^{
        
    }];
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

@end
