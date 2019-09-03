//
//  WD12Scene.m
//  begin
//
//  Created by Mac on 2019/5/15.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "WD12Scene.h"

@implementation WD12Scene
- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"WD12Scene.jpg"]];
    
    self.sceneDelegate = self;
    
    self.wallCount = 1;
    [self setWallPhy];
    
    [self createSceneAnimation];
    
    [self performSelector:@selector(createMonsterNode) withObject:nil afterDelay:2];
    self.nextSceneNum = 25;
    self.sceneIndex = 12;
    
}

- (void)createMonsterNode
{
    for (int i = 0; i < 4; i ++) {
        [self createSpear2Monster];
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
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 14) {
            [[NSUserDefaults standardUserDefaults] setInteger:14 forKey:kSceneIndex];
            [self performSelector:@selector(createNextWallAndArrow) withObject:nil afterDelay:1.5];
        }else{
            [self createNextWallAndArrow];
        }
        
    }else{
        [self createSpear2Monster];
    }
    
    
    
}

@end
