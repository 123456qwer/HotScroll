//
//  GameViewController.m
//  HotSchool
//
//  Created by 吴冬 on 2018/5/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "GameViewController.h"

#import "WDSceneManager.h"

#import "BaseScene+LoadSceneImages.h"
#import "GameScene.h"
#import "BaseScene.h"
#import "BeginScene.h"
#import "Boss1Scene.h"
#import "Boss2Scene.h"
#import "Boss3Scene.h"
#import "WD1Scene.h"
#import "WD2Scene.h"
#import "WD3Scene.h"
#import "WD4Scene.h"
#import "WD5Scene.h"
#import "WD6Scene.h"
#import "WD7Scene.h"

#import "LoadingScene.h"

#import "WDMoveOpeartionView.h"
#import "WDSkillOperationView.h"


#import "WDBloodView.h"
#import "WDBaseLearnView.h"
#import "WDBossBloodView.h"

#import "WDMapSelectView.h"
#import "MapViewController.h"
#import "PassiveViewController.h"

@implementation GameViewController
{
    NSInteger  _index;
    NSInteger  _selectIndex; //测试用
    
    BaseScene *_selectScene;
    BOOL       _select;
   
    WDMoveOpeartionView *_moveView;
    WDSkillOperationView *_skillView;
    WDBloodView     *_bloodView;     //生命条
    WDBossBloodView *_bossBloodView; //BOSS血条
    WDBaseLearnView *_learnView;     //学习基础属性的面板
    WDMapSelectView *_mapView;       //地图选择
    
    UIImageView *_launchImageView;
    UIButton    *_playBtn;
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initGameView];
    
    _launchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImage *image = [UIImage imageNamed:@"iceBg"];
    _launchImageView.image = image;
    _launchImageView.userInteractionEnabled = YES;
    _launchImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_launchImageView];
    
    //240 160
    CGFloat width = 240 / 2.0;
    CGFloat height = 160 / 2.0;
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    _playBtn.center = CGPointMake(self.view.center.x, self.view.center.y);
    [_playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [_launchImageView addSubview:_playBtn];
}

- (void)initGameView
{
   
    //这里应该做异步处理<>
    WDTextureManager *textureManager = [WDTextureManager shareManager];
    [textureManager loadCommonTexture];
    
    //初始化人物属性
    [self initPersonProperty];
    
    //起始地图
    [self createBeginScene];
    
    //生命值
    [self createBloodView];
    
    //boss生命值
    [self createBossBloodView];
    
    //设置关联通知
    [self addObserver];
}

- (void)play{
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf btnAlphaAction];
    } completion:^(BOOL finished) {
        [weakSelf createMoveOperationView];
        [weakSelf createSkillOperationView];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf showOperationAction];
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)btnAlphaAction{
    _playBtn.alpha = 0;
    _launchImageView.alpha = 0;
}

- (void)showOperationAction
{
    _moveView.alpha  = 1;
    _skillView.alpha = 1;
    [_launchImageView removeFromSuperview];
}

#pragma mark 初始化人物属性
- (void)initPersonProperty
{
    PersonManager *manger = [PersonManager sharePersonManager];
    [manger initPersonProperty];
}

#pragma mark 起始scene
- (void)createBeginScene
{
    [self changeSceneAction:0];
}

#pragma mark 移动操作面板
- (void)createMoveOperationView
{
    //操作方向按键
    _moveView = [[WDMoveOpeartionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2.0, kScreenHeight)];
    //moveView.backgroundColor = [UIColor orangeColor];
    _moveView.alpha = 0;
    [self.view addSubview:_moveView];
    
    __weak typeof(self)weakSelf = self;
    //调用当前显示的SCENE人物移动方法
    [_moveView setMoveBlock:^(NSString *direction ,CGPoint position) {
        [weakSelf moveAction:direction position:position];
    }];
    
    [_moveView setStopBlock:^(NSString *direction) {
        [weakSelf stopAction:direction];
    }];
}

#pragma mark 技能面板
- (void)createSkillOperationView
{
    //技能攻击按键
    _skillView = [[WDSkillOperationView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0, 0, kScreenWidth / 2.0, kScreenHeight)];
    //skillView.backgroundColor = [UIColor cyanColor];
    _skillView.alpha = 0;
    [self.view addSubview:_skillView];
    
    __weak typeof(self)weakSelf = self;
    //人物释放技能
    [_skillView setSkillBlock:^(SkillType type) {
        [weakSelf skillAction:type];
    }];
    
    //人物普通攻击
    [_skillView setBigButtonBlock:^{
        [weakSelf bigButtonAction];
    }];
    
    //长按开始<准备蓄力阶段>
    [_skillView setLongAttackBeginBlock:^{
        [weakSelf longAttackBeginAction];
    }];
    
    //长按结束<蓄力结束攻击阶段>
    [_skillView setLongAttackEndBlock:^{
        [weakSelf longAttackEndAction];
    }];
}

