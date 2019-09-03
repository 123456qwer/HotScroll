//
//  BaseNode.m
//  HotSchool
//
//  Created by 吴冬 on 2018/7/1.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@implementation BaseNode

- (void)setBossMonster:(BaseNode *)node
{}

#pragma mark 父类初始化方法
- (void)initActionWithModel:(WDBaseModel *)model;
{  
   // [self centerSprite:[UIColor orangeColor]];
    
    
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
}

- (WDTextureManager *)textureManager
{
    if (!_textureManager) {
        _textureManager = [WDTextureManager shareManager];
    }
    
    return _textureManager;
}

- (void)setPhy{
    self.physicsBody.categoryBitMask    = 0;
    self.physicsBody.contactTestBitMask = MONSTER_CONTACT;
    self.physicsBody.collisionBitMask   = 0;
}

- (void)setMonsterNormalPhybodyWithFrame:(CGRect)rect
{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(rect.size.width, rect.size.height) center:CGPointMake(rect.origin.x, rect.origin.y)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = 0;
    self.physicsBody = body;
}

- (void)createBlackCircle
{
    _blackCircleNode = [[BaseNode alloc] initWithTexture:self.textureManager.blackCircleArr[0]];
    _blackCircleNode.position = CGPointMake(-14,  - 40);
    _blackCircleNode.zPosition = -1;
    _blackCircleNode.name = @"blackCircle";
    [self addChild:_blackCircleNode];
    
    SKAction *moveAction = [SKAction animateWithTextures:self.textureManager.blackCircleArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:moveAction];
    [_blackCircleNode runAction:rep];
     
}

- (void)realBackGroundWithColor:(UIColor *)color
{
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithColor:color size:self.size];
    node.zPosition = -10;
    node.name = @"real";
    [self addChild:node];
}

- (void)centerSprite:(UIColor *)color
{
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithColor:color size:CGSizeMake(10, 10)];
    node.zPosition = 10;
    node.name = @"real";
    [self addChild:node];
}

- (void)removeRealNode
{
    SKSpriteNode *node = (SKSpriteNode *)[self childNodeWithName:@"real"];
    [node removeFromParent];
}

- (void)physicalBackGroundNodeWithColor:(UIColor *)color
                                   size:(CGSize)size
                               position:(CGPoint)point
{
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithColor:color size:size];
    node.zPosition = -9;
    node.name = @"phys";
    node.position = point;
    [self addChild:node];
}

- (void)removePhysicalNode
{
    SKSpriteNode *node = (SKSpriteNode *)[self childNodeWithName:@"phys"];
    [node removeFromParent];
}


/** 是否死亡 */
- (BOOL)isDeadAction:(CGFloat)count
   attackerDirection:(BOOL)attackerIsLeft
{
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    self.wdNowBlood -= count;
    [PersonManager sharePersonManager].nowBlood = self.wdNowBlood;
    
    
    
    WDNotificationManager *manager = [WDNotificationManager shareManager];
    [manager postNotificationWithAllBlood:self.wdBlood nowBlood:self.wdNowBlood changeCount:-count];
    
    
    
    if (self.wdNowBlood <= 0) {
        [self setPhySicsBodyNone];
        self.isDeadIng = YES;
        [self clearAction];
        [self removeAllActions];
        
        SKAction *deadAction = [WDActionTool deadAnimationWithAttackDirection:attackerIsLeft deadArr:[self.model.beAttackArr subarrayWithRange:NSMakeRange(0, 3)] node:self];
        [self setPhySicsBodyNone];
        
        __weak typeof(self)weakSelf = self;
        [self runAction:deadAction completion:^{
            if (weakSelf.deadBlock) {
                weakSelf.deadBlock(weakSelf.name);
            }
        }];
        return YES;
    }
    
    return NO;
}

- (void)beSkillAttackAction:(BOOL)attackerIsLeft
                attackCount:(CGFloat)count{}

- (void)stayAction{}

- (BOOL)moveAction:(NSString *)direction
             point:(CGPoint)point
{
    return NO;
}

- (void)animationStop
{
}

- (void)clearAction
{}

- (void)skillAction:(NSInteger)type
{}


- (void)setPhySicsBodyNone
{
    self.physicsBody.categoryBitMask    = 0;
    self.physicsBody.contactTestBitMask = 0;
    self.physicsBody.collisionBitMask   = 0;
}

- (int)directon
{
    NSString *direction = @"";
    if (self.xScale > 0) {
        direction = @"right";
    }else{
        direction = @"left";
    }
    
    if ([direction isEqualToString:@"left"]) {
        _directon = -1;
    }else if ([direction isEqualToString:@"right"]){
        _directon = 1;
    }
    
    return _directon;
}

- (void)testText
{
    if (IS_TEST) {
        if (self.isAttackIng) {
            NSLog(@"%@ 正在攻击中,攻击阶段为 %ld",self.name,(long)self.attackType);
        }
        
        if (self.isBeAttackIng) {
            NSLog(@"%@ 正在被攻击中",self.name);
        }
        
        if (self.isSkillAttackIng) {
            NSLog(@"%@ 正在释放技能 %ld",self.name,(long)self.skillType);
        }
        
        if (self.isDeadIng) {
            NSLog(@"%@ 已经挂了",self.name);
        }
    }
}

