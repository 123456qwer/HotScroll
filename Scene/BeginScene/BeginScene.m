//
//  BeginScene.m
//  HotSchool
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BeginScene.h"
#import "WDSceneManager.h"

#import "Person1Model.h"
#import "Person1Node.h"

#import "ShanaNode.h"
#import "KanaNode.h"

#import "NPCModel1.h"
#import "NPCNode1.h"
#import "NPC2.h"
#import "ShanaModel.h"
#import "ShanaMonster.h"

#import "PassDoorNode.h"
#import "PassDoorModel.h"

#import "AnimationSquirrelNode.h"
#import <GameplayKit/GameplayKit.h>

@implementation BeginScene
{
    Person1Node  *_personNode;
    
    ShanaNode *_shana;
    KanaNode  *_kana;
    
    NPCNode1     *_learnSkillNPC;
    
    NPC2         *_shaNaNpc;
    NPC2         *_kanaNpc;
    NPC2         *_tempNPCNode;
    
    PassDoorNode *_passDoorNode;
    PassDoorNode *_learnPassive;
    
    CGPoint       _disAppearPoint;
    
    BOOL IS_NPC1;
    BOOL IS_SELECT_SCENE;
    BOOL IS_CHEST;
    BOOL IS_SELECT_PASSIVE;
    
    NSString *_selectName;
    
    SKPhysicsBody *_body;
    
    NSString     *_selectPersonName; //当前选中的角色
    NSString     *_changePersonName; //与选中猪脚对话的当前角色名字
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    _disAppearPoint = CGPointMake(1500, 300);
    self.sceneIndex = -1;
    
    [self createNPC1];
    //蝴蝶
    [AnimationButterFlyNode createNodeWithSuperNode:_learnSkillNPC maxX:0 maxY:0];
    
    
    [self createNPC2];
    [self createNPC3];
    [self createPassDoor];
    [self createLearnPassive];
    
    self.wallCount = 2;
    [self setWallPhy];
    
    
    [self createNextWallAndArrow];
    
    self.personNode.name = [[NSUserDefaults standardUserDefaults]objectForKey:kNameKey];
    [self createSceneAnimation];
    [self createCloudActionWithName:@"cloud4"];
    

}

- (void)createCloudActionWithName:(NSString *)name
{
    if (!self.personNode) {
        return;
    }
    
    BaseNode *cloud = [BaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:name]]];
    CGFloat y = 750 - 100;
    CGFloat x = 0;
    cloud.zPosition = -1;
    cloud.position = CGPointMake(x, y);
    SKAction *moveAction = [SKAction moveTo:CGPointMake(self.textureManager.WD_MAX_WIDTH + cloud.frame.size.width, y) duration:500];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[moveAction,removeAction]];
    __weak typeof(self)weakSelf = self;
    [cloud runAction:seq completion:^{
        if (arc4random() % 2 == 0) {
            [weakSelf createCloudActionWithName:@"cloud4"];
        }else{
            [weakSelf createCloudActionWithName:@"cloud3"];
        }
    }];
    [self.bgNode addChild:cloud];
}

- (void)moveActionWithDirection:(NSString *)direction position:(CGPoint)point
{
    BOOL isNotMove = [self.personNode moveAction:direction point:point];
    if (isNotMove) {
        return;
    }
}


#pragma mark 猪脚相关<猪脚的一些操作响应>
- (void)createPersonNode1
{
    _personNode = [[Person1Node alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"person1_run_1"]]];
    _personNode.xScale = 2;
    _personNode.yScale = 2;
    _personNode.zPosition = 650 - _disAppearPoint.y;
    [self.bgNode addChild:_personNode];
    
    [_personNode initActionWithModel:self.textureManager.personModel];
    
    self.personNode = _personNode;
    [_personNode stayAction];
    [self setEndSkill];
    _personNode.position = _disAppearPoint;
    
    PersonManager *personManager = [PersonManager sharePersonManager];
    personManager.personNode = self.personNode;
}

- (void)createKana
{
    _kana = [[KanaNode alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"kana_stay_1"]]];
    _kana.xScale = 2.1;
    _kana.yScale = 2.1;
    _kana.zPosition = 650 - _disAppearPoint.y;
    _kana.alpha = 1;
    [self.bgNode addChild:_kana];
    
    [_kana initActionWithModel:self.textureManager.kanaModel];
    [_kana stayAction];
    _kana.position = _disAppearPoint;
    self.personNode = _kana;
    [self setEndSkill];
    _kana.name = @"kana";
    
    PersonManager *personManager = [PersonManager sharePersonManager];
    personManager.personNode = self.personNode;
}

