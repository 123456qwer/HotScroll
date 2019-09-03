//
//  BaseScene.m
//  HotSchool
//
//  Created by Mac on 2018/7/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseScene.h"

#import "AnimationSeagullNode.h"
#import "AnimationLizardNode.h"
#import "AnimationSquirrelNode.h"
#import "PassDoorNode.h"

@implementation BaseScene
{
    CADisplayLink *_mapMoveLink;
    CGFloat        _halfX;
    NSTimer *_seaGullTimer;
    NSTimer *_passTimer;   //通关所用时间
    
    BOOL _delateMoveState;
    
    
    NSMutableArray *_map_x_arr;
    NSMutableArray *_map_y_arr;
}



#pragma mark 构建方法
- (void)didMoveToView:(SKView *)view
{
    //设置代理
    self.physicsWorld.contactDelegate = self;
    self.starTimes = 30;
   
    //延迟人物移动
    _delateMoveState = YES;
    [self performSelector:@selector(canMove) withObject:nil afterDelay:1];
    
    //创建地图和link
    [self createMapAndMapLink];
    //创建人物
    [self createPlayer];
    
    //根据机型适配
    if (IS_IPHONEX) {
        [self createMapPositionX:2500 y:650 halfX:812 halfY:650 / 2.0];
        self.size = CGSizeMake(812*2.0, 750);
    }else{
        //设置人物位置对应的地图坐标
        [self createMapPositionX:2500 y:650 halfX:1334 / 2.0 halfY:650 / 2.0];
    }
    
    
    //初始化一些增益效果
    [_personNode setBuff];
    
    
    //初始化天气
    WDSceneManager *sManager = [WDSceneManager shareSeting];
    [sManager setSceneWeatherWithSuperNode:_bgNode];
    
}


#pragma mark 创建背景地图、地图监听
- (void)createMapAndMapLink
{
    self.bgNode = (BaseNode *)[self childNodeWithName:@"bgNode"];
    self.bgNode.zPosition = 1;
    self.bgNode.name = @"bg";
    
    self.bgNode2 = (BaseNode *)[self childNodeWithName:@"iceBgNode"];
    self.bgNode2.zPosition = -1;
    self.bgNode2.name = @"bg2";

    
    //地图移动监听
    [self starMapMoveLink];
}


- (void)starMapMoveLink
{
    _mapMoveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(mapMove)];
    [_mapMoveLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark 创建玩家
- (void)createPlayer
{
    PersonManager *manager = [PersonManager sharePersonManager];
    
    //默认玩家
    if ([manager.name isEqualToString:@"person"]){
        [self createPersonNode:self.personModel];
        //_personNode.anchorPoint = CGPointMake(0.3, 0.5);
    }
    
    //夏娜玩家
    if ([manager.name isEqualToString:@"shana"]) {
        [self createShanaNode:self.shanaModel];
    }
    
    if ([manager.name isEqualToString:@"kana"]) {
        [self createKanaNode:self.kanaModel];
    }
}

- (void)canMove
{
    _passTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(passTimeAction:) userInfo:nil repeats:YES];
    _delateMoveState = NO;
}

- (void)passTimeAction:(NSTimer *)timer
{
    _useTimes ++;
}

/** 场景动物 */
- (void)createSceneAnimation
{
    //海鸥
//    [self createSeagullAnimation];
//    //蜥蜴
//    //[self createLizardAnimation];
//    //松鼠
//    [self createSquirrelAnimation];
//    [self createSquirrelAnimation];
//
//    [self createBorderTree];
}


/** 左右倆端边缘的树 */
- (void)createBorderTree{
    
    /*
    if ([WDSceneManager shareSeting].selectIndex < 7) {
        [self createBorderTreeWithPoint:CGPointMake(50, 200) bodyPoint:CGPointMake(-200, 0)];
        [self createBorderTreeWithPoint:CGPointMake(self.textureManager.WD_MAX_WIDTH - 100, 200) bodyPoint:CGPointMake(0, 0)];
    }else{
        SKEmitterNode *node = [SKEmitterNode nodeWithFileNamed:@"WallFire"];
        node.zPosition = 20000;
        node.position = CGPointMake(180, 750 / 2.0);
        [self.bgNode addChild:node];
        
        
        SKEmitterNode *node2 = [SKEmitterNode nodeWithFileNamed:@"WallFire"];
        node2.zPosition = 20000;
        node2.position = CGPointMake(self.bgNode.size.width - 180, 750 / 2.0);
        node2.name = @"hide";
        [self.bgNode addChild:node2];
    }
     */
  
}

