//
//  WDBossBloodView.m
//  HotSchool
//
//  Created by Mac on 2018/8/29.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBossBloodView.h"

@implementation WDBossBloodView
{
    UIView  *_bloodView; //总血量
    UIView  *_showBloodView; //当前血量
    UILabel *_bloodLabel;
    CGFloat  _allBlood;//总血量
    CGFloat  _nowBlood;//当前血量
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reduceBloodNotification:) name:kNotificationForBossReduceBloodAction object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setAllBloodNotification:) name:kNotificationForSetBossBloodAction object:nil];

        [self _createBloodView];
    }
    return self;
}

- (void)setAllBloodNotification:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    _allBlood = [dic[@"blood"]floatValue];
    _nowBlood = _allBlood;
    self.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForBossReduceBloodAction object:@{@"blood":@(0)}];
}

- (void)_createBloodView
{
    _bloodView = [[UIView alloc] initWithFrame:CGRectMake(5, (60 - 40) / 2.0, self.width - 10, 40)];
    _bloodView.backgroundColor = [UIColor blackColor];
    _bloodView.layer.masksToBounds = YES;
    _bloodView.layer.cornerRadius = 20.f;
    _bloodView.alpha = 0.4;
    _bloodView.layer.borderWidth = 1.f;
    _bloodView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_bloodView];
    
    _showBloodView = [[UIView alloc] initWithFrame:CGRectMake(5 + 1, (60 - 40) / 2.0 + 1, self.width - 10 - 2, 38)];
    _showBloodView.backgroundColor = UICOLOR_RGB(200, 10, 10, 0.7);
    _showBloodView.layer.masksToBounds = YES;
    _showBloodView.layer.cornerRadius = 19;
    
    [self addSubview:_showBloodView];
}

- (void)reduceBloodNotification:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    CGFloat reduceBlood = [dic[@"blood"]floatValue];
    _nowBlood -= reduceBlood;
    if (_nowBlood < 0) {
        _nowBlood = 0;
    }
    
    NSString *text = [NSString stringWithFormat:@"%0.0lf/%0.0lf",_nowBlood,_allBlood];
    
    _bloodLabel.text = text;
    //170 - 45
    
    CGFloat percent = _nowBlood / _allBlood;
    CGFloat width = (self.width - 10 - 2) * percent;
    __weak UIView *bloodV = _showBloodView;
    [UIView animateWithDuration:0.2 animations:^{
        bloodV.size = CGSizeMake(width, 38);
    }];
    
}

@end
