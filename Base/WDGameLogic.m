//
//  WDGameLogic.m
//  begin
//
//  Created by Mac on 2018/12/28.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDGameLogic.h"
@implementation WDGameLogic

#pragma mark 碰撞检测
+ (void)beginContact:(SKPhysicsContact *)contact
{
    BaseNode *nodeA = (BaseNode *)contact.bodyA.node;
    BaseNode *nodeB = (BaseNode *)contact.bodyB.node;
    
    
    BaseNode *personNode = nil;
    BaseNode *otherNode  = nil;
    
    if ([nodeA.name isEqualToString:@"person"] || [nodeA.name isEqualToString:@"shana"] || [nodeA.name isEqualToString:@"kana"]) {
        personNode = nodeA;
        otherNode = nodeB;
    }else if([nodeB.name isEqualToString:@"person"] || [nodeB.name isEqualToString:@"shana"] || [nodeB.name isEqualToString:@"kana"]){
        personNode = nodeB;
        otherNode = nodeA;
    }
    
    //箭矢射中人物的碰撞检测
    if ([personNode.name isEqualToString:@"person"] && [otherNode.name isEqualToString:@"arrow"]) {
        [WDGameLogic arrowWithPerson:personNode arrowNode:otherNode];
    }
    
    
    //技能攻击到弓箭手碰撞检测<可能有多个shooter>
    NSString *shooter = @"shooter";
    if (otherNode.name.length > shooter.length) {
        NSString *nameStr = [otherNode.name substringWithRange:NSMakeRange(0, shooter.length)];
        if ([nameStr isEqualToString:shooter] && personNode) {
            [WDGameLogic shooterWithPerson:personNode shooterNode:(ShooterMonster *)otherNode];
        }
    }

    
    //技能攻击射手
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"bowb"]) {
        [WDGameLogic monsterBeSkillAttack:personNode monsterNode:otherNode];;
    }
    
    //spea
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"spea"]) {
        [WDGameLogic monsterBeSkillAttack:personNode monsterNode:otherNode];;
    }
    
    //boss
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"boss"]) {
        [WDGameLogic monsterBeSkillAttack:personNode monsterNode:otherNode];;
    }
    
    //技能攻击到盗贼
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"thie"]) {
        [WDGameLogic thiefWithPerson:personNode thiefNode:(ThiefMonster *)otherNode];
    }
    
    //技能攻击到大刀兵
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"blad"]) {
        [WDGameLogic bladeWithPerson:personNode shooterNode:(BigBladeMonster *)otherNode];
    }
    
    //技能攻击到巫师
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"wiza"]) {
        [WDGameLogic wizardWithPerson:personNode wizardNode:(WizardMonster *)otherNode];
    }
    
    //技能攻击到陨石法师
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"magi"]) {
        [WDGameLogic magicWithPerson:personNode magicNode:(MagicMonster *)otherNode];
    }
    
    //技能攻击到阻击手
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"snip"]) {
        [WDGameLogic sniperWithPerson:personNode sniperNode:otherNode];
    }
    
    //闪电技能击中玩家
    if ([otherNode.name isEqualToString:@"flash"]) {
        [WDGameLogic flashWithPerson:personNode flashNode:otherNode];
    }
    
    //技能击中野蛮人
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"sava"]) {
        [WDGameLogic savageWithPerson:personNode savageNode:otherNode];
    }
    
    //技能击中天使
    if ([[otherNode.name substringWithRange:NSMakeRange(0, 4)]isEqualToString:@"ange"]) {
        [WDGameLogic angelWithPerson:personNode angelNode:otherNode];
    }
    
    //玩家被陨石击中
    if ([otherNode.name isEqualToString:@"meteorite1"]) {
        [WDGameLogic meteoritePerson:personNode meteoriteNode:otherNode];
    }
    
    //被激光击中
    if ([otherNode.name isEqualToString:@"laser"]) {
        [WDGameLogic laserWithPerson:personNode laserNode:otherNode];
    }
    
    //夏娜碰到玩家的碰撞检测
    if ([otherNode.name isEqualToString:@"shanaMonster"] && personNode) {
        [WDGameLogic shanaWithPerson:personNode shanaNode:(ShanaMonster *)otherNode];
    }
    
    //碰撞到屏幕俩侧的树
    if ([otherNode.name isEqualToString:@"tree"]) {
        //[nodeB runAction:[SKAction fadeAlphaTo:0.7 duration:0.2]];
    }
    
    //增益效果
    if ([otherNode.name isEqualToString:@"喷射火焰剑"]) {
        [WDGameLogic fireBladeWithPerson:personNode bladeNode:otherNode];
    }
    
    
    
    //火焰剑攻击
    if ([nodeB.name isEqualToString:@"火焰剑攻击"] && ![nodeA.name isEqualToString:@"person"] && ![nodeA.name isEqualToString:@"kana"] && ![nodeA.name isEqualToString:@"shana"]) {
        //NSLog(@"火焰剑攻击触发碰撞了！");
        if ([nodeA isKindOfClass:[BaseNode class]]) {
            if ([nodeA.delegate respondsToSelector:@selector(beAttackAction:attackCount:)]) {
                [nodeA.delegate beAttackAction:[WDCalculateTool personIsLeft:nodeB.position monsterPoint:nodeA.position] attackCount:10.f];
            }
        }
    }
    
    if ([nodeB.name isEqualToString:@"kanaFire"] && ![nodeA.name isEqualToString:@"person"] && ![nodeA.name isEqualToString:@"kana"] && ![nodeA.name isEqualToString:@"shana"]) {
        if ([nodeA isKindOfClass:[BaseNode class]]) {
            if ([nodeA.delegate respondsToSelector:@selector(beAttackAction:attackCount:)]) {
                CGFloat attackCount = [[nodeB.userData objectForKey:@"attack"]floatValue];
                [nodeA.delegate beAttackAction:[WDCalculateTool personIsLeft:nodeB.position monsterPoint:nodeA.position] attackCount:attackCount];
            }
        }
    }
    
    //拾取金币
    if ([otherNode.name isEqualToString:@"money"] && personNode) {
        [WDGameLogic takeMoneyWithPerson:personNode moneyNode:otherNode];
    }
    
    //卡娜技能攻击
    if ([otherNode.name isEqualToString:@"kanaMonster"] && personNode) {
        [WDGameLogic beAttackWithKana:otherNode person:personNode];
    }
    
    //中了风攻击，设置方向反向操作
    if ([otherNode.name isEqualToString:@"wind"] && personNode) {
        [self oppositeAction:personNode];
        personNode.oppositeDebuff = YES;
    }
  
}








