//
//  KanaNode.m
//  begin
//
//  Created by Mac on 2019/2/12.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "KanaNode.h"
#import "KanaModel.h"
@implementation KanaNode
{
    KanaModel *_model;
    BaseNode  *_personNode;
    NSString  *_kanaFire;
    SKSpriteNode *_blackCircleNode;
    
    NSInteger _continuityAttackCount; //连续攻击次数
    NSTimer   *_contTimer;
    CGFloat   _contCount;
    CGFloat   _nowAttackTime;   //当前攻击完成需要的时间
    CADisplayLink *_moveLink;
    int       _monsterAttackCount; //记录卡娜攻击次数，包括技能和普通攻击

}
- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    _model = (KanaModel *)model;
    self.model = model;
    self.delegate = self;

    [self createBlackCircle];

    _blackCircleNode = self.blackCircleNode;
    _blackCircleNode.position = CGPointMake(0, - 35);
    self.name = @"person";

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
    self.wdSpeed = 2;
    self.personRealName = @"kana";
    self.imageWidth = 120.f;
    self.imageHeight = 100.f;
    _kanaFire = @"kanaFire";
//    self.xScale = 2.1;
//    self.yScale = 2.1;
}



- (void)beAttackAction:(BOOL)attackerIsLeft attackCount:(CGFloat)count {
    
    if ([self.name isEqualToString:@"kanaMonster"]) {
        [self monsterBeAttackAction:attackerIsLeft attackCount:count];
        return;
    }
    
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
    
   //__weak typeof(self)weakSelf = self;
    
    if (1) {
        self.isBeAttackIng = NO;
        SKAction *colorA = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.05];
        SKAction *colorB = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1 duration:0.05];
        SKAction *seq = [SKAction sequence:@[colorA,colorB]];
        SKAction *rep = [SKAction repeatAction:seq count:5];
        [self runAction:rep withKey:@"color"];
        return;
    }
    
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


- (void)attackAction
{
    
    if ([self isCanNotAttack]) {
        return;
    }
    
    
    _monsterAttackCount ++;
    
    if (_continuityAttackCount == 0) {

        [self fireOneAction];
        _nowAttackTime = _model.attack1Arr.count * 0.1;
        SKAction *texA = [SKAction animateWithTextures:[_model.attack1Arr subarrayWithRange:NSMakeRange(3, 4)] timePerFrame:0.1];
        __weak typeof(self)weakSelf = self;
        [self runAction:texA completion:^{
            weakSelf.isAttackIng = NO;
            [weakSelf stayAction];
        }];
    }else if(_continuityAttackCount == 1){
        [self fireOneAction];
        _nowAttackTime = _model.attack1Arr.count * 0.1;
        SKAction *texA = [SKAction animateWithTextures:[_model.attack1Arr subarrayWithRange:NSMakeRange(3, 4)] timePerFrame:0.1];
        __weak typeof(self)weakSelf = self;
        [self runAction:texA completion:^{
            weakSelf.isAttackIng = NO;
            [weakSelf stayAction];
        }];
        
    }else if(_continuityAttackCount == 2){
        [self fireOneAction];
        _nowAttackTime = _model.attack1Arr.count * 0.1;
        SKAction *texA = [SKAction animateWithTextures:[_model.attack1Arr subarrayWithRange:NSMakeRange(3, 4)] timePerFrame:0.1];
        __weak typeof(self)weakSelf = self;
        [self runAction:texA completion:^{
            weakSelf.isAttackIng = NO;
            [weakSelf stayAction];
        }];
        
    }else if(_continuityAttackCount == 3){
//        SKAction *texA = [SKAction animateWithTextures:[_model.attack2Arr subarrayWithRange:NSMakeRange(0, 5)] timePerFrame:0.1];
//        __weak typeof(self)weakSelf = self;
//        [self runAction:texA completion:^{
//            [weakSelf attackBigFireAction];
//        }];
        [self attackBigFireAction];
        _nowAttackTime         = 0;
        _continuityAttackCount = 0;
    }
    
    if (_contTimer) {
        [_contTimer invalidate];
    }
    
    _contCount = 0;
    _contTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(continutyAction:) userInfo:nil repeats:YES];
    
    _continuityAttackCount ++;
    //火焰剑攻击
    [PersonManager fireBladeActionWithPerson:self];
}