- (AnimationChestNode *)createChestWithBossPoint:(CGPoint)point;
{
    return [AnimationChestNode createChestNode:self.bgNode position:point];
}

- (void)createSquirrelAnimation
{
    [AnimationSquirrelNode createNodeWithSuperNode:self.bgNode personNode:self.personNode];
}

- (void)createLizardAnimation
{
    [AnimationLizardNode createNodeWithSuperNode:self.bgNode maxX:3000 maxY:900];
}



#pragma mark 物理检测开始
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    BaseNode *nodeA = (BaseNode *)contact.bodyA.node;
    BaseNode *nodeB = (BaseNode *)contact.bodyB.node;
    
    if ([nodeB.name isEqualToString:@"passDoor"] || [nodeA.name isEqualToString:@"passDoor"]) {
        self.isChest = YES;
        [self.notificationManager postNotificationForAttackType:click];
    }else{
        self.isChest = NO;
        [self.notificationManager postNotificationForAttackType:attack];
    }

    //AIRWALL
    if ([nodeB.name isEqualToString:@"FIRST_AIRWALL"]) {
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL"];
        if (!node) {
            node = [SKEmitterNode nodeWithFileNamed:@"WallFire"];
            node.zPosition = 20000;
            node.name = @"FIRE_WALL";
            node.position = CGPointMake(180, 750 / 2.0);
            [self.bgNode addChild:node];
        }
    }
    if ([nodeB.name isEqualToString:@"BOTTOM_AIRWALL"]) {
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL"];
        if (!node) {
            node = [SKEmitterNode nodeWithFileNamed:@"WallFire"];
            node.zPosition = 20000;
            node.name = @"FIRE_WALL";
            node.position = CGPointMake(self.bgNode.size.width - 180, 750 / 2.0);
            [self.bgNode addChild:node];
        }
    }
    
    
    //游戏碰撞逻辑
    [WDGameLogic beginContact:contact];

}

#pragma mark 物理检测结束
- (void)didEndContact:(SKPhysicsContact *)contact
{
    self.isChest = NO;
    [self.notificationManager postNotificationForAttackType:attack];
    
    BaseNode *nodeA = (BaseNode *)contact.bodyA.node;
    BaseNode *nodeB = (BaseNode *)contact.bodyB.node;
    //NSLog(@"%@",contact);
    if ([nodeB.name isEqualToString:@"tree"]) {
        [nodeB runAction:[SKAction fadeAlphaTo:1 duration:0.2]];
    }else if([nodeA.name isEqualToString:@"tree"]) {
        [nodeA runAction:[SKAction fadeAlphaTo:1 duration:0.2]];
    }
    
    

    
    if ([nodeB.name isEqualToString:@"FIRST_AIRWALL"]) {
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL"];
        SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.3];
        [node runAction:[SKAction sequence:@[alpha,[SKAction removeFromParent]]]];
    }
    
    
    if ([nodeB.name isEqualToString:@"BOTTOM_AIRWALL"]) {
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL"];
        SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.3];
        [node runAction:[SKAction sequence:@[alpha,[SKAction removeFromParent]]]];
    }
}

#pragma mark 场景动画
- (void)seagullAction:(NSTimer *)times
{
    NSInteger time = 1;
    if (_seaGullTimer) {
        [_seaGullTimer invalidate];
        _seaGullTimer = nil;
    }
    _seaGullTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(seagullAction:) userInfo:nil repeats:NO];
    [AnimationSeagullNode createNodeWithSuperNode:self.bgNode2 maxX:3000 maxY: 900];
    
}

- (void)createSeagullAnimation
{
    //海鸥场景动画
    _seaGullTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(seagullAction:) userInfo:nil repeats:NO];
}