- (void)createShanaNode
{
    
    _shana = [[ShanaNode alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"person2_stay_1"]]];
    _shana.xScale = 2;
    _shana.yScale = 2;
    _shana.zPosition = 650 - _disAppearPoint.y;
    _shana.alpha = 1;
    [self.bgNode addChild:_shana];
    
    [_shana initActionWithModel:self.textureManager.shanaModel];
    [_shana stayAction];
    _shana.name = @"shana";
    self.personNode = _shana;
    [self setEndSkill];
    _shana.position = _disAppearPoint;

    PersonManager *personManager = [PersonManager sharePersonManager];
    personManager.personNode = self.personNode;
}

- (void)setEndSkill
{
    __weak typeof(self)weakSelf = self;
    [self.personNode setEndSkillBlock:^{
        [weakSelf.personNode setPhy];
    }];
}


- (void)stopMoveActionWithDirection:(NSString *)direction
{
    //攻击状态，移动取消
    [self.personNode stayAction];
}


/** 选择关卡的门 */
- (void)createPassDoor
{
    _passDoorNode = [PassDoorNode spriteNodeWithTexture:self.textureManager.passDoorModel.animationArr[0]];
    _passDoorNode.position = CGPointMake(1400, 350);
    _passDoorNode.zPosition = 650 - _passDoorNode.position.y;
    _passDoorNode.xScale = 1.5;
    _passDoorNode.yScale = 1.5;
    [self.bgNode addChild:_passDoorNode];
    
    SKAction *rep = [SKAction repeatActionForever:[SKAction animateWithTextures:self.textureManager.passDoorModel.animationArr timePerFrame:0.1]];
    [_passDoorNode runAction:rep];
    [_passDoorNode initActionWithModel:nil];
}


/** 学习被动技能的门 */
- (void)createLearnPassive
{
    _learnPassive = [PassDoorNode spriteNodeWithTexture:self.textureManager.passDoorModel.animationArr[0]];
    _learnPassive.position = CGPointMake(1700, 350);
    _learnPassive.zPosition = 650 - _passDoorNode.position.y;
    _learnPassive.xScale = 1.5;
    _learnPassive.yScale = 1.5;
    [self.bgNode addChild:_learnPassive];
    
    SKAction *rep = [SKAction repeatActionForever:[SKAction animateWithTextures:self.textureManager.passDoorModel.animationArr timePerFrame:0.1]];
    [_learnPassive runAction:rep];
    [_learnPassive initActionWithModel:nil];
    _learnPassive.name = @"passive";
}

- (void)createNPC1
{
    _learnSkillNPC = [[NPCNode1 alloc] initWithTexture:self.textureManager.npc1Model.stayArr[0]];
    _learnSkillNPC.xScale = 1.4;
    _learnSkillNPC.yScale = 1.4;
    _learnSkillNPC.position = CGPointMake(1100, 400);
    _learnSkillNPC.zPosition = 650 - _learnSkillNPC.position.y;
    [self.bgNode addChild:_learnSkillNPC];
    
    [_learnSkillNPC initActionWithModel:self.textureManager.npc1Model];
    [_learnSkillNPC stayAction];
    
}

- (void)createNPC2
{
   
    SKTexture *texture = self.textureManager.shanaModel.stayArr[0];
    _shaNaNpc = [NPC2 spriteNodeWithTexture:texture];
    _shaNaNpc.position = CGPointMake(500, 350);
    _shaNaNpc.xScale = 2;
    _shaNaNpc.yScale = 2;
    _shaNaNpc.zPosition = 650 - _shaNaNpc.position.y;
    [_shaNaNpc initActionWithModel:self.textureManager.shanaModel];
    _shaNaNpc.name = @"shana";
    [self.bgNode addChild:_shaNaNpc];
    
    _shaNaNpc.index = 1;
    if ([[PersonManager sharePersonManager].name isEqualToString:@"shana"]) {
        [_shaNaNpc setPerson1Model:self.textureManager.personModel];
    }
}

- (void)createNPC3
{
    SKTexture *texture = self.textureManager.kanaModel.stayArr[0];
    _kanaNpc = [NPC2 spriteNodeWithTexture:texture];
    _kanaNpc.position = CGPointMake(850, 350);
    _kanaNpc.xScale = 2;
    _kanaNpc.yScale = 2;
    _kanaNpc.zPosition = 650 - _shaNaNpc.position.y;
    [_kanaNpc initActionWithModel:self.textureManager.kanaModel];
    [self.bgNode addChild:_kanaNpc];
    _kanaNpc.name = @"kana";
    [_kanaNpc setKanaModel:self.textureManager.kanaModel];
    
    _kanaNpc.index = 2;
    if ([[PersonManager sharePersonManager].name isEqualToString:@"kana"]) {
        [_kanaNpc setPerson1Model:self.textureManager.personModel];
        _kanaNpc.name = @"person";
    }
}



