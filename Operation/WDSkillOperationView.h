//
//  WDSkillOperationView.h
//  HotSchool
//
//  Created by Mac on 2018/7/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDSkillOperationView : UIView

@property (nonatomic,copy)void (^fireBlock)(void);
@property (nonatomic,copy)void (^skillBlock)(SkillType type);

@property (nonatomic,copy)void (^bigButtonBlock)(void);
@property (nonatomic,copy)void (^longAttackEndBlock)(void);//长按攻击方法
@property (nonatomic,copy)void (^longAttackBeginBlock)(void);//长按开始方法
/**
 清理之前释放的技能时间
 */
- (void)clearAction;
/** 死亡返回选项 */
- (void)reloadViewHidden:(BOOL)isHidden;

- (void)unlockSkillWithIndex:(NSInteger)index;



@end
