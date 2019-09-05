//
//  BowMonster.m
//  begin
//
//  Created by Mac on 2019/4/22.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BowMonster.h"

@implementation BowMonster
{
    BowModel *_model;
    __weak BaseNode *_personNode;
    BaseNode *_arrowNode;
    SKEmitterNode *_greenNode;
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.65;
    self.yScale = 1.65;
    
    self.delegate = self;
    self.monsterDelegate = self;
    _model = (BowModel *)model;
    
    self.imageWidth = 90;
    self.imageHeight = 110;
    [self createBlackCircle];
    [self setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
    
    self.wdSpeed = 2;
    self.wdBlood = 200;
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
    
   
    [_arrowNode removeAllActions];
    [_arrowNode removeFromParent];
     _arrowNode = nil;
   
    [_greenNode removeAllActions];
    
    SKAction *alphaA = [SKAction fadeAlphaTo:0 duration:0.2];
    SKAction *remove = [SKAction removeFromParent];
    [_greenNode runAction:[SKAction sequence:@[alphaA,remove]]];
    
    
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
    
    BaseNode *node = [BaseNode spriteNodeWithTexture:_model.arrowTexture];
    node.alpha = 0;
    node.xScale = self.xScale;
    node.yScale = self.yScale;
    node.name   = @"arrow";
    node.wdAttack = self.wdAttack;
    node.zPosition = 10000;
    
  
    
    
    //[node physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(20, 20) position:CGPointMake(-10, 0)];
    NSInteger direction = 1;
    if (self.xScale < 0) {
        direction = -1;
    }
    
    node.position = CGPointMake(self.position.x + direction * 70, self.position.y + 10);
    [self.parent addChild:node];
  
    //记录一下当前创建的箭矢，避免出现人物死亡或被攻击箭矢还在
    _arrowNode = node;
    
    SKAction *wait = [SKAction waitForDuration:0.1 * 10];
    SKAction *waitAction = [SKAction fadeAlphaTo:1 duration:0];
    SKAction *seqW = [SKAction sequence:@[wait,waitAction]];
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake(node.position.x + 2000 * weakSelf.xScale, weakSelf.position.y) duration:2];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *musicAction = weakSelf.model.arrowMusicAction;
    SKAction *seq = [SKAction sequence:@[moveAction,removeAction]];
    
    SKEmitterNode *blueFire = [SKEmitterNode nodeWithFileNamed:@"BlueFire"];
    _greenNode = blueFire;
    blueFire.zPosition = 20000;
    blueFire.targetNode = weakSelf.parent;
    blueFire.position = node.position;
    blueFire.name = @"blueFire";
    [blueFire runAction:seq completion:^{
    }];
    
    [node runAction:seqW completion:^{
     
        [weakSelf.parent addChild:blueFire];


        //给箭矢增加物理属性
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 40) center:CGPointMake(-20, 0)];
        body.affectedByGravity = NO;
        body.contactTestBitMask = 1;
        body.collisionBitMask   = 0;
        body.categoryBitMask    = 0;
        node.physicsBody = body;
        
        //[node physicalBackGroundNodeWithColor:[UIColor orangeColor] size:node.size position:CGPointMake(0, 0)];
        
        
        if (weakSelf.isBeAttackIng || node.isBeAttackIng || node.isDeadIng) {
            [node removeFromParent];
            return ;
        }
        
        
        [node runAction:seq completion:^{
        }];
        
    }];
    
   // [self performSelector:@selector(createSniperStar) withObject:nil afterDelay:0.7];
    
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
   // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(createSniperStar) object:nil];
 
}
@end
