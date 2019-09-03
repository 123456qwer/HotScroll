//
//  Boss3Monster.m
//  begin
//
//  Created by Mac on 2019/6/5.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "Boss3Monster.h"

@implementation Boss3Monster
{
    __weak BaseNode *_personNode;
    Boss3Model *_model;
    NSInteger _index;
    BOOL _canMiss;  //可以一直闪避攻击
    
}
- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    _canMiss = YES;
    
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.5;
    self.yScale = 1.5;
    
    self.delegate = self;
    self.monsterDelegate = self;
    _model = (Boss3Model *)model;
    
    self.imageWidth = 90;
    self.imageHeight = 110;
    [self createBlackCircle];
    self.blackCircleNode.position = CGPointMake(0, -50);
    
    [self setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
    
    self.wdSpeed = 2;
    self.wdBlood = 4000;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 50;
    //self.anchorPoint = CGPointMake(0.3, 0.5);
    
    self.min_X_Distance = 150;
    self.min_Y_Distance = 100;
    
      [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSetBossBloodAction object:@{@"blood":@(4000)}];
}

- (void)setPersonNode:(BaseNode *)personNode
{
    [super setPersonNode:personNode];
    _personNode = personNode;
}

- (void)beAttackAction:(BOOL)attackerIsLeft attackCount:(CGFloat)count {

    if (_canMiss) {
        [self allStatusClear];
        [self removeAllActions];
        [self circleAttackAction];
        
    }else{
        
        if (self.isDeadIng) {
            return;
        }
        
        [WDActionTool demageAnimation:self point:CGPointMake(0, 10) scale:0.5 demagePic:@"demage1"];
        [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
        
        self.wdNowBlood -= count;
        if (self.wdNowBlood <= 0) {
            self.isDeadIng = YES;
            [self deadAction:attackerIsLeft];
            return;
        }
        
        self.canMiss = YES;
    }
    
    return;
    
    
}


#pragma mark - 根据位置怪物发动攻击
- (void)monsterAttackAction {
    
    if ([self isCanNotAttack]) {
        return;
    }
    
    if (self.personNode.wdNowBlood <= 0) {
        [self allStatusClear];
        self.isAttackIng = YES;
        [self removeAllActions];
        [self runAction:[SKAction animateWithTextures:_model.winArr timePerFrame:0.15] completion:^{
            
        }];
        return;
    }

    NSInteger index = arc4random() % 9 + 1;
   
    if (index == 9) {
        [self meteoriteAttackAnimation];
    }else if(index == 8){
        [self pullAttackAnimation];
    }else if(index == 5){
        [self flashAttackAnimation];
    }else if(index == 6){
        [self callAttackAnimation];
    }else if(index == 2){
        [self bookAttackBigAnimation];
    }else{
        [self meteoriteAttackAnimation];
    }
    
}

- (void)windPhy:(BaseNode *)windNode{
    [windNode setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, 100, 100)];
    [windNode setPhy];
}

/** 书攻击，大幅度 2 = = */
- (void)bookAttackBigAnimation{
    SKAction *attackAction = [SKAction animateWithTextures:_model.attackArr2 timePerFrame:0.1];
    
    BaseNode *windNode = [BaseNode spriteNodeWithTexture:_model.windArr[0]];
    windNode.alpha = 0;
    windNode.zPosition = 10000;
    windNode.position = CGPointMake(self.position.x, self.position.y);
    windNode.name = @"wind";
    [self.parent addChild:windNode];
    
    [self performSelector:@selector(windPhy:) withObject:windNode afterDelay:7 * 0.1];
    
    //0.7秒等待时间
    SKAction *windAction = [SKAction animateWithTextures:_model.windArr timePerFrame:0.1];
    SKAction *waitAction  = [SKAction waitForDuration:7 * 0.1];
    SKAction *alphaAction = [SKAction fadeAlphaTo:0.7 duration:0.1];
    SKAction *moveAction  = [SKAction moveTo:CGPointMake(self.position.x + self.directon * 2000, self.position.y) duration:1.];

    SKAction *gro = [SKAction group:@[windAction,alphaAction,moveAction]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[waitAction,gro,remove]];
    
    [windNode runAction:seq completion:^{
        
    }];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:attackAction completion:^{
        weakSelf.isAttackIng = NO;
    }];
}


/** 召唤小怪 6 */
- (void)callAttackAnimation{
    [[WDNotificationManager shareManager]postNotificationForCallMonster];
    
    SKAction *attackAction = [SKAction animateWithTextures:_model.attackArr6 timePerFrame:0.1];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:attackAction completion:^{
        weakSelf.isAttackIng = NO;
    }];
}