#pragma mark ----地图移动----
- (void)mapMove{
    
    //NSLog(@"%lf",_personNode.position.y);
    
    if (_personNode.position.y < _personNode.imageHeight) {
        _personNode.position = CGPointMake(_personNode.position.x, _personNode.imageHeight);
    }
    
    if (_personNode.position.x < _personNode.imageWidth / 2.0 + kScreenWidth / 2.0) {
        _personNode.position = CGPointMake(_personNode.imageWidth / 2.0 + kScreenWidth / 2.0, _personNode.position.y);
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL1"];
        if (!node) {
            node = [SKEmitterNode nodeWithFileNamed:@"WallFire"];
            node.zPosition = 20000;
            node.name = @"FIRE_WALL1";
            node.position = CGPointMake(180, 750 / 2.0);
            [self.bgNode addChild:node];
        }
    }else{
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL1"];
        if (node) {
            SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.3];
            [node runAction:[SKAction sequence:@[alpha,[SKAction removeFromParent]]]];
        }
       
    }
    

    if (_personNode.position.x > self.textureManager.WD_MAX_WIDTH - _personNode.imageWidth / 2.0 - kScreenWidth / 2.0) {
       
        //直接跳下一关
        if (self.canGoNextScene) {
            [self goNext];
            return;
        }
        
        
        _personNode.position = CGPointMake(self.textureManager.WD_MAX_WIDTH - _personNode.imageWidth / 2.0 - kScreenWidth / 2.0, _personNode.position.y);
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL2"];
        if (!node) {
            node = [SKEmitterNode nodeWithFileNamed:@"WallFire"];
            node.zPosition = 20000;
            node.name = @"FIRE_WALL2";
            node.position = CGPointMake(self.bgNode.size.width - 180, 750 / 2.0);
            [self.bgNode addChild:node];
        }
    }else{
        SKEmitterNode *node = (SKEmitterNode *)[self.bgNode childNodeWithName:@"FIRE_WALL2"];
        if (node) {
            SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.3];
            [node runAction:[SKAction sequence:@[alpha,[SKAction removeFromParent]]]];
        }
       
    }
    
    NSInteger x_index = (NSInteger)self.personNode.position.x;
    if (x_index < 0 || x_index > _map_x_arr.count - 1) {
        return;
    }
    
    //火焰剑移动
    CGFloat x = [_map_x_arr[x_index] floatValue];
    self.bgNode.position = CGPointMake(x, 0);
    [WDSceneManager shareSeting].xMove = x;
    [PersonManager fireBladeMove:_personNode];
}

- (void)goNext{
   
    [self clearAction];
    
    if (self.changeSceneBlock) {
        NSArray *sceneNameArr = @[@"BeginScene",@"WD1Scene",@"WD2Scene",@"WD3Scene",@"WD4Scene",@"Boss1Scene",@"WD5Scene",@"WD6Scene",@"WD7Scene",@"WD8Scene",@"Boss2Scene",@"WD9Scene",@"WD10Scene",@"WD11Scene",@"WD12Scene"];
        ;
        NSInteger index = 0;
        for (NSInteger i = 0; i < sceneNameArr.count; i ++) {
            NSString *str = sceneNameArr[i];
            if ([str isEqualToString:NSStringFromClass([self class])]) {
                index = i;
            }
        }
        PersonManager *manager = [PersonManager sharePersonManager];
        [[WDNotificationManager shareManager]postNotificationWithMissCount:manager.wdMiss];
        self.changeSceneBlock(++ index);
    }
    
}

- (void)createMapPositionX:(CGFloat)x
                         y:(CGFloat)y
                     halfX:(CGFloat )halfX
                     halfY:(CGFloat)halfY
{
    _map_x_arr = [NSMutableArray array];
    _map_y_arr = [NSMutableArray array];
    
    x = self.textureManager.WD_MAX_WIDTH;
    y = self.textureManager.WD_MAX_HEIGHT;
    
    for (int i = 0; i < x; i ++) {
        if (i < halfX) {
            [_map_x_arr addObject:@(0)];
        }else if(i > x - halfX){
            [_map_x_arr addObject:@(-(x - halfX * 2.0))];
        }else{
            [_map_x_arr addObject:@(-(i - halfX))];
        }
    }
    
    for (int i = 0; i < y; i ++) {
        if (i < halfY) {
            [_map_y_arr addObject:@(0)];
        }else if(i > y - halfY){
            [_map_y_arr addObject:@(-(y - halfY))];
        }else{
            [_map_y_arr addObject:@(-(i - halfY))];
        }
    }
    _halfX = -(x - halfX * 2.0);
}

