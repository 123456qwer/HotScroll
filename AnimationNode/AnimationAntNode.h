//
//  AnimationAntNode.h
//  HotSchool
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface AnimationAntNode : BaseNode
+ (AnimationAntNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                         maxX:(CGFloat)maxX
                                         maxY:(CGFloat)maxY;
@end
