//
//  ThirdScene.m
//  begin
//
//  Created by Mac on 2018/11/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "Boss3Scene.h"


@implementation Boss3Scene
{
    CannonMonster *_monster;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    
    self.sceneDelegate = self;

    self.wallCount = 3;
    [self setWallPhy];
    
    [self createSceneAnimation];
    self.nextSceneNum = 25 + arc4random() % 10;
    self.sceneIndex = 13;
    [self performSelector:@selector(createMonster) withObject:nil afterDelay:2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callMonster) name:kNotificationForCallMonster object:nil];

}

- (void)callMonster{
    if (self.monsterDic.count >= 4) {
        return;
    }
    [self createRandomMonster:12];
}

- (void)createMonster
{
    
    [self createBoss3Monster];
//    for (int i = 0; i < 5; i ++) {
//        [self createRandomMonster:12];
//    }
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
        //[self createCannonMonster];
    }else{
        //[self createRandomMonster:12];
    }
    
}


- (void)clearAction
{
    [super clearAction];
}

- (void)dealloc
{
    NSLog(@"场景3释放了✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨");
}

@end
