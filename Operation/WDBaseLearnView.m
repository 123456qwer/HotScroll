//
//  WDBaseLearnView.m
//  HotSchool
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBaseLearnView.h"

@implementation WDBaseLearnView
{
    CGFloat _nowAttackPay;
    CGFloat _nowBloodPay;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"learnBaseImage"];
        [self addSubview:imageView];
        
        //176 84
        CGFloat cancelBtnWidth = 176 / 2.0;
        CGFloat cancelBtnHeight = 84 / 2.0;
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - cancelBtnWidth, 20, cancelBtnWidth, cancelBtnHeight)];
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        
        [self createSkillView];
        
        UIImageView *moneyImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
        moneyImageV.image = [WDTextureManager shareManager].moneyImage;
        [self addSubview:moneyImageV];
        
        PersonManager *manager = [PersonManager sharePersonManager];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(moneyImageV.right + 10, 20, 1300, 50)];
        label.text = [NSString stringWithFormat:@"%0.0lf",manager.wdMoney];
        label.textColor = [UIColor whiteColor];
        //label.backgroundColor = [UIColor orangeColor];
        label.font = [UIFont boldSystemFontOfSize:30];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 456;
        [self addSubview:label];
    }
    
    return self;
}

- (void)createSkillView
{
    CGFloat cancelBtnHeight = 84 / 2.0;
    NSArray *imageArr = @[@"bloodImage",@"attackImage",@"miss",@"bloodImage"];
    NSArray *textArr  = @[@"+ 10 blood",@"+ 5 attack",@"+ 1 miss percent",@"+ 10 blood"];
    NSArray *moneyArr = @[@"150",@"200",@"1000",@"150"];
    
    CGFloat page = (kScreenHeight - (30 + 20 + cancelBtnHeight) - 50 * 4) / 4.0;
    CGFloat x = (kScreenWidth - (50 + 200 + 50 + 100 + 142 + 10 + 5 + 5 + 20)) / 2.0;
    for (int i = 0; i < 4; i ++) {
        CGFloat y = 30 + cancelBtnHeight + 20 + i * 50 + i * page;
        UIImageView *bloodImageV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 50, 50)];
        bloodImageV.image = [UIImage imageNamed:imageArr[i]];
        [self addSubview:bloodImageV];
        
        
        UILabel *bloodLabel = [[UILabel alloc] initWithFrame:CGRectMake(bloodImageV.right + 10, y, 200, 50)];
        bloodLabel.text = textArr[i];
        bloodLabel.textColor = [UIColor whiteColor];
        //bloodLabel.backgroundColor = [UIColor orangeColor];
        bloodLabel.font = [UIFont boldSystemFontOfSize:30];
        if (i == 2) {
            bloodLabel.font = [UIFont boldSystemFontOfSize:25];
        }
        bloodLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bloodLabel];
        
        UIImageView *moneyImage = [[UIImageView alloc] initWithFrame:CGRectMake(bloodLabel.right + 5, y, 50, 50)];
        moneyImage.image = [WDTextureManager shareManager].moneyImage;
        [self addSubview:moneyImage];
        
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyImage.right + 5, y, 100, 50)];
        payLabel.text = moneyArr[i];
        payLabel.textAlignment = NSTextAlignmentCenter;
        //payLabel.backgroundColor = [UIColor orangeColor];
        payLabel.font = [UIFont systemFontOfSize:30.f];
        payLabel.textColor = [UIColor whiteColor];
        [self addSubview:payLabel];
        
        //142 44
        UIButton *learnBtn = [[UIButton alloc] initWithFrame:CGRectMake(payLabel.right + 20, y, 142, 44)];
        learnBtn.tag = 100 + i;
        [learnBtn addTarget:self action:@selector(learnAction:) forControlEvents:UIControlEventTouchUpInside];
        [learnBtn setImage:[UIImage imageNamed:@"learn"] forState:UIControlStateNormal];
        [self addSubview:learnBtn];
    }
}

- (void)cancelAction:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)learnAction:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PersonManager *manager = [PersonManager sharePersonManager];

    if (sender.tag == 100) {
        //增加血量
        if (manager.wdMoney >= 150) {
            manager.wdMoney -= 150;
            manager.wdBlood += 10;
            manager.nowBlood = manager.wdBlood;
            [defaults setFloat:manager.wdMoney forKey:kMoneyKey];
            [defaults setFloat:manager.wdBlood forKey:kBloodKey];
            
            UILabel *moneyLabel = [self viewWithTag:456];
            moneyLabel.text = [NSString stringWithFormat:@"%0.0lf",manager.wdMoney];
            if (_bugWithTagBlock) {
                _bugWithTagBlock(sender.tag);
            }
            
        }else{
            [WDCalculateTool showAlertWithText:@"NO MONEY" btnText:@"SURE"];
        }
        
    }else if(sender.tag == 101){
        //增加攻击力
        if (manager.wdMoney >= 200) {
            manager.wdMoney -= 200;
            manager.wdAttack += 5;
            
            [defaults setFloat:manager.wdMoney forKey:kMoneyKey];
            [defaults setFloat:manager.wdAttack forKey:kAttackKey];
            
            UILabel *moneyLabel = [self viewWithTag:456];
            moneyLabel.text = [NSString stringWithFormat:@"%0.0lf",manager.wdMoney];
            if (_bugWithTagBlock) {
                _bugWithTagBlock(sender.tag);
            }
        }else{
            [WDCalculateTool showAlertWithText:@"NO MONEY" btnText:@"SURE"];
        }
        
    }else if(sender.tag == 102){
        //增加闪避概率
        if (manager.wdMoney >= 1000) {
            manager.wdMoney -= 1000;
            manager.wdMiss += 1;
            
            [defaults setFloat:manager.wdMoney forKey:kMoneyKey];
            [defaults setFloat:manager.wdMiss forKey:kAttackKey];
            
            UILabel *moneyLabel = [self viewWithTag:456];
            moneyLabel.text = [NSString stringWithFormat:@"%0.0lf",manager.wdMoney];
            if (_bugWithTagBlock) {
                _bugWithTagBlock(sender.tag);
            }
        }else{
            [WDCalculateTool showAlertWithText:@"NO MONEY" btnText:@"SURE"];
        }
        
    }
    
}



@end
