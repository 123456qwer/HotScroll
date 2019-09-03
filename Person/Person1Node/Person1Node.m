//
//  Person1Node.m
//  HotSchool
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "Person1Node.h"

#import "ShanaMonster.h"
#import "AngelMonster.h"

@implementation Person1Node
{
    SKSpriteNode *_blackCircleNode;
    Person1Model *_model;
   
    NSInteger _continuityAttackCount; //连续攻击次数
    NSTimer   *_contTimer;
    CGFloat   _contCount;
    CGFloat   _nowAttackTime;   //当前攻击完成需要的时间
    
    __weak ShanaMonster *_shanaMonster;
    __weak AngelMonster *_angelMonster;
    
    __weak BaseNode *_boss;
}


#pragma mark 初始化
- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    self.delegate = self;
    
    _model = (Person1Model *)model;
    
    [self createBlackCircle];
    _blackCircleNode = self.blackCircleNode;
    _blackCircleNode.position = CGPointMake(3, -35);
    self.model = _model;
    self.name  = @"person";
    
    //[self realBackGroundWithColor:[UIColor whiteColor]];
    //[self physicalBackGroundNodeWithColor:[UIColor cyanColor] size:CGSizeMake(60, 70) position:CGPointMake(0, 0)];
    //[self centerSprite:[UIColor orangeColor]];
   
    self.imageWidth = 120.f;
    self.imageHeight = 100.f;
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120, 140) center:CGPointMake(0, 0)];
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

#pragma mark 技能释放
- (void)skillAction:(NSInteger)type
{
    if ([self isCanNotSkillAttack]) {
        return;
    }
    
    //self.color = [UIColor whiteColor];
    //[self removeAllActions];
    self.skillType = type;
    
    if (type == topSkillBtn) {
        [self rushSkill];
    }else if(type == middleSkillBtn){
        [self jumpSkill];
    }else if(type == bottomSkillBtn){
        [self defenseAction];
    }else if(type == bottom2SkillBtn){
        [self rush2Action];
    }
}

#pragma mark 切入攻击
- (void)rush2Action
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        [arr addObject:_model.skill1Arr[0]];
    }
    
    SKAction *ani = [SKAction animateWithTextures:arr timePerFrame:0.1];
    SKAction *ani2 = [SKAction animateWithTextures:[_model.attack2Arr subarrayWithRange:NSMakeRange(3, _model.attack2Arr.count - 3)] timePerFrame:0.1];
    SKAction *music = _model.skill4MusicAction;
    SKAction *seq = [SKAction sequence:@[ani,music,ani2]];
   
    CGFloat direction = [self leftOrRight];
    CGPoint movePoint2 = CGPointMake(self.position.x + 700 * direction, self.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
   
    SKAction *moveAction = [SKAction moveTo:calculatePoint2 duration:0.3];
  
    SKAction *alpha1     = [SKAction fadeAlphaTo:0.5 duration:0.3];
    SKAction *alpha2     = [SKAction fadeAlphaTo:1 duration:0.2];
    SKAction *seq2       = [SKAction sequence:@[alpha1,alpha2]];
    SKAction *groupAction = [SKAction group:@[seq,moveAction,seq2]];
    [self setPhySicsBodyNone];
    
    BaseNode *lightNode = [BaseNode spriteNodeWithTexture:_model.skill4LightArr[0]];
    lightNode.alpha = 0.3;
    lightNode.position = CGPointMake(0, 5);
    lightNode.xScale = -1 * 0.5;
    lightNode.yScale = 0.5;
    [self addChild:lightNode];
    
    SKAction *lightAlphaAction = [SKAction fadeAlphaTo:1 duration:0.1];
    SKAction *lightTextureAction = [SKAction animateWithTextures:_model.skill4LightArr timePerFrame:0.1];
    SKAction *removeLightAction = [SKAction removeFromParent];
    SKAction *lightSeq = [SKAction sequence:@[lightAlphaAction,lightTextureAction,removeLightAction]];
    [lightNode runAction:lightSeq];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:groupAction completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
    
    [self postSkillNotificationWithType:3];
    if (self.skillBlockWithTime) {
        self.skillType = 3;
        self.skillBlockWithTime(0.2, 0);
    }
}

