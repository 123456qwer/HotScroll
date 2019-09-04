//
//  ShanaNode.m
//  HotSchool
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "ShanaNode.h"
#import "ShanaModel.h"
#import "ShanaMonster.h"
#import "AngelMonster.h"
@implementation ShanaNode
{
    ShanaModel *_model;
    SKSpriteNode *_blackCircleNode;
    NSInteger _continuityAttackCount; //连续攻击次数
    CGFloat   _contCount;
    CGFloat   _nowAttackTime;   //当前攻击完成需要的时间
    NSTimer   *_contTimer;
    __weak ShanaMonster *_shanaMonster;
    __weak AngelMonster *_angelMonster;
    __weak BaseNode *_boss;
    
    NSInteger _addMissCount; //达到一定数，miss几率增加
}


/**
 攻击连贯性更改
 */
- (void)setModelArr
{
    
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    self.delegate = self;
    
    _model = (ShanaModel *)model;
    self.model = _model;
    
    [self setModelArr];
    
    [self createBlackCircle];
    
   
    
    
    _blackCircleNode = self.blackCircleNode;
    _blackCircleNode.position = CGPointMake(3, - 30);
    self.name = @"person";
    
    //[self physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(60, 50) position:CGPointMake(0, 0)];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120, 100) center:CGPointMake(0, 0)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = PLAYER_CATEGORY;
    body.collisionBitMask = PLAYER_COLLISION;
    body.contactTestBitMask = PLAYER_CONTACT;
    
    self.physicsBody = body;
    PersonManager *manager = [PersonManager sharePersonManager];
    self.wdAttack   = manager.wdAttack;
    self.wdBlood    = manager.wdBlood;
    self.wdMiss     = manager.wdMiss;
    self.wdNowBlood = self.wdBlood;
    
    self.imageWidth = 120.f;
    self.imageHeight = 100.f;
    
}




- (BOOL)moveAction:(NSString *)direction
             point:(CGPoint)point
{
    if ([self isCanNotMove]) {
        return YES;
    }
    
    CGPoint personPoint = self.position;
    CGPoint movePoint = CGPointMake(personPoint.x + point.x, personPoint.y + point.y);
    
    CGPoint calculatePoint = [WDCalculateTool calculateMaxMoveXAndY:movePoint maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    
    self.position = calculatePoint;
    self.zPosition = 650 - self.position.y;
    
    
    if ([direction isEqualToString:@"left"]) {
        self.xScale = -1 * fabs(self.xScale);
    }else if ([direction isEqualToString:@"right"]){
        self.xScale = 1 * fabs(self.xScale);
    }
    
    if (!self.isMoveIng) {
        
        [self runAction:[WDActionTool moveActionWithMoveArr:_model.moveArr time:0.1]];
        self.isMoveIng = YES;
    }
    
    return NO;
}

#pragma mark 原地呆着方法
- (void)stayAction
{
    if (self.isAttackIng || self.isBeAttackIng || self.isSkillAttackIng || self.isDefense) {
        return;
    }
    
    self.isMoveIng = NO;
    [self runAction:[WDActionTool moveActionWithMoveArr:_model.stayArr time:0.5]];
}

#pragma mark 被攻击方法
- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count
{
    
    if ([self actionForKey:@"color"]) {
       // NSLog(@"我还在颜色变化中！");
        return;
    }
    
    if ([self isCanNotBeAttack]) {
        return;
    }
    
    if ([WDCalculateTool missAttack:self.wdMiss]) {
        
        self.isBeAttackIng = NO;
        [WDActionTool missAnimation:self];
        return;
    }
    
    if ([self isDeadAction:count attackerDirection:attackerIsLeft]) {
        return;
    }
    
    self.isBeAttackIng = NO;
    SKAction *colorA = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.05];
    SKAction *colorB = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1 duration:0.05];
    SKAction *seq = [SKAction sequence:@[colorA,colorB]];
    SKAction *rep = [SKAction repeatAction:seq count:5];
    [self runAction:rep withKey:@"color"];
    return;
    
    
    /*
    self.texture = _model.beAttack;
    SKAction *moveTo;
    if (attackerIsLeft) {
        moveTo = [SKAction moveToX:self.position.x + 40 duration:0.3];
    }else{
        moveTo = [SKAction moveToX:self.position.x - 40 duration:0.3];
    }
    __weak typeof(self)weakSelf = self;
    [weakSelf runAction:moveTo completion:^{
        weakSelf.isBeAttackIng = NO;
        weakSelf.isAttackIng = NO;
        [weakSelf stayAction];
    }];
    */
}

