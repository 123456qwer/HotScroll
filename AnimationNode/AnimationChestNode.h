//
//  AnimationChestNode.h
//  begin
//
//  Created by Mac on 2018/11/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface AnimationChestNode : BaseNode
+ (AnimationChestNode *)createChestNode:(BaseNode *)superNode
                               position:(CGPoint)point;

/** 打开箱子方法 */
- (void)setRandomBuff;

@end