#pragma mark 防御方法
- (void)defenseAction{
        
    self.isDefense = YES;
    SKAction *skill = [SKAction animateWithTextures:_model.defenseArr timePerFrame:0.1];
    
    BaseNode *lightNode = [BaseNode spriteNodeWithTexture:_model.skill3LightArr[0]];
    lightNode.alpha = 0.3;
    lightNode.position = CGPointMake(0, 7);
//    lightNode.xScale = -1 * 1;
//    lightNode.yScale = 1;
    [self addChild:lightNode];
    
    SKAction *lightAlphaAction = [SKAction fadeAlphaTo:1 duration:0.1];
    SKAction *lightTextureAction = [SKAction animateWithTextures:_model.skill3LightArr timePerFrame:0.1];
    SKAction *removeLightAction = [SKAction removeFromParent];
    SKAction *lightSeq = [SKAction sequence:@[lightAlphaAction,lightTextureAction,removeLightAction]];
    [lightNode runAction:lightSeq];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:skill completion:^{
        weakSelf.isSkillAttackIng = NO;
        weakSelf.isDefense = NO;
        [weakSelf defenseEndAndAttack];
        [weakSelf attackAction];
    }];
    
    [self postSkillNotificationWithType:2];

}

#pragma mark 跳跃攻击
- (void)jumpSkill{
    
    
    SKAction *skill = [SKAction animateWithTextures:_model.skill2Arr timePerFrame:0.1];
    CGFloat direction = [self leftOrRight];
    CGPoint movePoint2 = CGPointMake(self.position.x + 400 * direction, self.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    
    CGFloat y1 = self.position.y + 150;
    CGFloat y2 = self.position.y;
    
    SKAction *wait  = [SKAction waitForDuration:0.2];
    SKAction *move2 = [SKAction moveToX:calculatePoint2.x duration:0.4];
    SKAction *move3 = [SKAction moveToY:y1 duration:0.2];
    SKAction *move4 = [SKAction moveToY:y2 duration:0.2];
    
    SKAction *seq2 = [SKAction sequence:@[move3,move4]];
    SKAction *gg = [SKAction group:@[seq2,move2]];
    SKAction *music = _model.skill2MusicAction;
    SKAction *seq = [SKAction sequence:@[wait,gg,music]];
    SKAction *group = [SKAction group:@[skill,seq]];
    
    //跳跃的时候，黑圈不跟着移动
    SKAction *blackMo = [SKAction moveToY:_blackCircleNode.position.y - 75 duration:0.2];
    SKAction *blackMo2 = [SKAction moveToY:_blackCircleNode.position.y duration:0.2];
    SKAction *seqB = [SKAction sequence:@[wait,blackMo,blackMo2]];
    [_blackCircleNode runAction:seqB];
    
    [self setPhySicsBodyNone];
    
    
    CGFloat add = 0;
    if (self.directon < 0) {
        add = 20;
    }
    
    BaseNode *jumpEndSmokeNode = [BaseNode spriteNodeWithTexture:self->_model.skill2LightArr[0]];
    jumpEndSmokeNode.position = CGPointMake(calculatePoint2.x + 80 * self.directon + add,self.position.y + 60);
    jumpEndSmokeNode.zPosition = 650 - self.position.y + 80;
    jumpEndSmokeNode.xScale = 2.0;
    jumpEndSmokeNode.yScale = 2.0;
    [self.parent addChild:jumpEndSmokeNode];
    
    SKAction *a = [SKAction animateWithTextures:self->_model.skill2LightArr timePerFrame:0.1];
    SKAction *r = [SKAction removeFromParent];
    SKAction *w = [SKAction waitForDuration:0.45];
    [jumpEndSmokeNode runAction:[SKAction sequence:@[w,a,r]]];
    
    
    BaseNode *jumpStartNode = [BaseNode spriteNodeWithTexture:_model.jumpArr[0]];
    jumpStartNode.alpha = 1;

    [self.parent addChild:jumpStartNode];
    
    
    if (self.xScale > 0) {
        jumpStartNode.xScale = -1;
    }else{
        jumpStartNode.xScale = 1;
    }
    
    jumpStartNode.position = CGPointMake(self.position.x + jumpStartNode.xScale * -10, self.position.y + 20);
    
    SKAction *startAction = [SKAction animateWithTextures:_model.jumpArr timePerFrame:0.1];
    SKAction *wa = [SKAction fadeAlphaTo:0 duration:0.3];
    [jumpStartNode runAction:[SKAction sequence:@[startAction,wa,r]]];
    
    
    __weak typeof(self)weakSelf = self;
    [self runAction:group completion:^{

        weakSelf.isSkillAttackIng = NO;
        [weakSelf setPhy];
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
    
    if (self.skillBlockWithTime) {
        self.skillType = 1;
        self.skillBlockWithTime(0.4, 0);
    }
    
    [self postSkillNotificationWithType:1];
    
}

#pragma mark 冲刺攻击
- (void)rushSkill{
    
    [self setPhySicsBodyNone];
    SKAction *skill = [SKAction animateWithTextures:_model.skill1Arr timePerFrame:0.1];
    CGFloat direction = [self leftOrRight];
    CGPoint movePoint2 = CGPointMake(self.position.x + 700 * direction, self.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    
    SKAction *wait  = [SKAction waitForDuration:0.2];
    SKAction *move2 = [SKAction moveToX:calculatePoint2.x duration:0.4];
    SKAction *music = _model.skill1MusicAction;
    SKAction *seq = [SKAction sequence:@[wait,music,move2]];
    SKAction *group = [SKAction group:@[skill,seq]];
    
//    int xScale = self.xScale > 0 ? -1 : 1;
   
    
    BaseNode *lightNode = [BaseNode spriteNodeWithTexture:_model.skill1LightArr[0]];
    lightNode.alpha = 0.3;
    lightNode.position = CGPointMake(0, 5);
    lightNode.xScale = -1 * 0.9;
    lightNode.yScale = 0.9;
    [self addChild:lightNode];
    
    SKAction *lightAlphaAction = [SKAction fadeAlphaTo:1 duration:0.2];
    SKAction *lightTextureAction = [SKAction animateWithTextures:_model.skill1LightArr timePerFrame:0.1];
    SKAction *removeLightAction = [SKAction removeFromParent];
    SKAction *lightSeq = [SKAction sequence:@[lightAlphaAction,lightTextureAction,removeLightAction]];
    [lightNode runAction:lightSeq];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:group completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
    
    if (self.skillBlockWithTime) {
        self.skillType = 0;
        self.skillBlockWithTime(0.2, 0);
        
    }
    
    [self postSkillNotificationWithType:0];
}

- (void)defenseEndAndAttack{
    _continuityAttackCount = 3;

}

- (void)longAttackBegin
{
    if ([self isCanNotPressAttack]) {
        return;
    }
    //[self removeAllActions];
    NSArray *arr = [_model.attack1Arr subarrayWithRange:NSMakeRange(0, 2)];
    SKAction *action = [SKAction animateWithTextures:arr timePerFrame:0.1];
    __weak typeof(self)weakSelf = self;
    [self runAction:action completion:^{
        [weakSelf setPressTexture];
    }];
}

- (void)setPressTexture
{
    self.texture = _model.attack1Arr[1];
}

- (void)longAttackEnd
{
    if ([self isCanNotPressAttack]) {
        return;
    }
    
    if (self.isPressIng == NO) {
        return;
    }
    
    [self allStatusClear];
    _continuityAttackCount = 3;
    [self attackAction];
    self.isPressIng = NO;
}

#pragma mark 待定的大招
- (void)attack5Skill
{
    if ([self isCanNotSkillAttack]) {
        return;
    }
    
    SKAction *skill = [SKAction animateWithTextures:_model.attack5Arr timePerFrame:0.1];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:skill completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
    }];
}





- (void)postSkillNotificationWithType:(NSInteger)type
{
    //告诉操作类技能已经释放
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSkillAction object:@{@"skillType":@(type)}];
}

#pragma mark 攻击方法
- (void)attackAction
{
    if ([self isCanNotAttack]) {
        return;
    }
    
    //火焰剑攻击
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
    
    
    SKAction *attackAction;
    CGFloat afterTimes = 0.0;
    if (_continuityAttackCount == 0) {
       
        SKAction *textureA = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.1];
        SKAction *music = _model.attack1MusicAction;
        attackAction = [SKAction group:@[textureA,music]];
        _nowAttackTime = _model.attack1Arr.count * 0.1;
        afterTimes = 0.1 * 2;
        
    }else if(_continuityAttackCount == 1){
        SKAction *textureA = [SKAction animateWithTextures:_model.attack2Arr timePerFrame:0.1];
        SKAction *music = _model.attack2MusicAction;
        attackAction = [SKAction group:@[textureA,music]];
        _nowAttackTime = _model.attack2Arr.count * 0.1;
        afterTimes = 0.1 * 2;
    }else if(_continuityAttackCount == 2){
        SKAction *textureA = [SKAction animateWithTextures:_model.attack3Arr timePerFrame:0.1];
        SKAction *music = _model.attack3MusicAction;
        attackAction = [SKAction group:@[textureA,music]];
        _nowAttackTime = _model.attack3Arr.count * 0.1;
        afterTimes = 0.1 * 2;
    }else if(_continuityAttackCount == 3){
       
        self.isSkillAttackIng = YES;
        afterTimes = 0.1 * 3;
        NSInteger direction = [self leftOrRight];
        
        _nowAttackTime = _model.attack4Arr.count * 0.1;
        SKAction *a = [SKAction animateWithTextures:_model.attack4Arr timePerFrame:0.1];
        SKAction *waitAction = [SKAction waitForDuration:0.3];
        SKAction *moveA = [SKAction moveTo:CGPointMake(self.position.x + 250 * direction, self.position.y) duration:0.2];
        SKAction *music = _model.attack4MusicAction;
        SKAction *seq = [SKAction sequence:@[music,waitAction,moveA]];
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
        self.attackBlockWithTime(afterTimes, self.attackType);
    }
    
    _continuityAttackCount ++;
    
    NSTimeInterval times = afterTimes;
    [self performSelector:@selector(attackWithSHANA) withObject:nil afterDelay:times];
    
    [self runAction:attackAction completion:^{
        weakSelf.isSkillAttackIng = NO;//最后一击为技能释放，需要重置释放技能状态
        [weakSelf endAttack];
        [weakSelf stayAction];
    }];
    

}

