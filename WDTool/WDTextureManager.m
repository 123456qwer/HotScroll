//
//  WDTextureManager.m
//  HotSchool
//
//  Created by Mac on 2018/8/1.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDTextureManager.h"
static WDTextureManager *manager = nil;
@implementation WDTextureManager
{
    
    //SKTextureModel
    
    ShooterModel  *_shooterModel;
    ShanaModel    *_shanaModel;
    Person1Model  *_personModel;
    NPCModel1     *_npc1Model;
    PassDoorModel *_passDoorModel;
    ThiefModel    *_thiefModel;
    AngelModel    *_angelModel;
    SavageModel   *_savageModel;
    MagicModel    *_magicModel;
    WizardModel   *_wizardModel;
    SniperModel   *_sniperModel;
    BigBladeModel *_bladeModel;
    KanaModel     *_kanaModel;
    BowModel      *_bowModel;
    SpearModel    *_spearModel;
    Spear2Model   *_spear2Model;
    Bow2Model     *_bow2Model;
    ForkModel     *_forkModel;
    AXEModel      *_axeModel;
    CannonModel   *_cannonModel;
    Boss3Model    *_boss3Model;
    
    //Image
    
    UIImage       *_moneyImage;
    UIImage       *_talkImage;
    UIImage       *_clickImage;
    UIImage       *_attackImage;
    
}


+ (WDTextureManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[WDTextureManager alloc] init];
        }
    });
    
    return manager;
}

- (NSMutableArray *)loadWithImageName:(NSString *)name
                                count:(NSInteger)count
{
    NSMutableArray *muAr = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        NSString *nameS = [NSString stringWithFormat:@"%@%d",name,i+1];
        SKTexture *texture1 = [SKTexture textureWithImage:[UIImage imageNamed:nameS]];
        [muAr addObject:texture1];
    }
    
    return muAr;
}


- (void)loadCommonTexture
{
    self.WD_MAX_HEIGHT = 750;
    self.WD_MAX_WIDTH = 2885;
   
    //只有黑色圈，是每个图都需要的
    [self loadBlackCircleArr];
}

- (void)loadBlackCircleArr
{
    _blackCircleArr = [self loadWithImageName:@"person_black_circle_" count:5];
}

- (void)setMissArr:(BOOL)isSet{
    if (isSet) {
        self.passive_missArr = [self loadWithImageName:@"shana_miss_" count:8];
    }else{
        self.passive_missArr = nil;
    }
}



#pragma mark ----加载纹理----
- (void)loadSceneWithClassName:(NSString *)className
{
    [self releaseAllModel];
   
    NSString *method = [NSString stringWithFormat:@"%@",className];
    SEL action = NSSelectorFromString(method);
    if ([self respondsToSelector:action]) {
        [self performSelector:action withObject:nil afterDelay:0];
        [[NSRunLoop currentRunLoop] run];
    }
}

#pragma mark ----启程关卡---
- (void)BeginScene{
    
    self.WD_MAX_WIDTH = 2885;
    
    //绿光、蓝光、蝴蝶
    _greenArr = [self loadWithImageName:@"green_light_" count:16];
    _blueArr  = [self loadWithImageName:@"blue" count:6];
    _butterFlyFlyArr = [self loadWithImageName:@"butterFly_fly_" count:8];
    _butterFlyStayArr = [self loadWithImageName:@"butterFly_stay_" count:8];
}


/** 关卡场景通用纹理 */
- (void)sceneCommonTexture
{
    _smokeArr = [self loadWithImageName:@"smoke_" count:14];
    _lightArr = [self loadWithImageName:@"light_" count:23];
    [self moneyImage];
    SKTexture *demageTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"demage1"]];
    SKTexture *skillDemageTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"skillDemage"]];
    _demageDic = @{@"demage1":demageTexture,@"skillDemage":skillDemageTexture};
}

#pragma mark ----boss关卡----
- (void)Boss1Scene{
    [self sceneCommonTexture];
    self.WD_MAX_WIDTH = 2885;
    [self thiefModel];
    [self shooterModel];
    [self wizardModel];
    [self magicModel];
    [self shanaModel];
}

- (void)Boss2Scene{
    
    [self Boss1Scene];
   
   
    [self bladeModel];
    [self angelModel];
    [self savageModel];
    [self sniperModel];
   
    [self kanaModel];
}

