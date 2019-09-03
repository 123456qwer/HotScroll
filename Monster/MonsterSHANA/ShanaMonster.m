//
//  ShanaMonster.m
//  HotSchool
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "ShanaMonster.h"
#import "ShanaModel.h"
#import "Person1Node.h"

@implementation ShanaMonster
{
    ShanaModel *_model;
    SKSpriteNode *_blackCircleNode;
    
    CADisplayLink *_moveLink;
    __weak BaseNode *_personNode;
    
    NSTimer      *_skillTimer;
    NSInteger     _skillTimes;

}

- (void)beginMove
{
    _moveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveAction)];
    [_moveLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    _skillTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(skillTimer:) userInfo:nil repeats:YES];
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    self.delegate = self;
    
    _model = (ShanaModel *)model;
    self.model = model;
    
    [self stayAction];
    [self createBlackCircle];
    
    _blackCircleNode = self.blackCircleNode;
    _blackCircleNode.position = CGPointMake(3, - 30);
    self.name = @"shanaMonster";
    
    self.wdSpeed = 3;
    self.wdBlood = 1500;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 5;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSetBossBloodAction object:@{@"blood":@(1500)}];
 
    
    
    //注意，物理碰撞体积不随物体的方法而放大，手动增大
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60, 100) center:CGPointMake(0, 0)];
    
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = SHANA_CATEGORY;
    body.collisionBitMask = SHANA_COLLISION;
    body.contactTestBitMask = SHANA_CONTACT;
    
    self.physicsBody = body;
}

- (void)setPersonNode:(BaseNode *)personNode;
{
    _personNode = (Person1Node *)personNode;
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

- (void)moveAction{
    
    [self moveActionWithPersonNodePosition:_personNode.position];
    
}

#pragma mark 手动移动<只在第一个界面使用>
- (BOOL)moveAction:(NSString *)direction
             point:(CGPoint)point
{
    if ([self isCanNotMove]) {
        return YES;
    }
    
    CGPoint personPoint = self.position;
    CGPoint movePoint = CGPointMake(personPoint.x + point.x, personPoint.y + point.y);
    
    CGPoint calculatePoint = [WDCalculateTool calculateMaxMoveXAndY:movePoint maxX:2500 maxY:650 personSize:self.size];
    
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

#pragma mark 怪物移动方法<自动>
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
    
    if (_personNode.isDeadIng) {
        [self clearAction];
        [self runAction:[SKAction animateWithTextures:self.model.winArr timePerFrame:0.3]  completion:^{
            
        }];
        return;
    }

    //距离太紧，直接攻击
    if (fabs(distanceX) < 20) {
        [self attackActionWithType:arc4random()%4];
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
    self.zPosition = self.zPosition = 650 - self.position.y;
    
    if (!self.isMoveIng) {
        
        [self runAction:[WDActionTool moveActionWithMoveArr:_model.moveArr time:0.1]];
        self.isMoveIng = YES;
    }
}

- (void)attackSkillAction
{
    CGFloat distanceX = self.position.x - _personNode.position.x;
    
    BOOL isLeft = NO;
    if (distanceX < 0) {
        isLeft = YES;
    }
    
    CGFloat attackNumber = self.wdAttack;
    
    
    NSArray *arr = @[@(arc4random() % 10 + attackNumber),@(arc4random() % 10 + attackNumber),@(arc4random() % 15 + attackNumber)];
    CGFloat fudongNumber = [arr[self.skillType]integerValue];
    
    [_personNode.delegate beAttackAction:isLeft attackCount:fudongNumber];
}

- (void)attackActionWithType:(NSInteger)type
{
    if ([self isCanNotAttack]) {
        return;
    }
    
    [self setPhySicsBodyNone];
    NSArray *arr;
    NSTimeInterval times = 0.0;
    if (type == 0) {
        arr = _model.attack1Arr;
        times = 0.2;
        self.attackType = 0;
    }else if(type == 1){
        arr = _model.attack2Arr;
        times = 0.4;
        self.attackType = 1;
    }else if(type == 2){
        arr = _model.attack3Arr;
        times = 0.2;
        self.attackType = 2;
    }else {
        arr = _model.attack4Arr;
        times = 0.4;
        self.attackType = 3;
    }
    
    [self performSelector:@selector(attackPersonNode) withObject:nil afterDelay:times];
    [self removeAllActions];
    __weak typeof(self)weakSelf = self;
    SKAction *attackAction = [SKAction animateWithTextures:arr timePerFrame:0.1];
    [self runAction:attackAction completion:^{
        weakSelf.isAttackIng = NO;
        [weakSelf setPhy];
    }];
}

- (void)attackPersonNode
{
    CGFloat distanceX = self.position.x - _personNode.position.x;
    CGFloat distanceY = self.position.y - _personNode.position.y;
    
    BOOL isLeft = NO;
    if (distanceX < 0) {
        isLeft = YES;
    }
    
    CGFloat attackNumber = self.wdAttack;
    
    
    NSArray *arr = @[@(arc4random() % 5 + attackNumber),@(arc4random() % 5 + attackNumber),@(arc4random() % 5 + 10 + attackNumber),@(arc4random() % 5 + 15 + attackNumber)];
    CGFloat fudongNumber = [arr[self.attackType]integerValue];
    
    
    CGFloat bigDistance = 150;

    
    if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
        [_personNode.delegate beAttackAction:isLeft attackCount:fudongNumber];
    }
    
}

/** 翻滚跳跃攻击 */
- (void)skill1Action
{
    
    if ([self isCanNotSkillAttack]) {
        return;
    }
    
    [self removeAllActions];

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
    [self performSelector:@selector(shanaSetCanTestContact) withObject:nil afterDelay:0.1];

    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf setPhy];
    }];
}


