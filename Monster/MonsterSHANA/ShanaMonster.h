//
//  ShanaMonster.h
//  HotSchool
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface ShanaMonster : BaseMonsterNode<NodeBaseActionDelegate>



/** 翻滚跳跃攻击 */
- (void)skill1Action;

/** 切入技能 */
- (void)skill2Action;

/** 火刀跳跃技能攻击 */
- (void)skill3Action;


/**
 普通攻击

 @param type 攻击阶段
 */
- (void)attackActionWithType:(NSInteger)type;


/**
 技能攻击
 */
- (void)attackSkillAction;

- (void)beginMove;
@end
