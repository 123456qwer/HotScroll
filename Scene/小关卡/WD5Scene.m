//
//  WDFifthScene.m
//  begin
//
//  Created by Mac on 2019/1/10.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "WD5Scene.h"

@implementation WD5Scene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"wdFifthScene.jpg"]];
    
    self.sceneDelegate = self;
    
    
    self.wallCount = 1;
    [self setWallPhy];
    
    [self createSceneAnimation];
    
    [self performSelector:@selector(createMonsterNode) withObject:nil afterDelay:2];
    self.sceneIndex = 5;
    self.nextSceneNum = 10 + arc4random() % 3;
}

- (void)createMonsterNode
{
    for (int i = 0; i < 4; i ++) {
        [self createSniperMonster];
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
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 6) {
            [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:kSceneIndex];
            [self performSelector:@selector(createNextWallAndArrow) withObject:nil afterDelay:1.5];
        }else{
            [self createNextWallAndArrow];
        }
        
    }else{
        [self createSniperMonster];
    }
    

    
}



@end
