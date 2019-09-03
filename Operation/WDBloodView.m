//
//  WDBloodView.m
//  HotSchool
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBloodView.h"

@implementation WDBloodView
{
    UILabel *_bloodLabel;
    UIView  *_bloodView; //总血量
    UIView  *_showBloodView; //当前血量
    UIImageView *_bloodImageView;
    
    UIImageView *_attackImageView; //攻击力
    UILabel     *_attackLabel;     //攻击力数值
    UIImageView *_speedImageView;  //移动
    UILabel     *_speedLabel;      //移动数值
    UIImageView *_missImageView;   //闪避
    UILabel     *_missLabel;       //闪避数值
    UIImageView *_moneyImageView;  //金钱
    UILabel     *_moneyLabel;      //金钱数值
    
    UIImageView *_bgImageV;
    
    BOOL         _isChangeMoneyAnimation; //判断金钱动画是否停止
    BOOL         _isChangeBloodAnimation; //判断金钱动画是否停止

    NSUserDefaults *_defaults;
}

#pragma mark 通知方法，更改攻击力
- (void)changeAttack:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    CGFloat attack = [dic[@"attack"] floatValue];
    _attackLabel.text = [NSString stringWithFormat:@"%0.0lf",attack];
    _attackLabel.size = CGSizeMake([self widthForLabel:_attackLabel.text], 20);
    
    [self restFrame];
    
}

#pragma mark 通知方法，更改血量
- (void)changeBlood:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    CGFloat nowBlood = [dic[@"now"]floatValue];
    CGFloat allBlood = [dic[@"all"]floatValue];
    if (nowBlood < 0) {
        nowBlood = 0;
    }
    NSString *text = [NSString stringWithFormat:@"%0.0lf/%0.0lf",nowBlood,allBlood];
    
    _bloodLabel.text = text;
    //170 - 45
    
    CGFloat percent = nowBlood / allBlood;
    CGFloat width = (170 - 45 - 2) * percent;
    __weak UIView *bloodV = _showBloodView;
    [UIView animateWithDuration:0.2 animations:^{
        bloodV.size = CGSizeMake(width, 18);
    }];
    
    if (!_isChangeBloodAnimation) {
        _isChangeBloodAnimation = YES;
        __weak UIImageView *bloodImageV = _bloodImageView;
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            bloodImageV.frame = CGRectMake(5 - 10, (60 - 20) / 2.0 + 10 - 10 , 40, 40);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                bloodImageV.frame = CGRectMake(5, (60 - 20) / 2.0 + 10, 20, 20);
            } completion:^(BOOL finished) {
                [weakSelf bloodAnimationEnd];
            }];
        }];
    }
    
    [self restFrame];

}


- (void)changeMiss:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    CGFloat miss = [dic[@"miss"] floatValue];
    _missLabel.text = [NSString stringWithFormat:@"%0.0lf%%",miss];
    _missLabel.size = CGSizeMake([self widthForLabel:_missLabel.text], 20);
    [self restFrame];
}

#pragma mark 通知方法，掉钱
- (void)changeMoney:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    NSInteger gold = [dic[@"gold"]integerValue];
    PersonManager *manager = [PersonManager sharePersonManager];
    manager.wdMoney += gold;
    NSString *moneyStr = [NSString stringWithFormat:@"%0.0lf",manager.wdMoney];
    _moneyLabel.size = CGSizeMake([self widthForLabel:moneyStr], 20);
    _moneyLabel.text = moneyStr;
    [_defaults setFloat:manager.wdMoney forKey:kMoneyKey];
    
    if (!_isChangeMoneyAnimation) {
        _isChangeMoneyAnimation = YES;
        __weak UIImageView *moneyImageV = _moneyImageView;
        __weak UILabel *la = _missLabel;
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            moneyImageV.frame = CGRectMake(la.right + 5 - 10, 5 - 10, 40, 40);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                moneyImageV.frame = CGRectMake(la.right + 5, 5, 20, 20);
            } completion:^(BOOL finished) {
                [weakSelf moneyAnimationEnd];
            }];
        }];
    }
    
}

- (void)bloodAnimationEnd
{
    _isChangeBloodAnimation = NO;
}

- (void)moneyAnimationEnd
{
    _isChangeMoneyAnimation = NO;
}



#pragma mark 添加通知
//涉及到的状态面板，全部用通知来实现
- (void)addNotificationObserver
{
    //金币掉落
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMoney:) name:kNotificationForDropMoneyAction object:nil];
    //改变血量
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBlood:) name:kNotificationChangeBloodCount object:nil];
    //改变攻击力
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAttack:) name:kNotificationChangeAttackCount object:nil];
    //改变闪避值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMiss:) name:kNotificationChangeMissCount object:nil];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        _defaults = [NSUserDefaults standardUserDefaults];
        
        [self addNotificationObserver];
        
        [self _createBloodImageView];
        [self _createBloodView];
        [self _createStausLabel];
        [self _createBloodLabel];
    }
    
    return self;
}