/**
 进行攻击之前，检测Node当前状态
 
 @return 返回是否可以进行攻击
 */
- (BOOL)isCanNotAttack
{
    if (self.isAttackIng || self.isBeAttackIng || self.isSkillAttackIng || self.isDeadIng) {
        
        [self testText];
        return YES;
        
    }else{
    
        self.isAttackIng      = YES;
        
        self.isBeAttackIng    = NO;
        self.isSkillAttackIng = NO;
        self.isMoveIng        = NO;
        
        return NO;
    }
}

/**
 技能攻击之前，检测Node当前状态
 
 @return 返回是否可以进行技能攻击
 */
- (BOOL)isCanNotSkillAttack
{
    if (self.isBeAttackIng || self.isSkillAttackIng || self.isDeadIng || self.isAttackIng) {
        
        [self testText];
        return YES;
    }else{
        
        self.isSkillAttackIng = YES;
        
        self.isAttackIng      = NO;
        self.isBeAttackIng    = NO;
        self.isMoveIng        = NO;
        
        
        return NO;
    }
}

/**
 移动之前，检测Node当前状态
 
 @return 返回是否可以移动
 */
- (BOOL)isCanNotMove;
{
    if (self.isAttackIng || self.isBeAttackIng || self.isSkillAttackIng || self.isDeadIng) {
        [self testText];
        return YES;
    }else{
        return NO;
    }
}

/**
 被攻击之前，检测Node当前状态
 
 @return 返回是否可以被攻击
 */
- (BOOL)isCanNotBeAttack{
    
    if(self.isBeAttackIng || self.isSkillAttackIng || self.isDeadIng || self.isDefense || self.isInvincible){
        return YES;
    }else{
        
        //[self allStatusClear];
        self.isBeAttackIng = YES;
        return NO;
    }
}


/**
 蓄力攻击之前，判断是否可以蓄力
 */
- (BOOL)isCanNotPressAttack
{
    if (self.isAttackIng || self.isBeAttackIng || self.isSkillAttackIng || self.isDeadIng) {
        
        [self testText];
        
        return YES;
    }else{
        
        self.isPressIng = YES;
        
        self.isSkillAttackIng = NO;
        self.isAttackIng      = NO;
        self.isBeAttackIng    = NO;
        self.isMoveIng        = NO;
        

        return NO;
    }
}

- (void)allStatusClear
{
    self.isAttackIng      = NO;
    self.isSkillAttackIng = NO;
    self.isBeAttackIng    = NO;
    self.isMoveIng        = NO;
    self.isPressIng       = NO;
}

- (CGFloat)leftOrRight{
    NSInteger direction = 1;
    if (self.xScale < 0) {
        direction = -1;
    }
    return direction;
}

- (void)dealloc
{
    //肯定释放的不需要记录
    NSDictionary *dic = @{@"seagull":@"1",@"arrow":@"1",@"demage1":@"1",@"money":@"1",@"skillDemage":@"1",@"meteoriteShadow":@"1",@"flash":@"1",@"meteorite1":@"1",@"cloud":@"1",@"target":@"1",@"smoke":@"1",@"light":@"1",@"blackCircle":@"1"};
    
    if (![dic objectForKey:self.name]) {
        //NSLog(@"%@ 释放了",self.name);
    }
    
}

@end






#pragma mark 怪物node
//✨✨✨✨✨✨✨✨✨✨✨✨✨怪物NODE父类✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨//
@implementation BaseMonsterNode
{
    CADisplayLink *_moveLink;
}

#pragma mark 怪物初始化方法
- (void)initActionWithModel:(WDBaseModel *)model
{
    //[self centerSprite:[UIColor orangeColor]];

    [super initActionWithModel:model];
    
    _min_X_Distance = 60;
    _min_Y_Distance = 60;
    
    self.model = model;
    
    _moveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveAction)];
    [_moveLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

#pragma mark
- (void)setPersonNode:(BaseNode *)personNode
{
    _personNode = personNode;
}

#pragma mark 通常怪物的移动方法
- (void)moveAction{

    //这里走代理方法，签订代理，强制实现
    if ([self.monsterDelegate respondsToSelector:@selector(monsterMoveAction:)]) {
        [self.monsterDelegate monsterMoveAction:_personNode];
    }
}


/**
 被攻击之前，检测Node当前状态
 
 @return 返回是否可以被攻击
 */
- (BOOL)isCanNotBeAttack{
    
    if(self.isBeAttackIng || self.isSkillAttackIng || self.isDeadIng || self.isDefense || self.isInvincible){
        return YES;
    }else{
        
        //[self allStatusClear];
        self.isBeAttackIng = YES;
        return NO;
    }
}


- (void)deadAnimation:(BOOL)attackerIsLeft
{
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
        [weakSelf deadAction];
    }];
    
    return;
}

- (void)deadAction
{
    if (self.deadBlock) {
        self.deadBlock(self.name);
    }
}

#pragma mark 怪物触发攻击方法
- (void)monsterAttackAction
{
    NSLog(@"%@触发攻击方法",self.name);
}


#pragma mark 
- (void)clearAction
{
    [super clearAction];
    if (_moveLink) {
        [_moveLink invalidate];
        _moveLink = nil;
    }
}


- (void)monsterMoveAction:(BaseNode *)personNode {
    NSLog(@"子类实现");
}


@end


