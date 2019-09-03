//
//  AnimationSeagullNode.h
//  HotSchool
//
//  Created by 吴冬 on 2018/7/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface AnimationSeagullNode : BaseNode

+ (AnimationSeagullNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                             maxX:(CGFloat)maxX
                                             maxY:(CGFloat)maxY;

@end