#pragma mark 技能释放
- (void)skillAction:(NSInteger)type
{
    if ([self isCanNotSkillAttack]) {
        return;
    }
    
    self.color = [UIColor whiteColor];
   // [self removeAllActions];
    
    if (type == topSkillBtn) {
        [self skill1Action];
    }else if(type == middleSkillBtn){
        [self skill2Action];
    }else if(type == bottomSkillBtn){
        [self postSkillNotificationWithType:2];
        self.isSkillAttackIng = NO;
        _continuityAttackCount = 3;
        [self attackAction];
    }else if(type == bottom2SkillBtn){
        [self skill4Action];
    }
}

- (void)attackAction
{
    if ([self isCanNotAttack]) {
        return;
    }
    [PersonManager fireBladeActionWithPerson:self];
    if (_continuityAttackCount > 3) {
        _continuityAttackCount = 0;
    }
    
    __weak typeof(self)weakSelf = self;
    if (self.isMoveIng) {
        
        //攻击block，遍历存储的怪物,afterTimes攻击动作做出时的延迟时间
        if (self.attackBlockWithTime) {
            self.attackBlockWithTime(0.3, 2);
        }
        
        _nowAttackTime = _model.attack2Arr.count * 0.1;
        _continuityAttackCount = 2;
        SKAction *attackAction = [SKAction animateWithTextures:_model.attack2Arr timePerFrame:0.1];
        [self runAction:attackAction completion:^{
            [weakSelf endAttack];
            [weakSelf stayAction];
        }];
        
        self.attackType = _continuityAttackCount;
        return;
    }
    
    
    CGFloat attackTime = 0.08;

    
   // [self removeAllActions];
    SKAction *attackAction;
    CGFloat afterTimes = 0.0;
    if (_continuityAttackCount == 0) {
        attackAction = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:attackTime];
        _nowAttackTime = _model.attack1Arr.count * 0.1;
        afterTimes = 0.1 * 2;
    }else if(_continuityAttackCount == 1){
        attackAction = [SKAction animateWithTextures:_model.attack2Arr timePerFrame:attackTime];
        _nowAttackTime = _model.attack2Arr.count * 0.1;
        afterTimes = 0.1 * 3;
    }else if(_continuityAttackCount == 2){
        attackAction = [SKAction animateWithTextures:_model.attack3Arr timePerFrame:attackTime];
        _nowAttackTime = _model.attack3Arr.count * 0.1;
        afterTimes = 0.1 * 3;
    }else if(_continuityAttackCount == 3){
        
        self.isSkillAttackIng = YES;
        afterTimes = 0.1 * 3;
        NSInteger direction = [self leftOrRight];
        
        _nowAttackTime = _model.attack4Arr.count * 0.1;
        SKAction *a = [SKAction animateWithTextures:_model.attack4Arr timePerFrame:attackTime];
        SKAction *waitAction = [SKAction waitForDuration:0.3];
        SKAction *moveA = [SKAction moveTo:CGPointMake(self.position.x + 250 * direction, self.position.y) duration:0.2];
        SKAction *seq = [SKAction sequence:@[waitAction,moveA]];
        attackAction = [SKAction group:@[a,seq]];
    }
    
    
    if (_contTimer) {
        [_contTimer invalidate];
    }
    
    _contCount = 0;
    _contTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(continutyAction:) userInfo:nil repeats:YES];
    
    self.attackType = _continuityAttackCount;
    
    //攻击block，遍历存储的怪物,afterTimes攻击动作做出时的延迟时间
    if (self.attackBlockWithTime) {
        //NSLog(@"a: %ld",(long)self.attackType);
        self.attackBlockWithTime(afterTimes, self.attackType);
    }
    
    _continuityAttackCount ++;
    
    NSTimeInterval times = afterTimes;
    [self performSelector:@selector(attackWithSHANA) withObject:nil afterDelay:times];
    
    [self runAction:attackAction completion:^{
        [weakSelf endAttack];
        [weakSelf stayAction];
    }];
}