/** 切入技能 */
- (void)skill2Action
{
    if ([self isCanNotSkillAttack]) {
        return;
    }
    
    NSInteger direction = [self leftOrRight];
    CGFloat moveX = self.position.x + direction * 500;

    SKAction *move1 = [SKAction moveTo:CGPointMake(moveX, self.position.y) duration:0.3];
    SKAction *a = [SKAction animateWithTextures:_model.skill2Arr timePerFrame:0.1];
    
    
    SKAction *gro = [SKAction group:@[move1,a]];
    
    [self setPhySicsBodyNone];
    [self performSelector:@selector(shanaSetCanTestContact) withObject:nil afterDelay:0.1];
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf setPhy];
    }];
}


/** 火刀跳跃技能攻击 */
- (void)skill3Action
{
    if ([self isCanNotSkillAttack]) {
        return;
    }
    
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
    [self performSelector:@selector(shanaSetCanTestContact) withObject:nil afterDelay:0.8];

    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf setPhy];
    }];
    
}

#pragma mark 只能检测到碰撞
- (void)shanaSetCanTestContact
{
    self.physicsBody.contactTestBitMask = SHANA_CONTACT;
}

/**
 技能释放timer
 */
- (void)skillTimer:(NSTimer *)timer
{
   
    _skillTimes ++;
    
    if (_skillTimes >= 3) {
        _skillTimes = 0;
        self.skillType = arc4random() % 3;
        if (self.skillType == 0) {
            [self skill1Action];
        }else if(self.skillType == 1){
            [self skill2Action];
        }else{
            [self skill3Action];
        }
    }
}

//被技能攻击
- (void)beSkillAttackAction:(BOOL)attackerIsLeft
                attackCount:(CGFloat)count
{
    //已经被攻击的状态，不能连续被搞
    if (self.isBeAttackIng || self.isDeadIng) {
        return;
    }
    
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    
    self.wdNowBlood -= count;
    if (self.wdNowBlood <= 0) {
        [self clearAction];
        self.isDeadIng = YES;
        [self removeAllActions];
        [self deadAction:attackerIsLeft];
        return;
    }
    
    
    
    self.texture = _model.beAttackTexture;
    [self removeAllActions];
    
    [self setPhySicsBodyNone];
    [self allStatusClear];
    
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
        [weakSelf setPhy];
    }];
    
}

//受到攻击但是不打断其他动作
- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count
{
    //已经被攻击的状态，不能连续被搞
    if (self.isBeAttackIng || self.isDeadIng) {
        return;
    }
    
    if (self.isSkillAttackIng) {
        count = count + 50;
    }
    
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    
    self.wdNowBlood -= count;
    if (self.wdNowBlood <= 0) {
        [self clearAction];
        self.isDeadIng = YES;
        [self removeAllActions];
        [self deadAction:attackerIsLeft];
        return;
    }
    
    
    if (self.isSkillAttackIng) {
        NSLog(@"夏娜在释放技能的时候被屌丝攻击到了！！！！");
        [self downAction:attackerIsLeft];
        
    }else{
        if (attackerIsLeft) {
            SKAction *moveTo = [SKAction moveToX:self.position.x + 40 duration:0.3];
            [self runAction:moveTo];
        }else{
            SKAction *moveTo = [SKAction moveToX:self.position.x - 40 duration:0.3];
            [self runAction:moveTo];
        }
    }
    
}

- (void)setPhy
{
    self.physicsBody.categoryBitMask = SHANA_CATEGORY;
    self.physicsBody.collisionBitMask = SHANA_COLLISION;
    self.physicsBody.contactTestBitMask = SHANA_CONTACT;
   
}

- (void)deadAction:(BOOL)attackerIsLeft
{
    [self removeAllActions];
    SKAction *deadAction = [WDActionTool deadAnimationWithAttackDirection:attackerIsLeft deadArr:[_model.beAttackArr subarrayWithRange:NSMakeRange(0, 3)] node:self];
    [self setPhySicsBodyNone];
   
    __weak typeof(self)weakSelf = self;
    [self runAction:deadAction completion:^{
        SKAction *hiddenAction = [SKAction fadeAlphaTo:0 duration:0.5];
        SKAction *remoAction = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[hiddenAction,remoAction]];
        [weakSelf runAction:seq completion:^{
            if (weakSelf.deadBlock) {
                weakSelf.deadBlock(weakSelf.name);
            }
        }];
        
       
    }];
}

- (void)downAction:(BOOL)attackerIsLeft
{
    [self removeAllActions];
    SKAction *downAction = [WDActionTool downAnimation:attackerIsLeft downArr:_model.beAttackArr node:self circlePosition:CGPointMake(3, - 30)];

    //[self setPhySicsBodyNone];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:downAction completion:^{
        [weakSelf allStatusClear];
        weakSelf.isAttackIng = NO;
    }];
}

- (void)clearAction
{
    [super clearAction];
    if (_moveLink) {
        [_moveLink invalidate];
        _moveLink = nil;
    }
    
    if (_skillTimer) {
        [_skillTimer invalidate];
        _skillTimer = nil;
    }
}

@end
