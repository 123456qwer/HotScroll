//
//  WDNinthScene.m
//  begin
//
//  Created by Mac on 2019/4/29.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "WD9Scene.h"

@implementation WD9Scene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"wdNinthScene.jpg"]];
    
    self.sceneDelegate = self;
    
    self.wallCount = 1;
    [self setWallPhy];
    
    [self createSceneAnimation];
    
    [self performSelector:@selector(createMonsterNode) withObject:nil afterDelay:2];
    self.nextSceneNum = 25;
    self.sceneIndex = 9;
    
}

- (void)createMonsterNode
{
    for (int i = 0; i < 5; i ++) {
        [self createBowMonster];
    }
}

#pragma mark 怪物被消灭并从场景中删除
- (void)removeMonsterWithName:(NSString *)name
{
    BaseNode *shooterNode = self.monsterDic[name];
    
    WDSceneManager *manager = [WDSceneManager shareSeting];
    [manager deadSceneAnimation:shooterNode bgNode:self.bgNode];
    [self.monsterDic removeObjectForKey:name];

    [WDActionTool dropMoneyAnimation:self.bgNode position:shooterNode.position gold:1];
    
    self.killNum ++;
    if (self.killNum > self.nextSceneNum) {
        if (self.monsterDic.count > 0) {
            return;
        }
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 11) {
            [[NSUserDefaults standardUserDefaults] setInteger:11 forKey:kSceneIndex];
            [self performSelector:@selector(createNextWallAndArrow) withObject:nil afterDelay:1.5];
        }else{
            [self createNextWallAndArrow];
        }
        
    }else{
        [self createBowMonster];
    }
    

    
}



@end