#pragma mark 攻击夏娜的方法
- (void)attackWithSHANA
{
    if (self.isBeAttackIng) {
        return;
    }

    if (_boss) {
        
        CGFloat distanceX = self.position.x - _boss.position.x;
        CGFloat distanceY = self.position.y - _boss.position.y;
        
        BOOL isLeft = NO;
        if (distanceX < 0) {
            isLeft = YES;
        }
        
        CGFloat attackNumber = self.wdAttack;
        NSArray *arr = @[@(arc4random() % 5),@(arc4random() % 5 + 5),@(arc4random() % 5 + 10),@(arc4random() % 5 + 15)];
        CGFloat fudongNumber = [arr[self.attackType]integerValue];
        
        //根据BOSS大小判断有效伤害距离
        CGFloat bigDistance = 150;
        if (self.attackType == FOURAttack) {
            bigDistance = 250;
        }
        
        if (_shanaMonster) {
            
        }else if(_angelMonster){
            
        }
        
        if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
            [_boss.delegate beAttackAction:isLeft attackCount:fudongNumber + attackNumber];
        }
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
    
    [self removeAllActions];
    
    SKAction *downAction = [WDActionTool downAnimation:attakcerIsLeft downArr:_model.beAttackArr node:self circlePosition:self.blackCircleNode.position];
    __weak typeof(self)weakSelf = self;
    [self runAction:downAction completion:^{
        weakSelf.isBeAttackIng = NO;
        weakSelf.isAttackIng = NO;
        [weakSelf stayAction];
    }];
}