- (void)deadAction:(BOOL)attackerIsLeft
{
    NSLog(@"玩家不适用");
}

#pragma mark 攻击夏娜的方法
- (void)attackWithSHANA
{
    if (self.isBeAttackIng) {
        return;
    }
    
    if (_boss) {
        
        if (_shanaMonster) {
            
        }else if(_angelMonster){
            
        }
        
        CGFloat distanceX = self.position.x - _boss.position.x;
        CGFloat distanceY = self.position.y - _boss.position.y;
        
        BOOL isLeft = NO;
        if (distanceX < 0) {
            isLeft = YES;
        }
        
        CGFloat attackNumber = self.wdAttack;
        
        
        NSArray *arr = @[@(arc4random() % 5),@(arc4random() % 5 + 5),@(arc4random() % 5 + 10),@(arc4random() % 5 + 15)];
        CGFloat fudongNumber = [arr[self.attackType]integerValue];
        
        
        CGFloat bigDistance = 150;
        if (self.attackType == FOURAttack) {
            bigDistance = 250;
        }
        
        if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
            [_boss.delegate beAttackAction:isLeft attackCount:fudongNumber + attackNumber];
        }
        
    }
}

#pragma mark 连续攻击记录按下攻击键的时间，触发连续攻击
- (void)continutyAction:(NSTimer *)timer
{
    _contCount += 0.1;
    if (_contCount > _nowAttackTime + 0.1) {
        [timer invalidate];
        _continuityAttackCount = 0;
        _contCount = 0;
        self.attackType = _continuityAttackCount;
    }
}

- (void)endAttack
{
    self.isAttackIng = NO;
    self.isSkillAttackIng = NO;
}

/** 翻滚跳跃攻击 */
- (void)skill1Action
{
    //[self removeAllActions];
    
    
    NSInteger direction = [self leftOrRight];
    
    CGFloat moveX = self.position.x + direction * 500;
    CGFloat moveY = self.position.y + 300;
    CGFloat beforeY = self.position.y;
    
    SKAction *move1 = [SKAction moveTo:CGPointMake(moveX, moveY) duration:0.5];
    SKAction *move2 = [SKAction moveTo:CGPointMake(moveX, beforeY) duration:0.3];
    SKAction *attackAction = [SKAction animateWithTextures:_model.skill1Arr timePerFrame:0.1];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    SKAction *gro = [SKAction group:@[seq,attackAction]];
    
    
    //跳跃的时候，黑圈不跟着移动
    SKAction *blackMo = [SKAction moveToY:_blackCircleNode.position.y - 150 duration:0.5];
    SKAction *blackMo2 = [SKAction moveToY:_blackCircleNode.position.y duration:0.3];
    SKAction *seqB = [SKAction sequence:@[blackMo,blackMo2]];
    [_blackCircleNode runAction:seqB];
    
    [self setPhySicsBodyNone];
  
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
    
    [self postSkillNotificationWithType:0];
    if (self.skillBlockWithTime) {
        self.skillType = 0;
        self.skillBlockWithTime(0.1, 0);
    }
}

- (void)postSkillNotificationWithType:(NSInteger)type
{
    //告诉操作类技能已经释放
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSkillAction object:@{@"skillType":@(type)}];
}