#pragma mark 基础学习属性面板
- (void)createBaseLearnView
{
    _learnView = [[WDBaseLearnView alloc] initWithFrame:self.view.bounds];
    _learnView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_learnView];
    
    __weak typeof(self)weakSelf = self;
    [_learnView setBugWithTagBlock:^(NSInteger tag) {
        WDNotificationManager *manager = [WDNotificationManager shareManager];
        [manager postNotificationWithGoldCount:0];
        if (tag == 100) {
            [weakSelf setBlood];
        }else if(tag == 101){
            [weakSelf setAttack];
        }else if(tag == 102){
            [weakSelf setMiss];
        }
    }];
}

#pragma mark 被动技能选择面板
- (void)createPassiveView
{
    PassiveViewController *passiveVC = [PassiveViewController new];
    [self presentViewController:passiveVC animated:YES completion:^{
        NSLog(@"学习被动技能");
    }];
}

#pragma mark 地图选择面板
- (void)createMapSelectView
{
    MapViewController *mapVC = [MapViewController new];
    [self presentViewController:mapVC animated:YES completion:^{
        NSLog(@"地图MAP");
    }];
    
    __weak typeof(self)weakSelf = self;
    [mapVC setSelectSceneBlock:^(NSInteger sceneIndex) {
        [weakSelf setSceneIndex:sceneIndex];
    }];
    
    return;
    
//    _mapView = [[WDMapSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [self.view addSubview:_mapView];
//
//    [_mapView setSelectSceneBlock:^(NSInteger sceneIndex) {
//        [weakSelf setSceneIndex:sceneIndex];
//        [weakSelf removeMapView];
//    }];
//
//    [_mapView setCancleBlock:^{
//        [weakSelf removeMapView];
//    }];
}

- (void)removeMapView
{
    [_mapView removeFromSuperview];
    _mapView = nil;
}

#pragma mark 设置血量
- (void)setBlood{
    PersonManager *manager = [PersonManager sharePersonManager];
    WDNotificationManager *noManager = [WDNotificationManager shareManager];
    [noManager postNotificationWithAllBlood:manager.wdBlood nowBlood:manager.nowBlood changeCount:0];
}

#pragma mark 设置击力
- (void)setAttack
{
    PersonManager *manager = [PersonManager sharePersonManager];
    WDNotificationManager *noManager = [WDNotificationManager shareManager];
    [noManager postNotificationWithAttack:manager.wdAttack];
}

#pragma mark 设置闪避
- (void)setMiss
{
    PersonManager *manager = [PersonManager sharePersonManager];
    WDNotificationManager *noManager = [WDNotificationManager shareManager];
    [noManager postNotificationWithMissCount:manager.wdMiss];
}

#pragma mark 创建血量及状态面板
- (void)createBloodView
{
    
    _bloodView = [[WDBloodView alloc] initWithFrame:CGRectMake(TOP_MARIN, 0, 170, 60)];
    //_bloodView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bloodView];
}

#pragma mark 创建BOSS血条
- (void)createBossBloodView
{
    _bossBloodView = [[WDBossBloodView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 + kScreenWidth / 2.0 / 2.0, 0, kScreenWidth / 2.0 / 2.0, 60)];
    //_bossBloodView.backgroundColor = [UIColor whiteColor];
    _bossBloodView.hidden = YES;
    [self.view addSubview:_bossBloodView];
}

#pragma mark 人物操作相关****************
//猪脚移动
- (void)moveAction:(NSString *)direction position:(CGPoint )position
{
    [_selectScene moveActionWithDirection:direction position:position];
}

//猪脚停止移动
- (void)stopAction:(NSString *)direction
{
    [_selectScene stopMoveActionWithDirection:direction];
}

//大按钮点击
- (void)bigButtonAction
{
    [_selectScene attackAction:nil];
}

//蓄力攻击开始阶段
- (void)longAttackBeginAction
{
    [_selectScene longAttackBeginAction:nil];
}

//蓄力攻击结束阶段
- (void)longAttackEndAction
{
    [_selectScene longAttackEndAction:nil];
}

//猪脚释放技能
- (void)skillAction:(SkillType)type
{
    if (type == changeScene) {
        if (_selectScene.isDead) {
           
            [self changeSceneAction:0];
            //重置攻击力、血量等，去除额外加成
            PersonManager *manager = [PersonManager sharePersonManager];
            [manager initPersonProperty];
            
            
            [self setBlood];
            [self setAttack];
            [self setMiss];
        }
        
    }else{
        [_selectScene skillActionWithType:type];
    }
}