#pragma mark 具体碰撞的逻辑实现
+ (void)oppositeAction:(BaseNode *)personNode
{
    if (personNode.oppositeDebuff) {
        return;
    }
    NSLog(@"%lf",personNode.imageHeight);
    [WDActionTool debuffForQuestion:personNode textures:personNode.model.questionArr position:CGPointMake(0, personNode.imageHeight / 2.0)];
}


#pragma mark ----卡娜技能击中玩家----
+ (void)beAttackWithKana:(BaseNode *)kanaNode
                   person:(BaseNode *)personNode
{
    
    if (personNode.isSkillAttackIng) {
        [self monsterBeSkillAttack:personNode monsterNode:kanaNode];
    }else if (kanaNode.isSkillAttackIng) {
        int demageCount = arc4random() % 10 + 10;
        [personNode.delegate beAttackAction:[WDCalculateTool personIsLeft:personNode.position monsterPoint:kanaNode.position] attackCount:demageCount];
    }
    
    
}

#pragma mark ----掉落金币逻辑----
+ (void)takeMoneyWithPerson:(BaseNode *)personNode
                  moneyNode:(BaseNode *)moneyNode
{
    WDSceneManager *sManager = [WDSceneManager shareSeting];
    
    sManager.moneyX = moneyNode.position.x - fabs(sManager.xMove);
    sManager.moneyY = moneyNode.position.y;
 
    WDNotificationManager *manager = [WDNotificationManager shareManager];
    [manager postNotificationForGoldFly];
    
    [moneyNode removeAllChildren];
    [moneyNode removeFromParent];
}

#pragma mark ----技能击中野蛮人----
+ (void)savageWithPerson:(BaseNode *)personNode
              savageNode:(BaseNode *)savageNode
{
    [self monsterBeSkillAttack:personNode monsterNode:savageNode];
}

#pragma mark ----技能击中天使----
+ (void)angelWithPerson:(BaseNode *)personNode
              angelNode:(BaseNode *)angelNode
{
    [self monsterBeSkillAttack:personNode monsterNode:angelNode];
}

