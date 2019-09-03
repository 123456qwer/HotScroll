//
//  Boss3Monster.h
//  begin
//
//  Created by Mac on 2019/6/5.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BaseNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface Boss3Monster : BaseMonsterNode<NodeBaseActionDelegate,MonsterActionDelegate>
@property (nonatomic,assign)BOOL canMiss;
@end

NS_ASSUME_NONNULL_END
