//
//  AngelMonster.h
//  HotSchool
//
//  Created by Mac on 2018/10/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface AngelMonster : BaseMonsterNode<NodeBaseActionDelegate,MonsterActionDelegate>
@property (nonatomic,assign)BOOL starMove;
@end
