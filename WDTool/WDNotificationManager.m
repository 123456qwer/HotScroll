//
//  WDNotificationManager.m
//  begin
//
//  Created by Mac on 2018/11/9.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDNotificationManager.h"
static WDNotificationManager *manager = nil;
@implementation WDNotificationManager
+ (WDNotificationManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[WDNotificationManager alloc] init];
        }
    });
    
    return manager;
}

- (void)postNotificationForChangePerson
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangePersonAction object:nil];
}

- (void)postNotificationForAttackType:(AttackBtnType)type
{
    WDTextureManager *manager = [WDTextureManager shareManager];
    if (type == attack) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeAttackBtnImage object:@{kAttackImageName:manager.attackImage}];
    }else if(type == talk){
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeAttackBtnImage object:@{kAttackImageName:manager.talkImage}];
    }else if(type == click){
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeAttackBtnImage object:@{kAttackImageName:manager.clickImage}];
    }
}



- (void)postNotificationWithAllBlood:(CGFloat)allBlood
                            nowBlood:(CGFloat)nowBlood
                         changeCount:(CGFloat)count
{
    NSDictionary *dic = @{@"all":@(allBlood),@"now":@(nowBlood),@"changeCount":@(count)};
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChangeBloodCount object:dic];
}


- (void)postNotificationWithAttack:(CGFloat)attack
{
    NSDictionary *dic = @{@"attack":@(attack)};
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChangeAttackCount object:dic];
}



- (void)postNotificationWithGoldCount:(NSInteger)count
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForDropMoneyAction object:@{@"gold":@(count)}];
}

- (void)postNotificationWithMissCount:(CGFloat)count
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChangeMissCount object:@{@"miss":@(count)}];
}

- (void)postNotificationForGoldFly
{
       [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationGoldFly object:nil];
}

- (void)postNotificationForCallMonster
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForCallMonster object:nil];
}

@end
