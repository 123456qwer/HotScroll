//
//  WDTextureManager.h
//  HotSchool
//
//  Created by Mac on 2018/8/1.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShooterModel.h"
#import "ShanaModel.h"
#import "Person1Model.h"
#import "NPCModel1.h"
#import "PassDoorModel.h"
#import "ThiefModel.h"
#import "AngelModel.h"
#import "SavageModel.h"
#import "MagicModel.h"
#import "WizardModel.h"
#import "SniperModel.h"
#import "BigBladeModel.h"
#import "KanaModel.h"
#import "BowModel.h"
#import "SpearModel.h"
#import "Spear2Model.h"
#import "Bow2Model.h"
#import "ForkModel.h"
#import "AXEModel.h"
#import "CannonModel.h"
#import "Boss3Model.h"

@interface WDTextureManager : NSObject

+ (WDTextureManager *)shareManager;

@property (nonatomic,assign)CGFloat WD_MAX_HEIGHT;
@property (nonatomic,assign)CGFloat WD_MAX_WIDTH;



@property (nonatomic,copy)NSArray <SKTexture *>*antUpMoveArr;
@property (nonatomic,copy)NSArray <SKTexture *>*antRightMoveArr;


@property (nonatomic,strong)SKAction *beAttackMusicAction;




#pragma mark 游戏中常用图片加载管理
/** 底部黑圈 */
@property (nonatomic,copy)NSArray <SKTexture *>*blackCircleArr;
/** 鸟 */
@property (nonatomic,copy)NSArray <SKTexture *>*seagullArr;
/** 蝴蝶 */
@property (nonatomic,copy)NSArray <SKTexture *>*butterFlyStayArr;
@property (nonatomic,copy)NSArray <SKTexture *>*butterFlyFlyArr;
/** 木箱子 */
@property (nonatomic,copy)NSArray <SKTexture *>*woodChestArr;
/** 银箱子 */
@property (nonatomic,copy)NSArray <SKTexture *>*cliverChestArr;

/** 蜥蜴 */
@property (nonatomic,copy)NSArray <SKTexture *>*lizardArr;

/** 松鼠 */
@property (nonatomic,copy)NSArray <SKTexture *>*squirrelStayArr;
@property (nonatomic,copy)NSArray <SKTexture *>*squirrelRunArr;

/** 伤害效果 */
@property (nonatomic,strong)NSDictionary *demageDic;
/** 小怪出场光效 */
@property (nonatomic,copy)NSArray <SKTexture *>*lightArr;
/** 小怪出场光效 */
@property (nonatomic,copy)NSArray <SKTexture *>*smokeArr;
/** 绿光 */
@property (nonatomic,copy)NSArray <SKTexture *>*greenArr;
/** 蓝光 */
@property (nonatomic,copy)NSArray <SKTexture *>*blueArr;
/** 闪避 */
@property (nonatomic,copy)NSArray <SKTexture *>*passive_missArr;
/** 通关传送门 */
@property (nonatomic,copy)NSArray <SKTexture *>*pass_doorArr;

@property (nonatomic,strong)SKTexture *bottomTree;

#pragma mark ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨常用图片✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

/** 掉落金币图片 */
@property (nonatomic,strong,readonly)UIImage *moneyImage;
/** 说话图片 */
@property (nonatomic,strong,readonly)UIImage *talkImage;
/** 攻击按钮图片 */
@property (nonatomic,strong,readonly)UIImage *attackImage;
/** 点击按钮图片 */
@property (nonatomic,strong,readonly)UIImage *clickImage;

#pragma mark ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨model纹理✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
/** 弓箭手model */
@property (nonatomic,strong,readonly)ShooterModel *shooterModel;
/** 夏娜model */
@property (nonatomic,strong,readonly)ShanaModel *shanaModel;
/** 默认玩家model */
@property (nonatomic,strong,readonly)Person1Model *personModel;
/** 学习技能的npc1 */
@property (nonatomic,strong,readonly)NPCModel1 *npc1Model;
/** boss传送门 */
@property (nonatomic,strong,readonly)PassDoorModel *passDoorModel;
/** 盗贼model */
@property (nonatomic,strong,readonly)ThiefModel *thiefModel;
/** 天使model */
@property (nonatomic,strong,readonly)AngelModel *angelModel;
/** 野蛮人model */
@property (nonatomic,strong,readonly)SavageModel *savageModel;
/** 法师model */
@property (nonatomic,strong,readonly)MagicModel *magicModel;
/** 巫师model */
@property (nonatomic,strong,readonly)WizardModel *wizardModel;
/** 阻击手model */
@property (nonatomic,strong,readonly)SniperModel *sniperModel;
/** 大刀兵model */
@property (nonatomic,strong,readonly)BigBladeModel *bladeModel;
/** 卡娜model */
@property (nonatomic,strong,readonly)KanaModel *kanaModel;
/** 弓箭手2model */
@property (nonatomic,strong,readonly)BowModel *bowModel;
/** 枪兵model */
@property (nonatomic,strong,readonly)SpearModel *spearModel;
/** 枪兵2model */
@property (nonatomic,strong,readonly)Spear2Model *spear2Model;
/** 弓箭手3model*/
@property (nonatomic,strong,readonly)Bow2Model *bow2Model;
/** 叉兵 */
@property (nonatomic,strong,readonly)ForkModel *forkModel;
/** 斧兵 */
@property (nonatomic,strong,readonly)AXEModel *axeModel;
/** 加农兵 */
@property (nonatomic,strong,readonly)CannonModel *cannonModel;
/** boss3 */
@property (nonatomic,strong,readonly)Boss3Model *boss3Model;


@property (nonatomic,assign)CGFloat mb;


/**
 加载一些通用纹理
 */
- (void)loadCommonTexture;

/** 释放夏娜model */
- (void)releaseShanaModel;

/** 释放所有Model */
- (void)releaseAllModel;

/** 加载需要的纹理,根据类名加载 */
- (void)loadSceneWithClassName:(NSString *)className;



/** 被动技能纹理 */
- (void)setMissArr:(BOOL)isSet;

@end