- (void)attackBigFireAction
{
    SKAction *texB = [SKAction animateWithTextures:[_model.attack2Arr subarrayWithRange:NSMakeRange(5, _model.attack2Arr.count - 5)] timePerFrame:0.1];
    [self fireTwoAction];
    __weak typeof(self)weakSelf = self;
    [self runAction:texB completion:^{
        weakSelf.isAttackIng = NO;
        [weakSelf stayAction];
    }];
}

//卡娜普通一段攻击
- (void)fireOneAction
{
    CGFloat direction = [self leftOrRight];
   
    SKEmitterNode *eNode = [SKEmitterNode nodeWithFileNamed:@"Fire"];
    eNode.position = CGPointMake(self.position.x + direction * 90, self.position.y + 30);
    eNode.name = _kanaFire;
    eNode.zPosition = 10;
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:5.f];
    body.contactTestBitMask = 0;
    body.categoryBitMask = 1;
    body.collisionBitMask = 0;
    body.affectedByGravity = NO;
    eNode.physicsBody = body;
    
    PersonManager *pManager = [PersonManager sharePersonManager];
    CGFloat attack = pManager.wdAttack;
    eNode.userData = [NSMutableDictionary dictionary];
    attack = pManager.wdAttack + arc4random() % 5;
    [eNode.userData setObject:@(attack) forKey:@"attack"];
    [self.parent addChild:eNode];
    eNode.targetNode = self.parent;
    CGPoint movePoint2 = CGPointMake(eNode.position.x + 1000 * direction, eNode.position.y);
    SKAction *move = [SKAction moveTo:movePoint2 duration:0.5];
    SKAction *removeA = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[_model.musicAttackAction1,move,removeA]];
    
    [eNode runAction:seq];
}

//卡娜普通二段攻击
- (void)fireTwoAction
{
    CGFloat direction = [self leftOrRight];
    
    SKEmitterNode *eNode = [SKEmitterNode nodeWithFileNamed:@"Fire"];
    eNode.position = CGPointMake(self.position.x + direction * 50, self.position.y);
    eNode.name = _kanaFire;
    eNode.zPosition = 10;
    eNode.particleScale = 1;
        
    eNode.userData = [NSMutableDictionary dictionary];
    PersonManager *pManager = [PersonManager sharePersonManager];
    CGFloat attack = pManager.wdAttack;
    attack = pManager.wdAttack + arc4random() % 20 + 20;
    
    [eNode.userData setObject:@(attack) forKey:@"attack"];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:5.f];
    body.contactTestBitMask = 0;
    body.categoryBitMask = 1;
    body.collisionBitMask = 0;
    body.affectedByGravity = NO;
    eNode.physicsBody = body;
    [self.parent addChild:eNode];
    eNode.targetNode = self.parent;
    WDTextureManager *manager = [WDTextureManager shareManager];
    CGPoint movePoint2 = CGPointMake(eNode.position.x + manager.WD_MAX_WIDTH * direction, eNode.position.y);
    SKAction *move = [SKAction moveTo:movePoint2 duration:1];
    SKAction *alpha = [SKAction fadeAlphaTo:0 duration:1];
    SKAction *gr = [SKAction group:@[move,alpha]];
    SKAction *waitAction = [SKAction waitForDuration:1];
    SKAction *removeA = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[_model.musicAttackAction2,gr,waitAction,removeA]];
    

    [eNode runAction:seq completion:^{
    }];
}

#pragma mark 连续攻击记录按下攻击键的时间，触发连续攻击
- (void)continutyAction:(NSTimer *)timer
{
    _contCount += 0.1;
    if (_contCount > _nowAttackTime + 0.1) {
        [timer invalidate];
        _continuityAttackCount = 0;
        _contCount = 0;
    }
}

- (void)skillAction:(NSInteger)type
{
    if ([self isCanNotSkillAttack]) {
        return;
    }
    
    _monsterAttackCount ++;
    self.skillType = type;
    
    if (type == topSkillBtn) {
        [self skill1Action];
    }else if(type == middleSkillBtn){
        [self skill2Action];
    }else if(type == bottomSkillBtn){
        [self skill3Action];
    }else if(type == bottom2SkillBtn){
        [self skill4Action];
    }
    
    if ([self.name isEqualToString:@"person"]) {
        [self postSkillNotificationWithType:type];
    }
}

