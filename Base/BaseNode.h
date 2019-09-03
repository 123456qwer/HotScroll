//
//  BaseNode.h
//  HotSchool
//
//  Created by 吴冬 on 2018/7/1.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WDBaseModel.h"
#import "WDTextureManager.h"

@class BaseNode;
//子类需实现的方法
@protocol NodeBaseActionDelegate <NSObject>


@required

/**
 遭受攻击

 @param attackerIsLeft 攻击者是否在人物左边
 @param count 伤害数值
 */
- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count;
/** 死亡方法 */
- (void)deadAction:(BOOL)attackerIsLeft;



@optional
/** 被击倒 */
- (void)downAction:(BOOL)attakcerIsLeft
       attackCount:(CGFloat)count;

/** 每一关都有的一个BOSS */
- (void)setBossMonster:(BaseNode *)node;

/** 人物攻击方法<怪物攻击方法子类自定义> */
- (void)attackAction;

@end


@interface BaseNode : SKSpriteNode


@property (nonatomic, assign)id <NodeBaseActionDelegate>delegate; //基础行为

@property (nonatomic, assign)BOOL isDefense;     //防御状态
@property (nonatomic, assign)BOOL isMoveIng;     //移动状态


@property (nonatomic, assign)BOOL isAttackIng;   //攻击状态
@property (nonatomic, assign)BOOL isBeAttackIng; //正在被攻击
@property (nonatomic, assign)BOOL isSkillAttackIng; //释放技能状态


@property (nonatomic, assign)BOOL isDeadIng;   //死亡
@property (nonatomic, assign)BOOL isContact;   //正在发生碰撞

@property (nonatomic, assign)BOOL isInvincible; //无敌状态
@property (nonatomic, assign)BOOL isPressIng;   //是否正在蓄力



/* 人物 当前 buff */
@property (nonatomic, assign)BOOL oppositeDebuff; ///<操作状态相反>


@property (nonatomic, assign)CGFloat wdNowBlood;  //当前血量
@property (nonatomic, assign)CGFloat wdBlood;     //血量
@property (nonatomic, assign)CGFloat wdAttack;    //攻击力
@property (nonatomic, assign)CGFloat wdMiss;      //闪避概率

@property (nonatomic, assign)NSInteger attackType; //攻击状态<1阶段、2阶段等>
@property (nonatomic, assign)NSInteger skillType;  //技能状态


@property (nonatomic, assign)CGFloat wdSpeed;     //移动速度
@property (nonatomic ,strong)WDBaseModel *model;
@property (nonatomic ,strong)SKSpriteNode *blackCircleNode;
@property (nonatomic, assign)int directon; //人物朝向<左为正，右为负>
@property (nonatomic, assign)CGFloat imageWidth;//显示的图片大小<通常比实际图片小,每一个新猪脚都要创建一个>
@property (nonatomic, assign)CGFloat imageHeight;//显示的图片大小<通常比实际图片小>
@property (nonatomic,copy)NSString *personRealName; //玩家角色真实姓名<如夏娜、卡娜...>


@property (nonatomic, copy)void (^deadBlock)(NSString *name); //人物死亡
//人物攻击回调
@property (nonatomic,copy)void (^attackBlockWithTime)(CGFloat times,NSInteger attackType);
//人物技能回调
@property (nonatomic,copy)void (^skillBlockWithTime)(CGFloat times,NSInteger skillType);
//人物技能释放完毕的回调
@property (nonatomic,copy)void (^endSkillBlock)(void);

/** 基础纹理管理类 */
@property (nonatomic,strong)WDTextureManager *textureManager;


/** 玩家私有死亡方法 */
- (BOOL)isDeadAction:(CGFloat)count
   attackerDirection:(BOOL)attackerIsLeft;





/** 人物底部的黑圈 */
- (void)createBlackCircle;

/** 设置Node物理属性为空 */
- (void)setPhySicsBodyNone;

/**
 设置物理属性
 */
- (void)setPhy;

/** 被技能攻击到的方法 */
- (void)beSkillAttackAction:(BOOL)attackerIsLeft
                attackCount:(CGFloat)count;



/** 初始化图片 */
- (void)initActionWithModel:(WDBaseModel *)model;

/** 人物释放技能 */
- (void)skillAction:(NSInteger)type;

/** 人物停止移动 */
- (void)stayAction;

/** 人物移动 BOOL -> 返回值告诉地图是否可以移动*/
- (BOOL)moveAction:(NSString *)direction
             point:(CGPoint)point;


/** 显示图片真实大小 */
- (void)realBackGroundWithColor:(UIColor *)color;
- (void)removeRealNode;
- (void)centerSprite:(UIColor *)color;

/** 显示图片物理尺寸<可碰撞的体积> */
- (void)physicalBackGroundNodeWithColor:(UIColor *)color
                                   size:(CGSize)size
                               position:(CGPoint)point;
- (void)removePhysicalNode;


/** 清理内存方法 */
- (void)clearAction;




- (BOOL)isCanNotAttack;
- (BOOL)isCanNotSkillAttack;
- (BOOL)isCanNotMove;
- (BOOL)isCanNotBeAttack;
- (BOOL)isCanNotPressAttack;


/** 清空所有状态 */
- (void)allStatusClear;

/**
 判断当前方向

 @return 1为正方向，-1为反方向
 */
- (CGFloat)leftOrRight;


/**
 怪物设置通用物理属性
 */
- (void)setMonsterNormalPhybodyWithFrame:(CGRect)rect;

@end







#pragma mark 怪物父类
@protocol MonsterActionDelegate <NSObject>

@required
//怪物行走方法
- (void)monsterMoveAction:(BaseNode *)personNode;
//怪物攻击
- (void)monsterAttackAction;

@end

@interface BaseMonsterNode:BaseNode<MonsterActionDelegate>

@property (nonatomic,weak)id<MonsterActionDelegate>monsterDelegate;
@property (nonatomic,weak)BaseNode *personNode;

@property (nonatomic,assign)CGFloat min_X_Distance; //触发攻击的最小距离，根据怪物模型而定<默认60>
@property (nonatomic,assign)CGFloat min_Y_Distance;

/** 通用死亡方法 <简单的后移加ALPHA=0>*/
- (void)deadAnimation:(BOOL)attackerIsLeft;

/** 每一个小怪都拥有玩家 */
- (void)setPersonNode:(BaseNode *)personNode;

@end







