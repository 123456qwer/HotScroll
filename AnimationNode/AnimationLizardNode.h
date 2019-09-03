//
//  AnimationLizardNode.h
//  begin
//
//  Created by Mac on 2018/11/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface AnimationLizardNode : BaseNode
+ (AnimationLizardNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                               maxX:(CGFloat)maxX
                                               maxY:(CGFloat)maxY;
@end
