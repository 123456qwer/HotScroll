//
//  WDEightScene.m
//  begin
//
//  Created by Mac on 2019/2/1.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "WD8Scene.h"

@implementation WD8Scene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"wdEightScene.jpg"]];
    
    self.sceneDelegate = self;
    
    
    self.wallCount = 1;
    [self setWallPhy];
    
    [self createSceneAnimation];
    
    [self performSelector:@selector(createMonsterNode) withObject:nil afterDelay:2];
    self.nextSceneNum = 20 + arc4random() % 5;
    self.sceneIndex = 8;

}



- (void)createMonsterNode
{
    for (int i = 0; i < 5; i ++) {
        [self createBigBladeMonster];
    }
}

#pragma mark 怪物被消灭并从场景中删除
- (void)removeMonsterWithName:(NSString *)name
{
    BaseNode *shooterNode = self.monsterDic[name];
    
    WDSceneManager *manager = [WDSceneManager shareSeting];
    [manager deadSceneAnimation:shooterNode bgNode:self.bgNode];
    
    [WDActionTool dropMoneyAnimation:self.bgNode position:shooterNode.position gold:1];
    [self.monsterDic removeObjectForKey:name];

    self.killNum ++;
    if (self.killNum > self.nextSceneNum) {
        if (self.monsterDic.count > 0) {
            return;
        }
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 9) {
            [[NSUserDefaults standardUserDefaults] setInteger:9 forKey:kSceneIndex];
            [self performSelector:@selector(createNextWallAndArrow) withObject:nil afterDelay:1.5];
        }else{
            [self createNextWallAndArrow];
        }
        
    }else{
        [self createBigBladeMonster];
    }

}

- (BOOL)normalAttack
{
    if([super normalAttack]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 碰撞检测
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [super didBeginContact:contact];
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    [super didEndContact:contact];
}

@end