- (void)clearAction
{
    if (_mapMoveLink) {
        [_mapMoveLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_mapMoveLink invalidate];
        _mapMoveLink = nil;
    }
    
    if (_passTimer) {
        [_passTimer invalidate];
        _passTimer = nil;
    }
    
    
    //停止鹤的timer
    if (_seaGullTimer) {
        [_seaGullTimer invalidate];
        _seaGullTimer = nil;
    }
    
    //释放杂兵
    for (int i = 0; i < self.monsterDic.count; i++) {
        BaseNode *node = self.monsterDic[self.monsterDic.allKeys[i]];
        [node clearAction];
        [node removeAllActions];
        [node removeFromParent];
    }

    [_monsterDic removeAllObjects];
    [self.personNode clearAction];
    
    self.isDead = YES;
}

- (void)longAttackEndAction:(NSString *)direction;
{}

- (void)longAttackBeginAction:(NSString *)direction
{}

//✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨通用方法✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨//
#pragma mark 创建玩家的通用方法<避免每次都要重新写，烦躁>
- (void)createPlayerWithModel:(WDBaseModel *)model
{
    self.personNode.position = CGPointMake(1280, 300);
    self.personNode.xScale = 2;
    self.personNode.yScale = 2;
    self.personNode.zPosition = 100;
    
    [self.bgNode addChild:self.personNode];
    [self.personNode initActionWithModel:model];
    [self.personNode stayAction];
    
    [self attackAndSkillBlock];
}

/** 创建默认的玩家1 */
- (BaseNode *)createPersonNode:(Person1Model *)model
{
    self.personNode = [Person1Node spriteNodeWithTexture:model.moveArr[0]];
    [self createPlayerWithModel:model];
 
    return self.personNode;
}

/** 创建夏娜 */
- (BaseNode *)createShanaNode:(ShanaModel *)model
{
    self.personNode = [ShanaNode spriteNodeWithTexture:model.moveArr[0]];
    [self createPlayerWithModel:model];
    
    return self.personNode;
}


/** 创建卡娜 */
- (BaseNode *)createKanaNode:(KanaModel *)model
{
    self.personNode = [KanaNode spriteNodeWithTexture:model.moveArr[0]];
    [self createPlayerWithModel:model];
    
    return self.personNode;
}

#pragma mark 移动方法
- (void)moveActionWithDirection:(NSString *)direction
                       position:(CGPoint)point
{
    if (_delateMoveState) {
        return;
    }
    [self.personNode moveAction:direction point:point];
}

#pragma mark 停止移动方法
- (void)stopMoveActionWithDirection:(NSString *)direction
{
    [self.personNode stayAction];
}

#pragma mark 攻击以及技能按键<技能攻击通过物理碰撞来检测是否攻击到>
- (void)skillActionWithType:(NSInteger)type
{   
    [self.personNode skillAction:type];
}

#pragma mark 普通攻击<普通攻击通过和怪物node的当前距离来检测是否攻击到>
- (void)attackAction:(NSString *)direction
{
    if (self.isChest) {
        
        self.selectMapBlock();
        return;

    }
   
    
    [self.personNode.delegate attackAction];
}

#pragma mark 攻击和技能回调
- (void)attackAndSkillBlock
{
    //times（攻击动画实质攻击到的延迟）
    __weak typeof(self)weakSelf = self;
    [self.personNode setAttackBlockWithTime:^(CGFloat times, NSInteger attackType) {
        [weakSelf performSelector:@selector(normalAttack) withObject:nil afterDelay:times];
    }];
    
    [self.personNode setSkillBlockWithTime:^(CGFloat times, NSInteger skillType) {
        [weakSelf performSelector:@selector(skillAttack) withObject:nil afterDelay:times];
        [weakSelf setWallZeroPhy];
    }];
    
    [self.personNode setDeadBlock:^(NSString *name) {
        [WDActionTool showDiedText:weakSelf];
        weakSelf.isDead = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangePersonAction object:@{@"name":@"person"}];
        
        if (weakSelf.deadBlock) {
            weakSelf.deadBlock(name);
        }
    }];
    
    [self.personNode setEndSkillBlock:^{
        [weakSelf setWallPhy];
    }];
}




