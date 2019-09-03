//
//  Person1Node.h
//  HotSchool
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"
#import "Person1Model.h"
@interface Person1Node : BaseNode<NodeBaseActionDelegate>
- (void)attack5Skill;
- (void)defenseEndAndAttack;//蓄力攻击或者防御后的攻击

- (void)longAttackBegin;
- (void)longAttackEnd;

@end
