//
//  WDSkillView.h
//  HotSchool
//
//  Created by Mac on 2018/7/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDSkillView : UIView

@property (nonatomic,copy)void (^beginBlock)(void);
@property (nonatomic,copy)void (^longAttackEndBlock)(void);//长按攻击方法
@property (nonatomic,copy)void (^longAttackBeginBlock)(void);//长按开始方法


@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,assign)BOOL isAttackBtn;
@property (nonatomic,assign)BOOL isReturnBtn;
@property (nonatomic,assign)BOOL canUse;
@property (nonatomic,strong)UIImageView *lockImageV;

/**
 设置技能时间
 */
- (void)setTimeLabel:(NSInteger)times;

- (void)clearAction;

- (void)setGesture;

- (void)unlockAnimation;

@end