#pragma mark 碰撞检测
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [super didBeginContact:contact];
    
    BaseNode *nodeA = (BaseNode *)contact.bodyA.node;
    BaseNode *nodeB = (BaseNode *)contact.bodyB.node;
    

    NPC2 *npcNode = nil;
    if ([nodeB isKindOfClass:[NPC2 class]] && ![nodeA.name isEqualToString:@"kanaFire"]) {
        npcNode = (NPC2 *)nodeB;
    }else if([nodeA isKindOfClass:[NPC2 class]] && ![nodeB.name isEqualToString:@"kanaFire"]){
        npcNode = (NPC2 *)nodeA;
    }
    

    if ([nodeB.name isEqualToString:@"passDoor"]) {
        [[WDNotificationManager shareManager]postNotificationForAttackType:click];
        IS_SELECT_SCENE = YES;
        BaseNode *greenNode = (BaseNode *)[self.bgNode childNodeWithName:@"green"];
        if (!greenNode) {
            greenNode = [BaseNode spriteNodeWithTexture:self.textureManager.greenArr[0]];
            greenNode.position = CGPointMake(nodeB.position.x, nodeB.position.y + 100);
            greenNode.name = @"green";
            greenNode.zPosition = 10000;
            greenNode.alpha = 0.7;
            [self.bgNode addChild:greenNode];
            SKAction *action = [SKAction animateWithTextures:self.textureManager.greenArr timePerFrame:0.1];
            [greenNode runAction:[SKAction repeatActionForever:action]];
        }
       
        
    }
    
    if ([nodeB.name isEqualToString:@"passive"]) {
        [[WDNotificationManager shareManager]postNotificationForAttackType:click];
        IS_SELECT_PASSIVE = YES;
        BaseNode *greenNode = (BaseNode *)[self.bgNode childNodeWithName:@"blue"];
        if (!greenNode) {
            greenNode = [BaseNode spriteNodeWithTexture:self.textureManager.blueArr[0]];
            greenNode.position = CGPointMake(nodeB.position.x, nodeB.position.y + 35);
            greenNode.name = @"blue";
            greenNode.zPosition = 10000;
            greenNode.alpha = 0.0;
            [self.bgNode addChild:greenNode];
            SKAction *action = [SKAction animateWithTextures:self.textureManager.blueArr timePerFrame:0.2];
            SKAction *alphaAction = [SKAction fadeAlphaTo:0.6 duration:0.3];
            SKAction *gr = [SKAction group:@[alphaAction,[SKAction repeatActionForever:action]]];
            [greenNode runAction:gr];
        }
       
    }
    
    
    if ([nodeB.name isEqualToString:@"NPC1"]) {
        CGFloat xScale = fabs(_learnSkillNPC.xScale);
        if (nodeA.position.x < nodeB.position.x) {
            xScale = -1 * xScale;
        }else{
            xScale = xScale;
        }
        
        _learnSkillNPC.xScale = xScale;
        [_learnSkillNPC standAction];
        IS_NPC1 = YES;
        [[WDNotificationManager shareManager]postNotificationForAttackType:talk];

    }
    
    
    //触碰选择人物的npc
    if (npcNode) {
        _tempNPCNode = npcNode;
        [npcNode standAction];
        
        if ([npcNode.name isEqualToString:@"shana"]) {
            _selectName = @"shana";
        }else if([npcNode.name isEqualToString:@"kana"]){
            _selectName = @"kana";
        }else if([npcNode.name isEqualToString:@"person"]){
            _selectName = @"person";
        }
        
        [[WDNotificationManager shareManager]postNotificationForAttackType:talk];

        
    }else{
        _tempNPCNode = nil;
    }
    
    
    if ([nodeB.name isEqualToString:@"chest"]) {
        IS_CHEST = YES;
        [self.notificationManager postNotificationForAttackType:click];
    }
    
   
    
    NSLog(@"A: %@  B: %@",nodeA.name,nodeB.name);
}


