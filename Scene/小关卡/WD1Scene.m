//
//  FourScene.m
//  begin
//
//  Created by Mac on 2018/12/12.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WD1Scene.h"
#import "ThiefMonster.h"
@implementation WD1Scene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"wdFirstScene.jpg"]];
    self.sceneDelegate = self;
   
    self.wallCount = 1;
    [self setWallPhy];
    
    [self createSceneAnimation];
    [self performSelector:@selector(createMonsterNode) withObject:nil afterDelay:2];
    self.nextSceneNum = 20 + arc4random() % 10;
    self.sceneIndex = 0;
}

- (void)createMonsterNode
{
    for (int i = 0; i < 5; i ++) {
        [self createShooterMonster];
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
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 1) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSceneIndex];
            if (self.unlockSkillBlock) {
                self.unlockSkillBlock(1);
            }
            [self performSelector:@selector(createNextWallAndArrow) withObject:nil afterDelay:1.5];
        }else{
            [self createNextWallAndArrow];
        }
        
    }else{
        [self createShooterMonster];
    }
    

}


@end
