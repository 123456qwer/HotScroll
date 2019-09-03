//
//  FirstScene.m
//  HotSchool
//
//  Created by Mac on 2018/7/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "Boss1Scene.h"

//场景动物动画
#import "AnimationButterFlyNode.h"
#import "AnimationSeagullNode.h"
#import "AnimationAntNode.h"

#import "Person1Node.h"
#import "ShooterMonster.h"
#import "ShanaMonster.h"
#import "ShanaNode.h"

//提前加载数据
#import "Person1Model.h"
#import "ShooterModel.h"
#import "ShanaModel.h"

@implementation Boss1Scene
{
    ShanaMonster *_shanaMonster;
}


#pragma mark 进入场景的第一入口方法
- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
  
    self.delegate = self;
    self.sceneDelegate = self;

    self.wallCount = 7;
    //边界
    [self setWallPhy];
    
    [self createSceneAnimation];
    [self performSelector:@selector(createMonster) withObject:nil afterDelay:2.0];
    self.nextSceneNum = 15 + arc4random() % 10;
    self.sceneIndex = 4;

}

- (void)createMonster
{
    for (int i = 0; i < 5; i ++) {
        [self createRandomMonster:4];
    }
}





#pragma mark 第一关BOSS灼眼的夏娜
/** 灼眼的夏娜BOSS相关 */
- (void)createMonsterShana
{
    if (_shanaMonster) {
        return;
    }
    _shanaMonster = [[ShanaMonster alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"person2_stay_1"]]];
    _shanaMonster.position = CGPointMake(1000, 300);
    _shanaMonster.xScale = 2;
    _shanaMonster.yScale = 2;
    _shanaMonster.zPosition = 100;
    _shanaMonster.alpha = 0;
    _shanaMonster.isBeAttackIng = YES; //不能被攻击，开始阶段
    [self.bgNode addChild:_shanaMonster];
    
    [_shanaMonster setPersonNode:self.personNode];
    [_shanaMonster initActionWithModel:self.textureManager.shanaModel];
    //[_shanaMonster stayAction];
    
    [self.personNode.delegate setBossMonster:_shanaMonster];
    [_shanaMonster setPhySicsBodyNone];
    
    BaseNode *node = [BaseNode spriteNodeWithTexture:self.textureManager.lightArr[0]];
    
    node.position = _shanaMonster.position;
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
    [_shanaMonster runAction:alphaA completion:^{
        [weakSelf shanaBeginMove];
    }];
    
    __weak ShanaMonster *shana = _shanaMonster;
    [_shanaMonster setDeadBlock:^(NSString *name) {
        
        [WDActionTool dropMoneyAnimation:weakSelf.bgNode position:shana.position gold:10];
        weakSelf.chestNode = [weakSelf createChestWithBossPoint:shana.position];

        NSLog(@"夏娜阵亡");
        if ([[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex] < 5) {
            [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:kSceneIndex];
        }
        
        [weakSelf createNextWallAndArrow];
    }];
    
}


- (void)shanaBeginMove
{
    [_shanaMonster setPhy];
    [_shanaMonster beginMove];
    _shanaMonster.isBeAttackIng = NO;
}


#pragma mark 怪物被消灭并从场景中删除
- (void)removeMonsterWithName:(NSString *)name
{
    BaseNode *shooterNode = self.monsterDic[name];
    [WDActionTool dropMoneyAnimation:self.bgNode position:shooterNode.position gold:1];
    [self.monsterDic removeObjectForKey:name];
    
    self.killMonsterNum ++;
    
    //消灭怪物刷出第一关BOSS <✨✨✨✨✨✨!灼眼shana!✨✨✨✨✨✨>
    if (self.killMonsterNum >= self.nextSceneNum) {
        [self createMonsterShana];
    }else{
        [self createRandomMonster:4];
    }
 
}


#pragma mark 清理相关
- (void)clearAction
{
    [super clearAction];

    //释放夏娜
    if (_shanaMonster) {
        [_shanaMonster clearAction];
        [_shanaMonster removeAllActions];
        [_shanaMonster removeFromParent];
        _shanaMonster = nil;
    }
    
}

- (void)dealloc{
    NSLog(@"BOSS场景1释放了✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨");
}



@end