#pragma mark ----被阻击手击中----
+ (void)laserWithPerson:(BaseNode *)personNode
              laserNode:(BaseNode *)laserNode
{
    [laserNode removeAllActions];
    SniperModel *model = (SniperModel *)laserNode.model;
    SKAction *a1 = [SKAction animateWithTextures:model.blastArr timePerFrame:0.1];
    SKAction *re = [SKAction removeFromParent];
    [laserNode runAction:[SKAction sequence:@[a1,re]]];
    
    
    
    if ([personNode.delegate respondsToSelector:@selector(downAction:attackCount:)]) {
        [personNode.delegate downAction:[WDCalculateTool personIsLeft:personNode.position monsterPoint:laserNode.position] attackCount:personNode.wdBlood / 2.0];
        //[personNode.delegate downAction:[WDCalculateTool personIsLeft:personNode.position monsterPoint:laserNode.position] attackCount:0];
    }
    
}

#pragma mark ----技能击中阻击手----
+ (void)sniperWithPerson:(BaseNode *)personNode
              sniperNode:(BaseNode *)sniperNode
{
    [self monsterBeSkillAttack:personNode monsterNode:sniperNode];
}


#pragma mark ----火球击中玩家----
+ (void)meteoritePerson:(BaseNode *)personNode
              meteoriteNode:(BaseNode *)meteoriteNode
{
    [personNode.delegate beAttackAction:[WDCalculateTool personIsLeft:personNode.position monsterPoint:meteoriteNode.position] attackCount:personNode.wdBlood / 10.0];
}

#pragma mark ----技能击中火球法师----
+ (void)magicWithPerson:(BaseNode *)personNode
              magicNode:(MagicMonster *)magicMonster
{
    [self monsterBeSkillAttack:personNode monsterNode:magicMonster];
}

#pragma mark ----技能击中闪电法师----
+ (void)wizardWithPerson:(BaseNode *)personNode
              wizardNode:(WizardMonster *)wizardMonster
{
    if (personNode.isSkillAttackIng && !personNode.isAttackIng){
        //卡娜无视技能免疫<卡娜本来就够强了！！！，改为夏娜>
        if ([[PersonManager sharePersonManager].name isEqualToString:@"shana"]) {
            [self monsterBeSkillAttack:personNode monsterNode:wizardMonster];
        }else{
            [WDActionTool missAnimation:wizardMonster];
        }
    }
}

#pragma mark ----技能击中盗贼----
+ (void)thiefWithPerson:(BaseNode *)personNode
              thiefNode:(ThiefMonster *)thiefMonster
{
    if (personNode.isSkillAttackIng && !personNode.isDefense && !personNode.isAttackIng){
        //%60闪避技能
        if (arc4random() % 100 <= 60) {
            [WDActionTool missAnimation:thiefMonster];
        }else{
            [self monsterBeSkillAttack:personNode monsterNode:thiefMonster];
        }
    }
}

#pragma mark ----技能击中射手----
+ (void)bladeWithPerson:(BaseNode *)personNode
              shooterNode:(BigBladeMonster *)bladeMonster
{
    [self monsterBeSkillAttack:personNode monsterNode:bladeMonster];
}

#pragma mark ----技能击中射手----
+ (void)shooterWithPerson:(BaseNode *)personNode
              shooterNode:(ShooterMonster *)shooterMonster
{
    [self monsterBeSkillAttack:personNode monsterNode:shooterMonster];
}

#pragma mark ----箭射中玩家----
+ (void)arrowWithPerson:(BaseNode *)personNode arrowNode:(BaseNode *)arrowNode
{
    arrowNode.isContact = YES;
    [arrowNode removeAllActions];
    BOOL isFrontToArrow = YES;
    
    CGFloat distance = arrowNode.position.x - personNode.position.x;
    if (distance > 0) {
        //箭矢在右边的情况,如果人物背向箭矢，则在攻击状态也无法防御
        if (personNode.xScale > 0) {
            isFrontToArrow = YES;
        }else{
            isFrontToArrow = NO;
        }
        
    }else{
        if (personNode.xScale > 0) {
            isFrontToArrow = NO;
        }else{
            isFrontToArrow = YES;
        }
    }
    
    
    //攻击状态切面向箭矢或者释放技能状态，都可以把箭矢撞飞
    if ((personNode.isAttackIng && isFrontToArrow) || personNode.isSkillAttackIng) {
        [arrowNode setPhySicsBodyNone];
        [WDActionTool arrowAnimation:arrowNode];
        
    }else{
        if (arrowNode.position.x > personNode.position.x) {
            [personNode.delegate beAttackAction:NO attackCount:arrowNode.wdAttack];
        }else{
            [personNode.delegate beAttackAction:YES attackCount:arrowNode.wdAttack];
        }
        
        [arrowNode removeFromParent];
    }
}

