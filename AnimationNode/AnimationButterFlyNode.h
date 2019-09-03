//
//  AnimationButterFlyNode.h
//  HotSchool
//
//  Created by Mac on 2018/8/7.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface AnimationButterFlyNode : BaseNode

/**
 maxX、y:当前坐标
 */
+ (AnimationButterFlyNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                               maxX:(CGFloat)maxX
                                               maxY:(CGFloat)maxY;
@end
