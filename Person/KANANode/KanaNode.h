//
//  KanaNode.h
//  begin
//
//  Created by Mac on 2019/2/12.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BaseNode.h"

@interface KanaNode : BaseNode<NodeBaseActionDelegate>
- (void)setPersonNode:(BaseNode *)personNode;
@end