- (void)setPhy
{
    self.physicsBody.categoryBitMask = PLAYER_CATEGORY;
    self.physicsBody.collisionBitMask = PLAYER_COLLISION;
    self.physicsBody.contactTestBitMask = PLAYER_CONTACT;
}

- (void)setBossMonster:(BaseNode *)node
{
    //第一关BOSS夏娜
    if ([node.name isEqualToString:@"shanaMonster"]) {
        _shanaMonster = (ShanaMonster *)node;
    }else if([node.name isEqualToString:@"angelMonster"]){
        _angelMonster = (AngelMonster *)node;
    }
    
    _boss = node;
}

/** 火刀跳跃技能攻击 */
- (void)skill2Action
{
    NSInteger direction = [self leftOrRight];
    CGFloat moveX = self.position.x + direction * 400;
    CGFloat moveY = self.position.y + 150;
    CGFloat beforeY = self.position.y;
    
    SKAction *wait = [SKAction waitForDuration:0.3];
    SKAction *moveP = [SKAction moveTo:CGPointMake(moveX, moveY) duration:0.3];
    SKAction *seq1 = [SKAction sequence:@[wait,moveP]];
    
    SKAction *moveYA = [SKAction moveTo:CGPointMake(moveX, beforeY) duration:0.2];
    SKAction *seq = [SKAction sequence:@[seq1,moveYA]];
    SKAction *a = [SKAction animateWithTextures:_model.skill3Arr timePerFrame:0.1];
    SKAction *gro = [SKAction group:@[seq,a]];
    
    
    SKAction *blackMo = [SKAction moveToY:_blackCircleNode.position.y - 75 duration:0.3];
    SKAction *blackMo2 = [SKAction moveToY:_blackCircleNode.position.y duration:0.2];
    SKAction *seqB = [SKAction sequence:@[wait,blackMo,blackMo2]];
    [_blackCircleNode runAction:seqB];
    
    [self setPhySicsBodyNone];
  
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();

    }];
    
    [self postSkillNotificationWithType:1];
    if (self.skillBlockWithTime) {
        self.skillType = 1;
        self.skillBlockWithTime(0.5, 1);
    }
    
}


/** 切入技能 */
- (void)skill4Action
{
    NSInteger direction = [self leftOrRight];
    CGFloat moveX = self.position.x + direction * 500;
    
    SKAction *move1 = [SKAction moveTo:CGPointMake(moveX, self.position.y) duration:0.3];
    SKAction *a = [SKAction animateWithTextures:_model.skill2Arr timePerFrame:0.1];
    
    
    SKAction *gro = [SKAction group:@[move1,a]];
    
    [self setPhySicsBodyNone];
    //[self performSelector:@selector(shanaSetCanTestContact) withObject:nil afterDelay:0.1];
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();

    }];
    
    [self postSkillNotificationWithType:3];
    if (self.skillBlockWithTime) {
        self.skillType = 3;
        self.skillBlockWithTime(0.1, 0);
    }
}

- (void)clearAction
{
    [super clearAction];

    
    if (_contTimer) {
        [_contTimer invalidate];
        _contTimer = nil;
    }
}

#pragma mark 代理基础行为
- (void)downAction:(BOOL)attakcerIsLeft
       attackCount:(CGFloat)count
{
    if ([self isCanNotBeAttack]) {
        return;
    }
    
    if ([self isDeadAction:count attackerDirection:attakcerIsLeft]) {
        return;
    }
    
   // [self removeAllActions];
    
    SKAction *downAction = [WDActionTool downAnimation:attakcerIsLeft downArr:_model.beAttackArr node:self circlePosition:self.blackCircleNode.position];
    __weak typeof(self)weakSelf = self;
    [self runAction:downAction completion:^{
        weakSelf.isBeAttackIng = NO;
        weakSelf.isAttackIng = NO;
        [weakSelf stayAction];
    }];
}

@end