- (void)Boss3Scene{
    [self boss3Model];
    [self Boss2Scene];
    [self bowModel];
    [self bow2Model];
    [self spearModel];
    [self spear2Model];
}

#pragma mark ----1到4关----
- (void)WD1Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self shooterModel];
}

- (void)WD2Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self thiefModel];
}

- (void)WD3Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self wizardModel];
}

- (void)WD4Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self magicModel];
}

#pragma mark ----5到9关----
- (void)WD5Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self sniperModel];
}

- (void)WD6Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self savageModel];
}

- (void)WD7Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self angelModel];
}

- (void)WD8Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self bladeModel];
}

#pragma mark ----9到12u关----
- (void)WD9Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self bowModel];
}

- (void)WD10Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self bow2Model];
}

- (void)WD11Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self spearModel];
}

- (void)WD12Scene
{
    self.WD_MAX_WIDTH = 2251;
    [self sceneCommonTexture];
    [self spear2Model];
}


#pragma mark ----动物----
//松鼠
- (void)loadSquirrelArr
{
    _squirrelStayArr = [self loadWithImageName:@"squirrel_stay_" count:7];
    NSMutableArray *arr  = [self loadWithImageName:@"squirrel_run_" count:8];
    [arr removeObjectAtIndex:0];
    [arr removeObjectAtIndex:0];
    _squirrelRunArr = arr;
}

//蜥蜴
- (void)loadLizardArr
{
    _lizardArr = [self loadWithImageName:@"lizard_" count:17];
}

//海鸥
- (void)loadSeagullArr
{
    _seagullArr = [self loadWithImageName:@"seagull_" count:15];
}

//蚂蚁
- (void)loadAntArr{
    
    _antUpMoveArr = [self loadWithImageName:@"ant_up_" count:6];
    _antRightMoveArr = [self loadWithImageName:@"ant_right_" count:6];
}

#pragma mark 怪物纹理
#pragma mark 弓箭手
- (ShooterModel *)shooterModel
{
    if (!_shooterModel) {
        _shooterModel = [ShooterModel new];
        [_shooterModel setTextures];
    }
    
    return _shooterModel;
}

#pragma mark 夏娜
- (ShanaModel *)shanaModel
{
    if (!_shanaModel) {
        _shanaModel = [ShanaModel new];
        [_shanaModel setTextures];
    }
    
    return _shanaModel;
}

- (void)releaseShanaModel
{
    _shanaModel = nil;
}

#pragma mark 默认玩家
- (Person1Model *)personModel
{
    if (!_personModel) {
        _personModel = [Person1Model new];
        [_personModel setTextures];
    }
    
    return _personModel;
}

#pragma mark 学习技能的npc1
- (NPCModel1 *)npc1Model
{
    if (!_npc1Model) {
        _npc1Model = [NPCModel1 new];
        [_npc1Model setTextures];
    }
    
    return _npc1Model;
}

#pragma mark 传送门model
- (PassDoorModel *)passDoorModel
{
    if (!_passDoorModel) {
        _passDoorModel = [PassDoorModel new];
        [_passDoorModel setTextures];
    }
    
    return _passDoorModel;
}

#pragma mark 盗贼
- (ThiefModel *)thiefModel
{
    if (!_thiefModel) {
        _thiefModel = [ThiefModel new];
        [_thiefModel setTextures];
    }
    
    return _thiefModel;
}

#pragma mark 天使
- (AngelModel *)angelModel
{
    if (!_angelModel) {
        _angelModel = [AngelModel new];
        _angelModel.name = @"天使";
        [_angelModel setTextures];
    }
    
    return _angelModel;
}

#pragma mark 野蛮人
- (SavageModel *)savageModel
{
    if (!_savageModel) {
        _savageModel = [SavageModel new];
        [_savageModel setTextures];
    }
    
    return _savageModel;
}

#pragma mark 法师
- (MagicModel *)magicModel
{
    if (!_magicModel) {
        _magicModel = [MagicModel new];
        [_magicModel setTextures];
    }
    
    return _magicModel;
}

#pragma mark 巫师
- (WizardModel *)wizardModel
{
    if (!_wizardModel) {
        _wizardModel = [WizardModel new];
        [_wizardModel setTextures];
    }
    
    return _wizardModel;
}

