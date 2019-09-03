//
//  SecondScene.m
//  HotSchool
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "Boss2Scene.h"
#import "BaseScene+CreateMonster.h"
@implementation Boss2Scene
{
    KanaNode    *_kanaNode;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.sceneDelegate = self;
    
    self.wallCount = 3;
    [self setWallPhy];
   
    self.kanaModel = self.textureManager.kanaModel;

    [self createSceneAnimation];
    
    [self performSelector:@selector(createMonster) withObject:nil afterDelay:2.0];
    self.nextSceneNum = 15 + arc4random() % 10;
    self.sceneIndex = 9;

}

- (void)createMonster
{
    for (int i = 0; i < 5; i ++) {
        [self createRandomMonster:8];
    }
}

#pragma mark 怪物被消灭并从场景中删除
- (void)removeMonsterWithName:(NSString *)name
{
    BaseNode *shooterNode = self.monsterDic[name];
    [WDActionTool dropMoneyAnimation:self.bgNode position:shooterNode.position gold:1];
    [self.monsterDic removeObjectForKey:name];
    
    self.killMonsterNum ++;
    
    //消灭怪物刷出第二关BOSS <✨✨✨✨✨✨!火焰kana!✨✨✨✨✨✨>
    if (self.killMonsterNum >= self.nextSceneNum) {
        [self createKanaBoss];
    }else{
        [self createRandomMonster:8];
    }
    
}

- (void)createKanaBoss
{
    if (_kanaNode) {
        return;
    }
    _kanaNode = [KanaNode spriteNodeWithTexture:self.kanaModel.moveArr[0]];
    _kanaNode.position = CGPointMake(1280, 300);
    _kanaNode.xScale = 2;
    _kanaNode.yScale = 2;
    _kanaNode.zPosition = 100;
    _kanaNode.alpha = 0;
    [self.bgNode addChild:_kanaNode];
    [_kanaNode initActionWithModel:self.kanaModel];
    [_kanaNode stayAction];
    
    
    BaseNode *node = [BaseNode spriteNodeWithTexture:self.textureManager.lightArr[0]];
    
    node.position = _kanaNode.position;
    node.zPosition = 10000;
    node.name = @"light";
    [self.bgNode addChild:node];
    SKAction *lightA = [SKAction animateWithTextures:self.textureManager.lightArr timePerFrame:0.1];
    SKAction *r = [SKAction removeFromParent];
    SKAction *s = [SKAction sequence:@[lightA,r]];
    [node runAction:s completion:^{
        
    }];
    
    SKAction *alphaA = [SKAction fadeAlphaBy:1 duration:self.textureManager.lightArr.count * 0.1];
    __weak typeof(self)weakSelf = self;
    [_kanaNode runAction:alphaA completion:^{
        [weakSelf kanaBeginMove];
    }];
    
    [_kanaNode setEndSkillBlock:^{
        
    }];
    
    [_kanaNode setDeadBlock:^(NSString *name) {
        NSLog(@"卡娜阵亡");
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 10) {
            [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:kSceneIndex];
        }

        [weakSelf createNextWallAndArrow];
    }];

    
    [self.personNode.delegate setBossMonster:_kanaNode];
}

- (void)kanaBeginMove
{
    [_kanaNode setPersonNode:self.personNode];
}

- (BOOL)normalAttack
{
    if([super normalAttack]){
        return YES;
    }else{
        return NO;
    }
    
}


#pragma mark 碰撞代理方法
//开始发生碰撞
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [super didBeginContact:contact];
    BaseNode *nodeA = (BaseNode *)contact.bodyA.node;
    BaseNode *nodeB = (BaseNode *)contact.bodyB.node;
    
    if ([nodeA.name isEqualToString:@"person"] && [nodeB.name isEqualToString:@"kanaMonsterFire"]) {
        BOOL direction = [WDCalculateTool personIsLeft:nodeA.position monsterPoint:nodeB.position];
        [self.personNode.delegate beAttackAction:direction attackCount:10];
    }
    
    
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    [super didEndContact:contact];
}

- (void)clearAction
{
    [super clearAction];
}

- (void)dealloc
{
    NSLog(@"BOSS场景2释放了✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨");
}


@end
