//
//  ThiefMonster.h
//  HotSchool
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface ThiefMonster : BaseMonsterNode<NodeBaseActionDelegate,MonsterActionDelegate>
- (void)thiefMissAction;
@end