#pragma mark 被攻击方法
- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count
{
    if ([self actionForKey:@"color"]) {
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
    
   // __weak typeof(self)weakSelf = self;
    self.isBeAttackIng = NO;
    SKAction *colorA = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.05];
    SKAction *colorB = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1 duration:0.05];
    SKAction *seq = [SKAction sequence:@[colorA,colorB]];
    SKAction *rep = [SKAction repeatAction:seq count:5];
    [self runAction:rep withKey:@"color"];
    
    return;
    
    /*
    _continuityAttackCount = 0;
    _contCount = 0;
    [self removeAllActions];
    self.texture = _model.beAttack;
    SKAction *moveTo;
    if (attackerIsLeft) {
        moveTo = [SKAction moveToX:self.position.x + 40 duration:0.3];
    }else{
        moveTo = [SKAction moveToX:self.position.x - 40 duration:0.3];
    }
    [weakSelf runAction:moveTo completion:^{
        weakSelf.isBeAttackIng = NO;
        weakSelf.isAttackIng = NO;
        [weakSelf stayAction];
    }];
*/
}

- (void)deadAction:(BOOL)attackerIsLeft {
    
}



- (void)setPhy
{
    self.physicsBody.categoryBitMask = PLAYER_CATEGORY;
    self.physicsBody.collisionBitMask = PLAYER_COLLISION;
    self.physicsBody.contactTestBitMask = PLAYER_CONTACT;
}