- (void)didEndContact:(SKPhysicsContact *)contact
{
    [super didEndContact:contact];
    BaseNode *nodeA = (BaseNode *)contact.bodyA.node;
    BaseNode *nodeB = (BaseNode *)contact.bodyB.node;
    
    if ([nodeB.name isEqualToString:@"NPC1"]||[nodeA.name isEqualToString:@"NPC1"]) {
        [_learnSkillNPC stayAction];
        IS_NPC1 = NO;
    }
    
    if ([nodeB.name isEqualToString:@"passDoor"] || [nodeA.name isEqualToString:@"passDoor"]) {
        IS_SELECT_SCENE = NO;
        BaseNode *greenNode = (BaseNode *)[self.bgNode childNodeWithName:@"green"];
        SKAction *remo = [SKAction removeFromParent];
        SKAction *fade = [SKAction fadeAlphaTo:0 duration:0.3];
        [greenNode runAction:[SKAction sequence:@[fade,remo]]];
        
        BaseNode *blueNode = (BaseNode *)[self.bgNode childNodeWithName:@"blue"];
        [blueNode runAction:[SKAction sequence:@[fade,remo]]];
    }
    
    if ([nodeB.name isEqualToString:@"passive"] || [nodeA.name isEqualToString:@"passive"]) {
        IS_SELECT_PASSIVE = NO;
        BaseNode *blueNode = (BaseNode *)[self.bgNode childNodeWithName:@"blue"];
        SKAction *remo = [SKAction removeFromParent];
        SKAction *fade = [SKAction fadeAlphaTo:0 duration:0.3];
        [blueNode runAction:[SKAction sequence:@[fade,remo]]];
    }
    
    if ([nodeB.name isEqualToString:@"chest"] || [nodeA.name isEqualToString:@"chest"]) {
        IS_CHEST = NO;
    }
  
    
    [_tempNPCNode stayAction];
    _tempNPCNode = nil;
    [self.notificationManager postNotificationForAttackType:attack];
    _changePersonName = nil;
}



#pragma mark 选择角色按键
- (void)attackAction:(NSString *)direction
{
    
    if (IS_CHEST) {
        [self.chestNode setRandomBuff];
        [self.notificationManager postNotificationForAttackType:attack];
        IS_CHEST = NO;
        return;
    }
    

    if (IS_NPC1) {
        
        if (self.learnBaseBlock) {
            self.learnBaseBlock();
        }
        
        return;
    }
    
    
    if (IS_SELECT_SCENE) {
        if (self.selectMapBlock) {
            self.selectMapBlock();
        }
        return;
    }
    
    if (IS_SELECT_PASSIVE) {
        NSLog(@"选择被动技能");
        if (self.selectPassiveBlock) {
            self.selectPassiveBlock();
        }
    }
    
    if (_tempNPCNode) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       
        
        _disAppearPoint = self.personNode.position;
        NSString *nowName = self.personNode.name;
        NSString *selectName = _tempNPCNode.name;
        
        [self.personNode clearAction];
        [self.personNode removeFromParent];
        
        if ([nowName isEqualToString:@"person"]) {

            [_personNode clearAction];
            [_personNode removeFromParent];
            [_tempNPCNode setPerson1Model:self.textureManager.personModel];
            
        }else if([nowName isEqualToString:@"kana"]){
            
            [_kana clearAction];
            [_kana removeFromParent];
            [_tempNPCNode setKanaModel:self.textureManager.kanaModel];
            
        }else if([nowName isEqualToString:@"shana"]){
            
            [_shana clearAction];
            [_shana removeFromParent];
            [_tempNPCNode setShanaModel:self.textureManager.shanaModel];
            
        }
        
    
        if ([selectName isEqualToString:@"person"]) {
            [self createPersonNode1];
        }else if([selectName isEqualToString:@"shana"]){
            [self createShanaNode];
        }else if([selectName isEqualToString:@"kana"]){
            [self createKana];
        }
        
        [defaults setObject:selectName forKey:kNameKey];
        [PersonManager sharePersonManager].name = selectName;
        [[WDNotificationManager shareManager]postNotificationForChangePerson];
        _tempNPCNode = nil;
    }
    
    //加试炼攻击
    [self.personNode.delegate attackAction];
}

- (void)skillActionWithType:(NSInteger)type
{
    [self.notificationManager postNotificationForAttackType:attack];
    [_learnSkillNPC stayAction];
    IS_NPC1 = NO;
    IS_CHEST = NO;
    _tempNPCNode = nil;
    [_shaNaNpc stayAction];
    
    _changePersonName = nil;
    [self.personNode skillAction:type];
}

- (void)clearAction
{
    [super clearAction];    
}

- (void)dealloc
{
    [self.notificationManager postNotificationForAttackType:attack];
    NSLog(@"启程释放了1");
}

@end