- (void)skill1Action{
    SKAction *textureAction = [SKAction animateWithTextures:_model.skill1Arr timePerFrame:0.1];
    SKAction *waitAction = [SKAction waitForDuration:0.2];
    CGFloat direction = [self leftOrRight];
    CGPoint movePoint2 = CGPointMake(self.position.x + 500 * direction, self.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    SKAction *moveAction = [SKAction moveTo:calculatePoint2 duration:0.3];
    SKAction *seq = [SKAction sequence:@[waitAction,moveAction]];
    SKAction *gr = [SKAction group:@[_model.musicSkillAction1,seq,textureAction]];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:gr completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
}

- (void)postSkillNotificationWithType:(NSInteger)type
{
    //告诉操作类技能已经释放
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSkillAction object:@{@"skillType":@(type)}];
}

- (void)skill2Action{
    
    [self setPhySicsBodyNone];
    [self setPhy];
    
    SKAction *textureAction = [SKAction animateWithTextures:[_model.skill2Arr subarrayWithRange:NSMakeRange(0, 4)] timePerFrame:0.1];
    CGFloat direction = [self leftOrRight];
    CGPoint movePoint2 = CGPointMake(self.position.x + 100 * direction, self.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    SKAction *moveAction = [SKAction moveTo:calculatePoint2 duration:0.3];
    SKAction *seq = [SKAction sequence:@[moveAction]];
    SKAction *gr = [SKAction group:@[_model.musicSkillAction2,seq,textureAction]];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:gr completion:^{
        [weakSelf setPhySicsBodyNone];
        [weakSelf setPhy];
        [weakSelf skill2ActionContinue];
    }];
}

- (void)skill2ActionContinue
{
        SKAction *textureAction = [SKAction animateWithTextures:[_model.skill2Arr subarrayWithRange:NSMakeRange(4, _model.skill2Arr.count - 4)] timePerFrame:0.1];
    __weak typeof(self)weakSelf = self;
    [self runAction:textureAction completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf endPhy];
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
}