#pragma mark 阻击手
- (SniperModel *)sniperModel
{
    if (!_sniperModel) {
        _sniperModel = [SniperModel new];
        [_sniperModel setTextures];
    }
    
    return _sniperModel;
}

#pragma mark 大刀兵
- (BigBladeModel *)bladeModel
{
    if (!_bladeModel) {
        _bladeModel = [BigBladeModel new];
        [_bladeModel setTextures];
    }
    
    return _bladeModel;
}

#pragma mark 卡娜
- (KanaModel *)kanaModel
{
    if (!_kanaModel) {
        _kanaModel = [KanaModel new];
        [_kanaModel setTextures];
    }
    
    return _kanaModel;
}

#pragma mark 弓兵2
- (BowModel *)bowModel
{
    if (!_bowModel) {
        _bowModel = [BowModel new];
        [_bowModel setTextures];
    }
    
    return _bowModel;
}

#pragma mark 弓兵3
- (Bow2Model *)bow2Model
{
    if (!_bow2Model) {
        _bow2Model = [Bow2Model new];
        [_bow2Model setTextures];
    }
    
    return _bow2Model;
}

#pragma mark 叉兵
- (ForkModel *)forkModel
{
    if (!_forkModel) {
        _forkModel = [ForkModel new];
        [_forkModel setTextures];
    }
    
    return _forkModel;
}


#pragma mark 枪兵
- (SpearModel *)spearModel
{
    if (!_spearModel) {
        _spearModel = [SpearModel new];
        [_spearModel setTextures];
    }
    
    return _spearModel;
}

#pragma mark 枪兵2
- (Spear2Model *)spear2Model
{
    if (!_spear2Model) {
        _spear2Model = [Spear2Model new];
        [_spear2Model setTextures];
    }
    
    return _spear2Model;
}

#pragma mark 斧兵
- (AXEModel *)axeModel
{
    if (!_axeModel) {
        _axeModel = [AXEModel new];
        [_axeModel setTextures];
    }
    
    return _axeModel;
}

#pragma mark 加农兵
- (CannonModel *)cannonModel
{
    if (!_cannonModel) {
        _cannonModel = [CannonModel new];
        [_cannonModel setTextures];
    }
    
    return _cannonModel;
}

#pragma mark boss3
- (Boss3Model *)boss3Model
{
    if (!_boss3Model) {
        _boss3Model = [Boss3Model new];
        [_boss3Model setTextures];
    }
    
    return _boss3Model;
}

#pragma mark 释放所有Model
- (void)releaseAllModel
{
    _boss3Model     = nil;
    _personModel    = nil;
    _shanaModel     = nil;
    _kanaModel      = nil;
    _npc1Model      = nil;
    _passDoorModel  = nil;
    _shooterModel   = nil;
    _thiefModel     = nil;
    _wizardModel    = nil;
    _magicModel     = nil;
    _sniperModel    = nil;
    _angelModel     = nil;
    _savageModel    = nil;
    _bladeModel     = nil;
    _bowModel       = nil;
    _bow2Model      = nil;
    _spearModel     = nil;
    _spear2Model    = nil;
   
    self.greenArr = nil;
    self.blueArr  = nil;
    self.butterFlyFlyArr = nil;
    self.butterFlyStayArr = nil;
    self.smokeArr = nil;
    self.lightArr = nil;
    
    _demageDic    = nil;
    
    _moneyImage = nil;
    _clickImage = nil;
    _talkImage  = nil;
}


#pragma mark -----常用图片管理----
- (UIImage *)moneyImage
{
    if (!_moneyImage) {
        _moneyImage = [UIImage imageNamed:@"moneyImage"];
    }
    
    return _moneyImage;
}

- (UIImage *)clickImage
{
    if (!_clickImage) {
        _clickImage = [UIImage imageNamed:@"clickImage"];
    }
    
    return _clickImage;
}

- (UIImage *)talkImage
{
    if (!_talkImage) {
        _talkImage = [UIImage imageNamed:@"talkImage"];
    }
    
    return _talkImage;
}

- (UIImage *)attackImage
{
    if (!_attackImage) {
        _attackImage = [UIImage imageNamed:@"attackOpeation_1"];
    }
    
    return _attackImage;
}

@end
