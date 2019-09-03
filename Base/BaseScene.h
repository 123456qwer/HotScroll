//
//  BaseScene.h
//  HotSchool
//
//  Created by Mac on 2018/7/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AnimationButterFlyNode.h"
#import "AnimationChestNode.h"


#import "ThiefMonster.h"
#import "ShooterMonster.h"
#import "WizardMonster.h"
#import "MagicMonster.h"
#import "WizardModel.h"
#import "SniperMonster.h"
#import "SavageMonster.h"
#import "AngelMonster.h"
#import "BigBladeMonster.h"
#import "BowMonster.h"
#import "Bow2Monster.h"
#import "SpearMonster.h"
#import "Spear2Monster.h"
#import "ForkMonster.h"
#import "AXEMonster.h"
#import "CannonMonster.h"
#import "Boss3Monster.h"

#import "Person1Model.h"
#import "ShanaModel.h"
#import "SniperModel.h"

#import "Person1Node.h"
#import "ShanaNode.h"
#import "KanaNode.h"

#import "WDTextureManager.h"
#import "WDNotificationManager.h"
#import "WDSceneManager.h"
@protocol BaseSceneDelegate <NSObject>

/** 需要在子类中重写，每个场景消灭怪物等需要特殊处理 */
- (void)removeMonsterWithName:(NSString *)name;

@end

@interface BaseScene : SKScene<SKPhysicsContactDelegate>

/** 通知管理类 */
@property (nonatomic,strong)WDNotificationManager *notificationManager;
/** 基础纹理管理类 */
@property (nonatomic,strong)WDTextureManager *textureManager;
/** model <目前3个>*/
@property (nonatomic,strong)Person1Model *personModel;
@property (nonatomic,strong)ShanaModel   *shanaModel;
@property (nonatomic,strong)KanaModel    *kanaModel;

/** 存储怪物容器 key:name -> value:monster */
@property (nonatomic,strong)NSMutableDictionary *monsterDic;
/** 物理墙个数 */
@property (nonatomic,assign)NSInteger wallCount;
/** 游戏主角 */
@property (nonatomic,strong)BaseNode   *personNode;
/** 主场景 */
@property (nonatomic,strong)BaseNode   *bgNode;
/** 副场景 */
@property (nonatomic,strong)BaseNode   *bgNode2;
/** 判断人物是否死亡 */
@property (nonatomic,assign)BOOL isDead;
/** 可以去下一关 */
@property (nonatomic,assign)BOOL canGoNextScene;
@property (nonatomic,weak)id<BaseSceneDelegate>sceneDelegate;


/** 通关得黄星的最短时间,默认30秒 */
@property (nonatomic,assign)NSInteger starTimes;
/** 通关用时 */
@property (nonatomic,assign)NSInteger useTimes;
@property (nonatomic,strong)NSTimer *passTimer;

/** 当前关卡，从WDFirstScene = 0 开始递增*/
@property (nonatomic,assign)NSInteger sceneIndex;

#pragma mark ----- 界面回调 -----
@property (nonatomic,copy)void (^loadImageFinishBlock)(void); //加载图片完毕，通知push视图
@property (nonatomic, copy)void (^deadBlock)(NSString *name); //人物死亡
@property (nonatomic,copy)void (^learnBaseBlock)(void);       //弹出基础属性学习面板
@property (nonatomic,copy)void (^selectMapBlock)(void);       //弹出选择地图面板
@property (nonatomic,copy)void (^changeSceneBlock)(NSInteger index);     //切换关卡
@property (nonatomic,copy)void (^unlockSkillBlock)(NSInteger index); //解锁技能
@property (nonatomic,copy)void (^selectPassiveBlock)(void);       //选择被动技能界面

@property (nonatomic ,assign)BOOL isChest;
@property (nonatomic,strong)AnimationChestNode *chestNode;

#pragma mark ----怪物数量----
@property (nonatomic,assign)int shooterNum;    //射手
@property (nonatomic,assign)int thiefNum;      //盗贼
@property (nonatomic,assign)int wizardNum;     //巫师<闪电>
@property (nonatomic,assign)int magicNum;      //巫师<火球>
@property (nonatomic,assign)int savageNum;     //野蛮人
@property (nonatomic,assign)int sniperNum;     //阻击手
@property (nonatomic,assign)int angelNum;      //天使
@property (nonatomic,assign)int bigBladeNum;   //大刀兵
@property (nonatomic,assign)int bowNum;        //射手2
@property (nonatomic,assign)int bow2Num;        //射手3
@property (nonatomic,assign)int spearNum;      //枪兵
@property (nonatomic,assign)int spear2Num;      //枪兵2
@property (nonatomic,assign)int forkNum;       //叉兵
@property (nonatomic,assign)int axeNum;        //斧兵
@property (nonatomic,assign)int cannonNum;     //加农兵

@property (nonatomic,assign)int killNum;

@property (nonatomic,assign)int nextSceneNum;  //触发下一关需要杀死的怪物数量
@property (nonatomic,assign)int allMonsterNum; //怪物总数
@property (nonatomic,assign)int killMonsterNum;//杀死的怪物总数

/** 人物行走 */
- (void)moveActionWithDirection:(NSString *)direction
                       position:(CGPoint)point;
/** 人物停止移动 */
- (void)stopMoveActionWithDirection:(NSString *)direction;


/** 大按钮点击方法，通常为攻击 */
- (void)attackAction:(NSString *)direction;
/** 人物释放技能 */
- (void)skillActionWithType:(NSInteger)type;


/** 蓄力结束 */
- (void)longAttackEndAction:(NSString *)direction;

/** 蓄力开始 */
- (void)longAttackBeginAction:(NSString *)direction;

/** 地图消失，清除内存 */
- (void)clearAction;

/** 场景动画 */
- (void)createSceneAnimation;

/** 满血通关，出现宝箱 */
- (AnimationChestNode *)createChestWithBossPoint:(CGPoint)point;

/** 创建下一关触碰的墙体 */
- (void)createNextWallAndArrow;

/** 普通攻击 */
- (BOOL)normalAttack;
/** 设置墙物理体积 */
- (void)setWallPhy;
/** 移除墙物理体积 */
- (void)setWallZeroPhy;

/** 根据玩家选中的创建角色 */
- (void)loadPersonNode;

#pragma mark ----工具方法---
/** 数字转字符串 */
- (NSString *)numberToStr:(NSInteger)number;

@end



