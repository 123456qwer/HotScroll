//
//  GameScene.h
//  HotSchool
//
//  Created by 吴冬 on 2018/5/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseScene.h"
@interface GameScene : BaseScene

- (void)moveActionWithDirection:(NSString *)direction
                       position:(CGPoint)point;
@end