/** 如果死亡 直接切换到初始地图*/
#pragma mark -----死亡切换-----
- (void)diedIndex
{
    [_skillView reloadViewHidden:NO];
}


- (void)setSceneIndex:(NSInteger)sceneIndex{
    [self changeSceneAction:sceneIndex];
}

#pragma mark ----选择关卡----
- (void)changeSceneAction:(NSInteger)index
{
    _bossBloodView.hidden = YES;
    [_skillView reloadViewHidden:YES];

    
    //血量重新置满
    PersonManager *manager = [PersonManager sharePersonManager];
    manager.nowBlood = manager.wdBlood;
    [[WDNotificationManager shareManager]postNotificationWithAllBlood:manager.nowBlood nowBlood:manager.nowBlood changeCount:0];
    
    //清理之前释放的技能
    [_skillView clearAction];

    //关卡
    _index = index;
   
    
    //清理之前关卡
    [_selectScene clearAction];
//    [_selectScene removeAllActions];
//    [_selectScene removeAllChildren];
//    [_selectScene removeFromParent];
    
//    _selectScene = nil;
    __weak typeof(self)weakSelf = self;

    //创建新关卡
    [self createSceneWithIndex:_index];
    
    _select = YES;
    
    //加载完成回调block
    [_selectScene setLoadImageFinishBlock:^{
        [weakSelf pushScene];
    }];
    
    
    [_selectScene setDeadBlock:^(NSString *name) {
        [weakSelf diedIndex];
    }];
    
    [_selectScene setChangeSceneBlock:^(NSInteger index) {
        [weakSelf changeSceneAction:index];
    }];
    
    //解锁技能
    [_selectScene setUnlockSkillBlock:^(NSInteger index) {
        [weakSelf unlockSkillWithIndex:index];
    }];
    
    [_selectScene setLearnBaseBlock:^{
        [weakSelf createBaseLearnView];
    }];
    
    [_selectScene setSelectMapBlock:^{
        [weakSelf createMapSelectView];
    }];
    
    [_selectScene setSelectPassiveBlock:^{
        [weakSelf createPassiveView];
    }];
    
    //提前加载界面所需texture
    [_selectScene loadImageDataAction];
}

- (void)unlockSkillWithIndex:(NSInteger)index
{
    [_skillView unlockSkillWithIndex:index];
}

- (void)createSceneWithIndex:(NSInteger)index
{
    NSArray *sceneNameArr = @[@"BeginScene",@"WD1Scene",@"WD2Scene",@"WD3Scene",@"WD4Scene",@"Boss1Scene",@"WD5Scene",@"WD6Scene",@"WD7Scene",@"WD8Scene",@"Boss2Scene",@"WD9Scene",@"WD10Scene",@"WD11Scene",@"WD12Scene",@"Boss3Scene"];
    if (index >= sceneNameArr.count) {
        index = 0;
    }
    
    NSString *sceneName = sceneNameArr[index];
    Class class = NSClassFromString(sceneName);
    BaseScene *scene = [class nodeWithFileNamed:sceneName];
    scene.scaleMode  = SKSceneScaleModeAspectFill;
    _selectScene = scene;
}





- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



#pragma mark ----游戏地图和实际屏幕相关联的通知方法---
- (void)addObserver{
    
    //金币飞行动画
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goldFly) name:kNotificationGoldFly object:nil];
    
}

- (void)goldFly{
    
    WDSceneManager *sManager = [WDSceneManager shareSeting];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(sManager.moneyX / 2.0,kScreenHeight - sManager.moneyY / 2.0, 20, 20)];
    imageView.image = [WDTextureManager shareManager].moneyImage;
    [self.view addSubview:imageView];
    
    
    [UIView animateWithDuration:0.8 animations:^{
        imageView.origin = sManager.moneyImagePoint;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        WDNotificationManager *nManager = [WDNotificationManager shareManager];
        [nManager postNotificationWithGoldCount:1];
    }];
}

- (void)pushScene{
    _selectIndex ++ ;
    if (_selectIndex > 10) {
        _selectIndex = 0;
    }
    SKView *skView = (SKView *)self.view;
    //skView.showsPhysics = YES;
    SKTransition *tr = [SKTransition fadeWithDuration:1];
    //[skView presentScene:_selectScene transition:[WDActionTool changeSceneRandomWithTime:1 actionIndex:_selectIndex]];
    [skView presentScene:_selectScene transition:tr];
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

@end
