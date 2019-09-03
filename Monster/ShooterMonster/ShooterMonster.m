//
//  ShooterMonster.m
//  HotSchool
//
//  Created by 吴冬 on 2018/7/29.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "ShooterMonster.h"
#import "ShooterModel.h"

@implementation ShooterMonster
{
    ShooterModel *_model;
    SKSpriteNode *_blackCircleNode;
    CADisplayLink *_moveLink;
    __weak BaseNode *_personNode;
    BaseNode *_arrowNode;
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
    
    
    _model = (ShooterModel *)model;
    [self createBlackCircle];
    self.model = _model;

    self.wdSpeed = 1;
    //[self realBackGroundWithColor:[UIColor orangeColor]];
    //[self physicalBackGroundNodeWithColor:[UIColor grayColor] size:CGSizeMake(50, 50) position:CGPointMake(0, 0)];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 100) center:CGPointMake(0, 0)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = MONSTER_CATEGORY;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = MONSTER_COLLISION;
    self.physicsBody = body;
    
    self.wdAttack = 10;
    self.wdBlood  = 40;
    self.wdNowBlood = self.wdBlood;
    
//    SKEmitterNode *node = [SKEmitterNode nodeWithFileNamed:@"Smoke"];
//    node.zPosition = 10000;
//    [self addChild:node];
}

- (void)setPhy{
    self.physicsBody.categoryBitMask = MONSTER_CATEGORY;
    self.physicsBody.contactTestBitMask = MONSTER_CONTACT;
    self.physicsBody.collisionBitMask = MONSTER_COLLISION;
}

- (void)createBlackCircle
{
    [super createBlackCircle];
    _blackCircleNode = self.blackCircleNode;
    _blackCircleNode.position = CGPointMake(0, -47);
}

- (void)setPersonNode:(BaseNode *)personNode
{
    [super setPersonNode:personNode];
    _personNode = personNode;
}

- (void)deadAction
{
    _arrowNode = nil;
    [_arrowNode removeAllActions];
    [_arrowNode removeFromParent];
    
    if (self.deadBlock) {
        self.deadBlock(self.name);
    }
}

- (void)deadAction:(BOOL)attackerIsLeft
{
    _arrowNode.isBeAttackIng = YES;
    [self clearAction];
    [self removeAllActions];
    
    self.texture = _model.beAttackTexture;
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
        [weakSelf deadAction];
    }];
    
    return;
}

//受到技能攻击，打断所有其他正在进行的动作
- (void)beSkillAttackAction:(BOOL)attackerIsLeft
                attackCount:(CGFloat)count
{
    
    if ([self isCanNotBeAttack]) {
        return;
    }
    
    
    [WDActionTool demageAnimation:self point:CGPointMake(0, 10) scale:0.35 demagePic:@"skillDemage"];
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    
    self.wdNowBlood -= count;
    if (self.wdNowBlood <= 0) {
        self.isDeadIng = YES;
        [self deadAction:attackerIsLeft];
        return;
    }

    self.texture = _model.beAttackTexture;
    [self removeAllActions];
    
    //箭矢相当于也被击中
    _arrowNode.isBeAttackIng = YES;
    
    self.isMoveIng = NO;
    self.isAttackIng = NO;
    self.isBeAttackIng = YES;
    
    SKAction *moveTo;
    if (attackerIsLeft) {
        moveTo = [SKAction moveToX:self.position.x + 150 duration:0.3];
    }else{
        moveTo = [SKAction moveToX:self.position.x - 150 duration:0.3];
    }
    __weak typeof(self)weakSelf = self;
    [self runAction:moveTo completion:^{
        weakSelf.isBeAttackIng = NO;
    }];
}

//受到攻击但是不打断其他动作<改为打断释放技能>
- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count
{
    if ([self isCanNotBeAttack]) {
        //return;
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
    
    self.texture = _model.beAttackTexture;
    [self removeAllActions];
    
    //箭矢相当于也被击中
    _arrowNode.isBeAttackIng = YES;
    
    self.isMoveIng = NO;
    self.isAttackIng = NO;
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

- (void)attackAction
{
    if (!self.isBeAttackIng && !self.isAttackIng) {
       
        //攻击状态下，取消之前的所有动作
        [self removeAllActions];
        
        self.isAttackIng = YES;
        self.isMoveIng   = NO;
        SKAction *attackAction = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.15];
        [self runAction:attackAction completion:^{
            self.isAttackIng = NO;
        }];
        

        NSInteger direction = 1;
        if (self.xScale < 0) {
            direction = -1;
        }
     

        BaseNode *node = [BaseNode spriteNodeWithTexture:_model.arrowTexture];
        node.alpha = 0;
        node.xScale = self.xScale;
        node.yScale = self.yScale;
        node.name   = @"arrow";
        node.wdAttack = self.wdAttack;
        node.zPosition = 10000;
        
        //[node physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(20, 20) position:CGPointMake(-10, 0)];
        
        node.position = CGPointMake(self.position.x + direction * 70, self.position.y);
        [self.parent addChild:node];
        
        //记录一下当前创建的箭矢，避免出现人物死亡或被攻击箭矢还在
        _arrowNode = node;
     
        SKAction *wait = [SKAction waitForDuration:0.15 * 8];
        SKAction *waitAction = [SKAction fadeAlphaTo:1 duration:0];
        SKAction *seqW = [SKAction sequence:@[wait,waitAction]];
        __weak typeof(self)weakSelf = self;
        [node runAction:seqW completion:^{
          
            //给箭矢增加物理属性
            SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 40) center:CGPointMake(-20, 0)];
            body.affectedByGravity = NO;
            body.contactTestBitMask = 1;
            body.collisionBitMask   = 0;
            body.categoryBitMask    = 0;
            node.physicsBody = body;
            
            //[node physicalBackGroundNodeWithColor:[UIColor orangeColor] size:node.size position:CGPointMake(0, 0)];
            SKAction *moveAction = [SKAction moveTo:CGPointMake(node.position.x + 500 * self.xScale, self.position.y) duration:1];
            SKAction *removeAction = [SKAction removeFromParent];
            //SKAction *musicAction = weakSelf.model.arrowMusicAction;
            SKAction *seq = [SKAction sequence:@[moveAction,removeAction]];
            
            if (weakSelf.isBeAttackIng || node.isBeAttackIng || node.isDeadIng) {
                [node removeFromParent];
                return ;
            }
            
            [node runAction:seq completion:^{
            }];
        }];
    }
    
}

- (void)monsterMoveAction:(BaseNode *)personNode
{
    [self moveActionWithPersonNodePosition:personNode.position];
}

#pragma mark 怪物移动方法
- (void)moveActionWithPersonNodePosition:(CGPoint)personPosition
{
    if (self.isAttackIng || self.isBeAttackIng || self.isDeadIng) {
        return;
    }
    
    CGFloat personX = personPosition.x;
    CGFloat personY = personPosition.y;
    
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
        [self attackAction];
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

#pragma mark status<状态>
- (void)clearAction
{
    [super clearAction];
}


@end