/** 拉拽攻击 8 */
- (void)pullAttackAnimation{
    [self removeAllActions];
    self.isMoveIng = NO;
    
    SKAction *attackAction = [SKAction animateWithTextures:[_model.attackArr8 subarrayWithRange:NSMakeRange(0, 4)] timePerFrame:0.1];
    SKAction *waitAction    = [SKAction waitForDuration:0.4];
    SKAction *attackAction2 = [SKAction animateWithTextures:[_model.attackArr8 subarrayWithRange:NSMakeRange(4, _model.attackArr8.count - 4)] timePerFrame:0.1];
    
    SKAction *seq = [SKAction sequence:@[attackAction,waitAction,attackAction2]];
    [self performSelector:@selector(bePullAction) withObject:nil afterDelay:0.7];
    
    BaseNode *windNode = [BaseNode spriteNodeWithTexture:_model.windArr[0]];
    windNode.alpha = 0;
    [_personNode addChild:windNode];
    
    SKAction *windAction = [SKAction animateWithTextures:_model.windArr timePerFrame:0.1];
    SKAction *alphaAction = [SKAction fadeAlphaTo:0.7 duration:0.5];
    SKAction *waitAlpha0 = [SKAction waitForDuration:0.5];
    SKAction *alpha0Action = [SKAction fadeAlphaTo:0 duration:0.2];
    SKAction *seq2 = [SKAction sequence:@[alphaAction,waitAlpha0,alpha0Action]];
   
    SKAction *gro = [SKAction group:@[seq2,windAction]];
    
    
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seqA = [SKAction sequence:@[gro,remove]];
    
    [windNode runAction:seqA completion:^{
        
    }];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:seq completion:^{
        [weakSelf bookAttack];
    }];
}

- (void)bePullAction{

    if (_personNode.isSkillAttackIng) {
        return;
    }
    SKAction *move = [SKAction moveTo:CGPointMake(self.position.x + self.directon * 80, self.position.y) duration:0.4];
    [_personNode runAction:move completion:^{
    }];
}

- (void)bookAttack{
    
    SKAction *book1 = [SKAction animateWithTextures:_model.attackArr1 timePerFrame:0.1];
    [self performSelector:@selector(attackAction) withObject:nil afterDelay:0.1 * 3];

    __weak typeof(self)weakSelf = self;
    [self runAction:book1 completion:^{
        weakSelf.isAttackIng = NO;
    }];
}

/** 书攻击的最后阶段会摔倒，这个时候可以被攻击 */
- (void)fallAction{
    SKAction *book3 = [SKAction animateWithTextures:_model.attackArr3 timePerFrame:0.15];
    __weak typeof(self)weakSelf = self;
    [self runAction:book3 completion:^{
        weakSelf.isAttackIng = NO;
    }];
}

/** 陨石攻击动画 9 */
- (void)meteoriteAttackAnimation{
    
    SKAction *attackAction = [SKAction animateWithTextures:_model.attackArr9 timePerFrame:0.1];
    
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:0.7];
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:0.9];
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:1.1];
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:1.3];
    [self performSelector:@selector(meteoriteAttackWithCount:) withObject:nil afterDelay:1.5];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:attackAction completion:^{
        weakSelf.isAttackIng = NO;
    }];
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
    
    __block Boss3Model *model = _model;
    __block BaseNode *parentNode = (BaseNode *)self.parent;
    [fireNode runAction:seq2 completion:^{
        [targetNode removeFromParent];
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
        [boomNode runAction:[SKAction sequence:@[fireAction2,removeAction]]];
    }];
}


/** 闪电攻击 5 */
- (void)flashAttackAnimation{

    SKAction *attackAction = [SKAction animateWithTextures:_model.attackArr5 timePerFrame:0.1];
    
    [self performSelector:@selector(createCloudNode) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(createCloudNode) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(createCloudNode) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(createCloudNode) withObject:nil afterDelay:0.7];
    [self performSelector:@selector(createCloudNode) withObject:nil afterDelay:0.9];
    [self performSelector:@selector(createCloudNode) withObject:nil afterDelay:1.1];

    __weak typeof(self)weakSelf = self;
    [self runAction:attackAction completion:^{
        weakSelf.isAttackIng = NO;
    }];
}


/** 创建云 */
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


/** 创建闪电攻击 */
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

/** miss攻击，转圈 */
- (void)circleAttackAction{
    
    if ([self isCanNotAttack]) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    SKAction *attackAction = [SKAction animateWithTextures:_model.missArr timePerFrame:0.1];

    SKAction *move = [SKAction moveTo:CGPointMake(self.position.x + self.directon * 500, self.position.y) duration:_model.missArr.count * 0.1];
    
    SKAction *gro = [SKAction group:@[move,attackAction]];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isAttackIng = NO;
    }];
}



- (void)deadAction:(BOOL)attackerIsLeft {
   
    [self clearAction];
    [self removeAllActions];

    NSInteger index = 1;
    if (!attackerIsLeft) {
        index = -1;
    }
    
    //方向正好相反
    self.xScale = (index * -1) * fabs(self.xScale);
    
    SKAction *diedAction = [SKAction animateWithTextures:_model.diedArr timePerFrame:0.1];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(self.position.x + index * 300, self.position.y + 100) duration:0.3];
    SKAction *moveAction2 = [SKAction moveTo:CGPointMake(self.position.x + index * 300, self.position.y) duration:0.3];
    SKAction *seq = [SKAction sequence:@[moveAction,moveAction2]];
    SKAction *gro = [SKAction group:@[diedAction,seq]];

    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        if (weakSelf.deadBlock) {
            weakSelf.deadBlock(weakSelf.name);
        }
    }];
    
    return;
}

#pragma mark - 真实的被击中
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

#pragma mark - 移动规则
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

        
    }else if(distanceX < 0){
        
        self.xScale = -1 * fabs(self.xScale);
        if (fabs(distanceX) <= 400 && fabs(distanceX) >= 380) {
            moveX = monsterX;
            
            
        }else if (fabs(distanceX) >= 400) {
            moveX = monsterX - self.wdSpeed;
        }else{
            moveX = monsterX + self.wdSpeed;
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(attackAction) object:nil];    
}

@end