#pragma mark ----闪电打中玩家----
+ (void)flashWithPerson:(BaseNode *)personNode
              flashNode:(BaseNode *)flashNode
{
    if (personNode.position.x > flashNode.position.x) {
        [personNode.delegate beAttackAction:YES attackCount:personNode.wdBlood / 8.0];
    }else{
        [personNode.delegate beAttackAction:NO attackCount:personNode.wdBlood / 8.0];
    }
}

+ (void)shanaWithPerson:(BaseNode *)personNode
              shanaNode:(ShanaMonster *)shanaNode
{
    if (personNode.isSkillAttackIng && !personNode.isDefense) {
        if (shanaNode.isSkillAttackIng) {
            return;
        }
        CGFloat distanceX = personNode.position.x - shanaNode.position.x;
        
        BOOL isLeft = NO;
        if (distanceX < 0) {
            isLeft = YES;
        }
        CGFloat attackNumber = personNode.wdAttack;
        NSArray *arr = @[@(arc4random() % 5 + 50),@(arc4random() % 5 + 80),@(arc4random() % 5 + 80),@(arc4random() % 5 + 30)];
        CGFloat fudongNumber = [arr[personNode.skillType]integerValue] + attackNumber;
        [shanaNode beSkillAttackAction:isLeft attackCount:fudongNumber];
        
    }else if(shanaNode.isSkillAttackIng){
        
        ShanaMonster *monster = (ShanaMonster *)shanaNode;
        [monster attackSkillAction];;
        
    }else{
        ShanaMonster *monster = (ShanaMonster *)shanaNode;
        NSInteger type = arc4random() % 4;
        [monster attackActionWithType:type];
    }
}



#pragma mark ----通用被技能击中方法----
+ (void)monsterBeSkillAttack:(BaseNode *)personNode
                 monsterNode:(BaseNode *)monsterNode
{
    if (personNode.isSkillAttackIng) {
        CGFloat attackNumber = personNode.wdAttack;
        NSArray *arr = @[@(arc4random() % 20 + 50),@(arc4random() % 20 + 80),@(arc4random() % 20 + 80),@(arc4random() % 20 + 30)];
        CGFloat fudongNumber = [arr[personNode.skillType]integerValue] + attackNumber;
        
        //如果是BOSS3，闪避暂时失效
        if ([monsterNode isKindOfClass:[Boss3Monster class]]) {
            Boss3Monster *monster = (Boss3Monster *)monsterNode;
            monster.canMiss = NO;
        }
        
        [monsterNode.delegate beAttackAction:[WDCalculateTool personIsLeft:personNode.position monsterPoint:monsterNode.position] attackCount:fudongNumber];
        [WDActionTool reduceBloodLabelAnimation:monsterNode reduceCount:fudongNumber isSkill:YES];
    }
}

#pragma mark ----增益效果----
#pragma mark ----喷射火焰剑----
+ (void)fireBladeWithPerson:(BaseNode *)personNode
                  bladeNode:(BaseNode *)bladeNode
{
    SKAction *alphaA = [SKAction fadeAlphaTo:0 duration:0.5];
    SKAction *scale = [SKAction scaleTo:0 duration:0.5];
    SKAction *gr = [SKAction group:@[alphaA,scale]];
    SKAction *seq = [SKAction sequence:@[gr,[SKAction removeFromParent]]];
    
    [bladeNode runAction:seq completion:^{
        NSLog(@"火焰剑增益buff获取");
        SKEmitterNode *eNode = [SKEmitterNode nodeWithFileNamed:@"Fire"];
        eNode.position = personNode.position;
        eNode.name = @"火焰剑攻击";
        eNode.zPosition = 10;
        SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:5.f];
        body.contactTestBitMask = 0;
        body.categoryBitMask = 0;
        body.collisionBitMask = 0;
        body.affectedByGravity = NO;
        eNode.physicsBody = body;
        [personNode.parent addChild:eNode];
        PersonManager *manager = [PersonManager sharePersonManager];
        if ([manager.name isEqualToString:@"kana"]) {
            manager.passive_fireBlade = NO;
        }else{
            manager.passive_fireBlade = YES;
        }
    }];
    
}

@end