#pragma mark 构建方法
- (CGFloat)widthForLabel:(NSString *)text
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(0,20) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (void)restFrame
{
    _speedImageView.origin = CGPointMake(_attackLabel.right + 5, 5);
    _speedLabel.origin = CGPointMake(_speedImageView.right + 5, 5);
    
    _missImageView.origin  = CGPointMake(_speedLabel.right + 5, 5);
    _missLabel.origin      = CGPointMake(_missImageView.right + 5, 5);

    _moneyImageView.origin = CGPointMake(_missLabel.right + 5, 5);
    _moneyLabel.origin = CGPointMake(_moneyImageView.right + 5, 5);
    if (IS_IPHONEX) {
        [WDSceneManager shareSeting].moneyImagePoint = CGPointMake(_moneyImageView.origin.x + 22.f, _moneyImageView.origin.y);
    }else{
        [WDSceneManager shareSeting].moneyImagePoint = _moneyImageView.origin;
    }
}

//170总长
- (void)_createBloodImageView
{
    _bloodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, (60 - 20) / 2.0 + 10, 20, 20)];
    _bloodImageView.image = [UIImage imageNamed:@"bloodImage"];
    [self addSubview:_bloodImageView];
}

- (void)_createBloodView
{
    _bloodView = [[UIView alloc] initWithFrame:CGRectMake(_bloodImageView.right + 5, (60 - 20) / 2.0 + 10, 170 - 45, 20)];
    _bloodView.backgroundColor = [UIColor blackColor];
    _bloodView.layer.masksToBounds = YES;
    _bloodView.layer.cornerRadius = 10.f;
    _bloodView.alpha = 0.4;
    _bloodView.layer.borderWidth = 1.f;
    _bloodView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_bloodView];
    
    _showBloodView = [[UIView alloc] initWithFrame:CGRectMake(_bloodImageView.right + 5 + 1, (60 - 20) / 2.0 + 10 + 1, 170 - 45 - 2, 18)];
    _showBloodView.backgroundColor = UICOLOR_RGB(200, 10, 10, 0.7);
    _showBloodView.layer.masksToBounds = YES;
    _showBloodView.layer.cornerRadius = 9.f;
 
    [self addSubview:_showBloodView];
    
}



- (void)_createStausLabel
{
    PersonManager *manager = [PersonManager sharePersonManager];
    _attackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + 5, 5, 20, 20)];
    _attackImageView.image = [UIImage imageNamed:@"attackImage"];
    [self addSubview:_attackImageView];
    
    NSString *attackStr = [NSString stringWithFormat:@"%0.0lf",manager.wdAttack];
    CGFloat width1 = [self widthForLabel:attackStr];
    
    _attackLabel = [[UILabel alloc] initWithFrame:CGRectMake(_attackImageView.right + 5, 5, width1, 20)];
    _attackLabel.text = attackStr;
    _attackLabel.font = [UIFont systemFontOfSize:13.f];
    _attackLabel.textColor = [UIColor orangeColor];
    _attackLabel.textAlignment = NSTextAlignmentLeft;
    //_attackLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:_attackLabel];
    
    _speedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_attackLabel.right, 5, 20, 20)];
    _speedImageView.image = [UIImage imageNamed:@"speedImage"];
    [self addSubview:_speedImageView];
    
    NSString *speedStr = [NSString stringWithFormat:@"%0.0lf",manager.wdSpeed];
    CGFloat width2 = [self widthForLabel:speedStr];
    
    _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(_speedImageView.right + 5, 5, width2, 20)];
    _speedLabel.text = speedStr;
    _speedLabel.font = [UIFont systemFontOfSize:13.f];
    _speedLabel.textColor = [UIColor orangeColor];
    _speedLabel.textAlignment = NSTextAlignmentLeft;
    //_speedLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:_speedLabel];
    
    
    _missImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _missImageView.image = [UIImage imageNamed:@"miss"];
    [self addSubview:_missImageView];
    
    
    NSString *missStr = [NSString stringWithFormat:@"%0.0lf%%",manager.wdMiss];
    CGFloat width3 = [self widthForLabel:missStr];
    
    _missLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width3, 20)];
    _missLabel.text = missStr;
    _missLabel.font = [UIFont systemFontOfSize:13.f];
    _missLabel.textColor = [UIColor orangeColor];
    _missLabel.textAlignment = NSTextAlignmentLeft;
    //_moneyLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:_missLabel];
    
    
    _moneyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_speedLabel.right + 5, 5, 20, 20)];
    _moneyImageView.image = [WDTextureManager shareManager].moneyImage;
    [self addSubview:_moneyImageView];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%0.0lf",manager.wdMoney];
    CGFloat width4 = [self widthForLabel:moneyStr];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width4, 20)];
    _moneyLabel.text = moneyStr;
    _moneyLabel.font = [UIFont systemFontOfSize:13.f];
    _moneyLabel.textColor = [UIColor orangeColor];
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    //_moneyLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:_moneyLabel];
    
    [self restFrame];
}

- (void)_createBloodLabel
{
    PersonManager *manager = [PersonManager sharePersonManager];
    _bloodLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bloodImageView.right + 5 + 170 - 45 - 100 - 5, (60 - 20) / 2.0 + 10, 100, 20)];
    _bloodLabel.text = [NSString stringWithFormat:@"%0.0lf/%0.0lf",manager.wdBlood,manager.wdBlood];
    _bloodLabel.textColor = [UIColor whiteColor];
    _bloodLabel.font = [UIFont systemFontOfSize:11.f];
    _bloodLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_bloodLabel];
}







- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
