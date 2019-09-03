//
//  SixScene.m
//  begin
//
//  Created by Mac on 2018/12/12.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WD3Scene.h"

@implementation WD3Scene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"wdThirdScene.jpg"]];
    
    self.sceneDelegate = self;
    
    
    self.wallCount = 1;
    [self setWallPhy];
    [self createSceneAnimation];
    [self performSelector:@selector(createMonsterNode) withObject:nil afterDelay:2];
    self.nextSceneNum = 9 + arc4random() % 3;
    self.sceneIndex = 2;

    
}

- (void)createMonsterNode
{
    for (int i = 0; i < 3; i ++) {
        [self createWizardMonster];
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
    if (self.killNum > self.nextSceneNum){
        if (self.monsterDic.count > 0) {
            return;
        }
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 3) {
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:kSceneIndex];
            if (self.unlockSkillBlock) {
                self.unlockSkillBlock(3);
            }
            [self performSelector:@selector(createNextWallAndArrow) withObject:nil afterDelay:1.5];
        }else{
            [self createNextWallAndArrow];
        }
      
    }else{
        [self createWizardMonster];
    }
    
    
}

@end
