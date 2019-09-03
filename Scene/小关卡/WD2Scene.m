//
//  FiveScene.m
//  begin
//
//  Created by Mac on 2018/12/12.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WD2Scene.h"

@implementation WD2Scene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"wdSecondScene.jpg"]];
    
    self.sceneDelegate = self;
    
    
    self.wallCount = 1;
    [self setWallPhy];
    
    [self createSceneAnimation];
    
    [self performSelector:@selector(createMonsterNode) withObject:nil afterDelay:2];
    self.nextSceneNum = 10 + arc4random() % 3;
    self.sceneIndex = 1;

}

- (void)createMonsterNode
{
    for (int i = 0; i < 4; i ++) {
        [self createThiefMonster];
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
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 2) {
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kSceneIndex];
            if (self.unlockSkillBlock) {
                self.unlockSkillBlock(2);
            }
            [self performSelector:@selector(createNextWallAndArrow) withObject:nil afterDelay:1.5];
        }else{
            [self createNextWallAndArrow];
        }
        
    }else{
        [self createThiefMonster];
    }
    
}


@end
