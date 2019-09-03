//
//  AnimationSquirrelNode.h
//  begin
//
//  Created by Mac on 2018/11/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface AnimationSquirrelNode : BaseNode
+ (AnimationSquirrelNode *)createNodeWithSuperNode:(BaseNode *)superNode
                                        personNode:(BaseNode *)personNode;
@end
