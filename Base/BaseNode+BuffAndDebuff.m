//
//  BaseNode+BuffAndDebuff.m
//  begin
//
//  Created by Mac on 2019/4/12.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BaseNode+BuffAndDebuff.h"

@implementation BaseNode (BuffAndDebuff)

- (void)setBuff
{
    PersonManager *pManager = [PersonManager sharePersonManager];
    [pManager initPersonEffectWithPerson:self];
}

@end