- (void)endAttack
{
    self.isAttackIng = NO;
    
}

#pragma mark 原地呆着方法
- (void)stayAction
{
    if (self.isAttackIng || self.isBeAttackIng || self.isSkillAttackIng || self.isDefense || self.isDeadIng) {
        return;
    }
    
    self.isMoveIng = NO;
    [self runAction:[WDActionTool moveActionWithMoveArr:_model.stayArr time:0.5]];
}

#pragma mark 移动方法
- (BOOL)moveAction:(NSString *)direction
             point:(CGPoint)point
{
    if ([self isCanNotMove]) {
        return YES;
    }
    
    //中了相反操作
    BaseNode *questionNode = (BaseNode *)[self childNodeWithName:@"question"];
    if (self.oppositeDebuff) {
        point = CGPointMake(-point.x, -point.y);
        direction = [direction isEqualToString:@"left"] ? @"right" : @"left";
        
    }
    
    CGPoint personPoint = self.position;
    CGPoint movePoint = CGPointMake(personPoint.x + point.x, personPoint.y + point.y);
    
    CGPoint calculatePoint = [WDCalculateTool calculateMaxMoveXAndY:movePoint maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    
    self.position = calculatePoint;
    self.zPosition = 650 - self.position.y + 20;
    
    
    if ([direction isEqualToString:@"left"]) {
        questionNode.xScale = -1 * fabs(questionNode.xScale);
        self.xScale = -1 * fabs(self.xScale);
        self.directon = -1;
    }else if ([direction isEqualToString:@"right"]){
        questionNode.xScale = 1 * fabs(questionNode.xScale);
        self.xScale = 1 * fabs(self.xScale);
        self.directon = 1;
    }
    
    if (!self.isMoveIng) {
        
        [self runAction:[WDActionTool moveActionWithMoveArr:_model.moveArr time:0.1]];
        self.isMoveIng = YES;
    }
    
    return NO;
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



#pragma mark 释放资源
- (void)clearAction
{
    [super clearAction];
    if (_contTimer) {
        [_contTimer invalidate];
        _contTimer = nil;
    }
}


- (void)dealloc
{
    NSLog(@"1");
}

@end