- (void)skill3Action{
    [self setPhySicsBodyNone];
    [self performSelector:@selector(setPhy) withObject:nil afterDelay:0.5];
    SKAction *textureAction = [SKAction animateWithTextures:_model.skill3Arr timePerFrame:0.1];
    SKAction *gr = [SKAction group:@[_model.musicSkillAction3,textureAction]];
    __weak typeof(self)weakSelf = self;
    [self runAction:gr completion:^{
        [weakSelf endPhy];
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
}

- (void)skill4Action{
    SKAction *textureAction = [SKAction animateWithTextures:_model.skill4Arr timePerFrame:0.1];
    SKAction *waitAction = [SKAction waitForDuration:0.2];
    CGFloat direction = [self leftOrRight];
    CGPoint movePoint2 = CGPointMake(self.position.x + 500 * direction, self.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    SKAction *moveAction = [SKAction moveTo:calculatePoint2 duration:0.3];
    SKAction *seq = [SKAction sequence:@[waitAction,moveAction]];
    SKAction *gr = [SKAction group:@[_model.musicSkillAction4,seq,textureAction]];
    __weak typeof(self)weakSelf = self;
    [self runAction:gr completion:^{
        weakSelf.isSkillAttackIng = NO;
        [weakSelf stayAction];
        weakSelf.endSkillBlock();
    }];
}

- (void)stayAction
{
    if (self.isAttackIng || self.isBeAttackIng || self.isSkillAttackIng || self.isDefense) {
        return;
    }
    
    self.isMoveIng = NO;
    [self runAction:[WDActionTool moveActionWithMoveArr:_model.stayArr time:0.3]];
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

#pragma mark 代理基础行为
- (void)downAction:(BOOL)attakcerIsLeft
       attackCount:(CGFloat)count
{
    [self beAttackAction:attakcerIsLeft attackCount:count];
}

#pragma mark ----物理属性根据技能释放大小更改----

- (void)endPhy{
    self.physicsBody = nil;
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120, 100) center:CGPointMake(0, 0)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = PLAYER_CATEGORY;
    body.collisionBitMask = PLAYER_COLLISION;
    body.contactTestBitMask = PLAYER_CONTACT;
    
    self.physicsBody = body;
}

- (void)setPhy
{
    if ([self.name isEqualToString:@"kanaMonster"]) {
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(230, 100) center:CGPointMake(0, 0)];
        body.allowsRotation = NO;
        body.affectedByGravity = NO;
        body.categoryBitMask = MONSTER_CATEGORY;
        body.collisionBitMask = MONSTER_COLLISION;
        body.contactTestBitMask = MONSTER_CONTACT;
        
        self.physicsBody = body;
    }else{
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(230, 100) center:CGPointMake(0, 0)];
        body.allowsRotation = NO;
        body.affectedByGravity = NO;
        body.categoryBitMask = PLAYER_CATEGORY;
        body.collisionBitMask = PLAYER_COLLISION;
        body.contactTestBitMask = PLAYER_CONTACT;
        
        self.physicsBody = body;
    }
   
}

- (void)setPhySicsBodyNone
{
    self.physicsBody = nil;
}


#pragma mark --------------------kana作为BOSS的一些行为方法----------
- (void)setPersonNode:(BaseNode *)personNode
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSetBossBloodAction object:@{@"blood":@(2500)}];
    _personNode = personNode;
    self.wdNowBlood = 2500;
    _kanaFire = @"kanaMonsterFire";
    self.name = @"kanaMonster";
    _moveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveAction)];
    [_moveLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)monsterBeAttackAction:(BOOL)attackerIsLeft
                  attackCount:(CGFloat)count
{
    
    
    [WDActionTool demageAnimation:self point:CGPointMake(0, 10) scale:0.5 demagePic:@"demage1"];
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    
    self.wdNowBlood -= count;
    if (self.wdNowBlood <= 0) {
        self.isDeadIng = YES;
        [self.delegate deadAction:attackerIsLeft];
        return;
    }

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

- (void)moveAction{
    [self moveWithPersonPosition:_personNode.position];
}

- (void)clearAction
{
    [super clearAction];
    if (_moveLink) {
        [_moveLink invalidate];
        _moveLink = nil;
    }
    
    if (_contTimer) {
        [_contTimer invalidate];
        _contTimer = nil;
    }
}

- (void)reloadMonsterCount
{
    if (_personNode.isDeadIng) {
        [self removeAllActions];
    }else{
        _monsterAttackCount = 0;
        self.isAttackIng = NO;
    }
}

- (void)moveWithPersonPosition:(CGPoint)personPosition
{
    if (self.isAttackIng || self.isBeAttackIng || self.isDeadIng || self.isSkillAttackIng) {
        return;
    }
    
    if (_monsterAttackCount > arc4random() % 5 + 5 || _personNode.isDeadIng) {
        self.isAttackIng = YES;
        __weak typeof(self)weakSelf = self;
        [self runAction:[SKAction animateWithTextures:self.model.winArr timePerFrame:0.3]  completion:^{
            [weakSelf reloadMonsterCount];
        }];
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
    if (fabs(distanceY) < 30 && fabs(distanceX) > minX && fabs(distanceX) < farX) {
        int a = arc4random() % 5;
        if (a < 3) {
            [self attackAction];
        }else{
            [self skillAction:arc4random() % 4];
        }
        return;
    }else if(fabs(distanceY) < 10 && fabs(distanceY) > 0){
        moveY = monsterY;
    }else if(distanceY > 0){
        moveY = monsterY + self.wdSpeed;
    }else if(distanceY < 0){
        moveY = monsterY - self.wdSpeed;
    }
    
    CGPoint calculatePoint = [WDCalculateTool calculateMaxMoveXAndY:CGPointMake(moveX, moveY) maxX:2500 maxY:650 personSize:CGSizeMake(self.imageWidth, self.imageHeight)];
    
    self.position = calculatePoint;
    self.zPosition = 650 - self.position.y;
    if (!self.isMoveIng) {
        
        self.isMoveIng = YES;
        //
        SKAction *moveAction = [SKAction animateWithTextures:_model.moveArr timePerFrame:0.15];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

@end