/** 技能攻击，延迟恢复物理碰撞以达到攻击效果 */
- (void)skillAttack
{
    [self.personNode setPhy];
}

/** 普通攻击 */
- (BOOL)normalAttack
{
    if (self.personNode.isBeAttackIng) {
        return NO;
    }
    
    //攻击的时候遍历
    for (int i = 0; i < self.monsterDic.count; i++) {
        BaseNode *node = self.monsterDic[self.monsterDic.allKeys[i]];
        CGFloat distanceX = self.personNode.position.x - node.position.x;
        CGFloat distanceY = self.personNode.position.y - node.position.y;
        
        BOOL isLeft = NO;
        if (distanceX < 0) {
            isLeft = YES;
        }
        
        CGFloat attackNumber = self.personNode.wdAttack;
        
        
        NSArray *arr = @[@(arc4random() % 5),@(arc4random() % 5 + 5),@(arc4random() % 5 + 10),@(arc4random() % 5 + 15)];
        CGFloat fudongNumber = [arr[self.personNode.attackType]integerValue];
        
        
        CGFloat bigDistance = 200;
        if (self.personNode.attackType == FOURAttack) {
            bigDistance = 350;
        }
        
        if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
            [node.delegate beAttackAction:isLeft attackCount:fudongNumber + attackNumber];
        }
    }
    
    return YES;
}


- (void)setWallZeroPhy
{
    
    for (int i = 0; i < _wallCount; i ++) {
        NSString *nodeName = [NSString stringWithFormat:@"wall%d",i+1];
        SKSpriteNode *wallNode = (SKSpriteNode *)[self.bgNode childNodeWithName:nodeName];
        wallNode.alpha = 0;
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:wallNode.size];
        body.categoryBitMask = 0;
        body.collisionBitMask = 0;
        body.contactTestBitMask = 0;
        body.affectedByGravity = NO;
        wallNode.physicsBody = body;
    }
}

- (void)setWallPhy
{
    for (int i = 0; i < _wallCount; i ++) {
        NSString *nodeName = [NSString stringWithFormat:@"wall%d",i+1];
        SKSpriteNode *wallNode = (SKSpriteNode *)[self.bgNode childNodeWithName:nodeName];
        wallNode.alpha = 0;
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:wallNode.size];
        body.categoryBitMask = WALL_CATEGORY;
        body.collisionBitMask = WALL_COLLISION;
        body.contactTestBitMask = WALL_CONTACT;
        body.affectedByGravity = NO;
        wallNode.physicsBody = body;
    }
}

//游戏关卡胜利
- (void)standAction
{
    [self.personNode allStatusClear];
    self.personNode.isAttackIng = YES;
    [self.personNode removeAllActions];
    SKAction *action = [SKAction animateWithTextures:self.personNode.model.winArr timePerFrame:0.2];
    [self.personNode runAction:action completion:^{
    }];
}

/** 选择关卡的门 */
- (void)createPassDoor
{
    
     PassDoorNode *_passDoorNode = [PassDoorNode spriteNodeWithTexture:self.textureManager.passDoorModel.animationArr[0]];
    _passDoorNode.position = CGPointMake(1400, 350);
    _passDoorNode.zPosition = 650 - _passDoorNode.position.y;
    _passDoorNode.xScale = 1.5;
    _passDoorNode.yScale = 1.5;
    [self.bgNode addChild:_passDoorNode];
    
    SKAction *rep = [SKAction repeatActionForever:[SKAction animateWithTextures:self.textureManager.passDoorModel.animationArr timePerFrame:0.1]];
    [_passDoorNode runAction:rep];
    [_passDoorNode initActionWithModel:nil];
}

