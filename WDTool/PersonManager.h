//
//  PersonManager.h
//  HotSchool
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNode.h"

@interface PersonManager : NSObject

+ (PersonManager *)sharePersonManager;

@property (nonatomic,assign)CGFloat wdSpeed;
@property (nonatomic,assign)CGFloat wdAttack;
@property (nonatomic,assign)CGFloat wdBlood;  //总血量
@property (nonatomic,assign)CGFloat nowBlood; //当前血量
@property (nonatomic,assign)CGFloat wdMoney;  //金钱
@property (nonatomic,assign)CGFloat wdMiss;   //闪躲几率

@property (nonatomic,copy)NSString *skill1Name;
@property (nonatomic,copy)NSString *skill2Name;
@property (nonatomic,copy)NSString *skill3Name;
@property (nonatomic,copy)NSString *skill4Name;

@property (nonatomic,assign)NSString *name;   //当前选中的猪脚名称


@property (nonatomic,assign)BOOL passive_fireBlade;  //火焰剑增益效果
@property (nonatomic,assign)BOOL passive_miss;       //闪避增益效果
@property (nonatomic,assign)BOOL passive_suckBlood;  //吸血增益效果

@property (nonatomic,assign)BOOL isFireAttackIng;
@property (nonatomic,weak)BaseNode *personNode;
- (void)setShana;
- (void)setPerson;
- (void)setKana;

/** 初始化人物属性 */
- (void)initPersonProperty;

/** 初始化物品效果加成 */
- (void)initPersonEffectWithPerson:(BaseNode *)personNode;

#pragma mark ----人物状态触发的攻击效果----

/** 火焰剑攻击 */
+ (void)fireBladeActionWithPerson:(BaseNode *)personNode;

/** 火焰剑移动 */
+ (void)fireBladeMove:(BaseNode *)personNode;

/** 移除火焰剑buff */
- (void)removeFireBlade;
/** 设置火焰剑 */
- (void)setFireBlade;



/** 设置MISS状态 */
- (void)setMiss;
/** 移除MISS状态 */
- (void)removeMiss;

@end
