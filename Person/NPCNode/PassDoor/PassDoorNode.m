//
//  PassDoorNode.m
//  begin
//
//  Created by Mac on 2018/11/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "PassDoorNode.h"

@implementation PassDoorNode

- (void)initActionWithModel:(WDBaseModel *)model
{
//    [self realBackGroundWithColor:[UIColor blackColor]];
    //[self physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(60 * 1.5, 50 * 1.5) position:CGPointMake(0, 135)];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60 * 1.5, 50 * 1.5) center:CGPointMake(0, 115)];
    
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.collisionBitMask = 0;
    body.contactTestBitMask = MONSTER_CONTACT;
    
    self.physicsBody = body;
    self.name = @"passDoor";
}

@end