//进入下一关的许可方法
- (void)createNextWallAndArrow
{
    BaseNode *node = (BaseNode *)[self childNodeWithName:@"arrowGOGOGO"];
    if (node) {
        return;
    }
    
    [self createPassDoor];
    
    if (self.sceneIndex >= 0) {
        NSInteger starCount = 1;
        
        if (_useTimes <= _starTimes) {
            starCount ++;
        }
        
        if (self.personNode.wdBlood == self.personNode.wdNowBlood) {
            starCount ++;
        }
        
        
        NSString *key = [NSString stringWithFormat:@"starNum_%ld",(long)self.sceneIndex];
        NSInteger beforeCount = [[NSUserDefaults standardUserDefaults]integerForKey:key];
        if (beforeCount < starCount) {
            [[NSUserDefaults standardUserDefaults]setInteger:starCount forKey:key];
        }
        
        [WDActionTool showPassLabelWithScene:self];
        [self standAction];
    }
    
    
    
    BaseNode *arrowNode = [BaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"rightArrow"]]];
    CGFloat x = 1334 / 2.0;
    CGFloat y =  650;
    arrowNode.position = CGPointMake(x,y);
    arrowNode.zPosition = 10000;
    arrowNode.name = @"arrowGOGOGO";
    arrowNode.alpha = 0.6;
    [self addChild:arrowNode];
    
    SKAction *move = [SKAction moveTo:CGPointMake(x + 100,y) duration:1.0];
    SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0];
    SKAction *moveA = [SKAction moveTo:CGPointMake(x,y) duration:0];
    SKAction *alpha2 = [SKAction fadeAlphaTo:0.6 duration:0];
    
    SKAction *sequ = [SKAction sequence:@[move,alpha,moveA,alpha2]];
    SKAction *rep = [SKAction repeatActionForever:sequ];
    [arrowNode runAction:rep];
    
    self.canGoNextScene = YES;
    
    SKEmitterNode *fireNode = [SKEmitterNode nodeWithFileNamed:@"Fire"];
    fireNode.position = CGPointMake(self.textureManager.WD_MAX_WIDTH - kScreenWidth / 2.0 + self.personNode.imageWidth, 200);
    fireNode.zPosition = 10000;
    fireNode.name     = @"fffff";
    fireNode.particleLifetimeRange = 1;
    [self.bgNode addChild:fireNode];
    
    fireNode.targetNode = self.bgNode;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.textureManager.WD_MAX_WIDTH - kScreenWidth / 2.0, 0, 1, 750)];
    SKAction *moveAction2 = [SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:0.3];
    [fireNode runAction:[SKAction repeatActionForever:moveAction2]];
}




- (void)createBorderTreeWithPoint:(CGPoint)point
                       bodyPoint:(CGPoint)bodyPoint
{
    
    BaseNode *treeNode = [BaseNode spriteNodeWithTexture:self.textureManager.bottomTree];
    treeNode.position = point;
    treeNode.zPosition = 9999;
    treeNode.name = @"tree";
    treeNode.alpha = 0.5;
    [self.bgNode addChild:treeNode];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:treeNode.size center:bodyPoint];
    
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.collisionBitMask = 0;
    body.contactTestBitMask = SHANA_CONTACT;
    treeNode.physicsBody = body;
}

- (void)loadPersonNode
{
    PersonManager *manager = [PersonManager sharePersonManager];
    if ([manager.name isEqualToString:@"person"]) {
        self.personModel = self.textureManager.personModel;
    }else if([manager.name isEqualToString:@"shana"]){
        self.shanaModel = self.textureManager.shanaModel;
    }else if([manager.name isEqualToString:@"kana"]){
        self.kanaModel = self.textureManager.kanaModel;
    }
}

- (WDTextureManager *)textureManager
{
    if (!_textureManager) {
        _textureManager = [WDTextureManager shareManager];
    }
    return _textureManager;
}

- (WDNotificationManager *)notificationManager
{
    if (!_notificationManager) {
        _notificationManager = [WDNotificationManager shareManager];
    }
    return _notificationManager;
}

- (NSMutableDictionary *)monsterDic
{
    if (!_monsterDic) {
        _monsterDic = [NSMutableDictionary dictionary];
    }
    return _monsterDic;
}



#pragma mark ---工具方法---
- (NSString *)numberToStr:(NSInteger)number
{
    return [NSString stringWithFormat:@"%ld",(long)number];
}





@end
