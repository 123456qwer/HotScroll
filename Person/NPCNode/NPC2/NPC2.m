//
//  NPC2.m
//  HotSchool
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "NPC2.h"
@implementation NPC2
{
    SKSpriteNode *_blackCircleNode;
    BOOL _isStandAction;
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    self.model = model;

    if ([model isKindOfClass:[ShanaModel class]]) {
        [self createMissNode];
    }
    
    [self stayAction];
    [self createBlackCircle];
    
    _blackCircleNode = self.blackCircleNode;
    _blackCircleNode.position = CGPointMake(3, - 30);
    
    //[self physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(60, 100) position:CGPointMake(0, 0)];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60 * 2, 100 * 2) center:CGPointMake(0, 0)];
    
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.collisionBitMask = 0;
    body.contactTestBitMask = SHANA_CONTACT;
    
    self.physicsBody = body;
}

#pragma mark 原地呆着方法
- (void)stayAction
{
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger count = self.model.winArr.count;
    for (NSInteger i = count - 1; i >= 0 ; i --) {
        SKTexture *texture = self.model.winArr[i];
        [arr addObject:texture];
    }
    SKAction *action = [SKAction animateWithTextures:arr timePerFrame:0.2];
    [self runAction:action completion:^{
        [self removeAllActions];
        [self runAction:[WDActionTool moveActionWithMoveArr:self.model.stayArr time:0.5]];
    }];
    
  
    
}

- (void)standAction
{
    _isStandAction = YES;
    [self removeAllActions];
    SKAction *action = [SKAction animateWithTextures:self.model.winArr timePerFrame:0.2];
    [self runAction:action];
}

- (void)setPerson1Model:(Person1Model *)model
{
    [self removeMissNode];
    
    self.name = @"person";
    self.model = model;
    _blackCircleNode.position = CGPointMake(3,  - 35);
    
    SKTexture *texture = model.stayArr[0];
    self.size = CGSizeMake(texture.size.width * 2.0, texture.size.height * 2.0);

    [self stayAction];
}


- (void)setShanaModel:(ShanaModel *)model
{
    self.name = @"shana";
    self.model = model;

    [self createMissNode];

    _blackCircleNode.position = CGPointMake(3, - 30);
    
    SKTexture *texture = model.stayArr[0];
    self.size = CGSizeMake(texture.size.width * 2.0, texture.size.height * 2.0);
    [self stayAction];
}

- (void)setKanaModel:(KanaModel *)model
{
    
    [self removeMissNode];
    
    self.name = @"kana";
    self.model = model;
    _blackCircleNode.position = CGPointMake(0, - 35);
    
    SKTexture *texture = model.stayArr[0];
    self.size = CGSizeMake(texture.size.width * 2.1, texture.size.height * 2.1);
    
    [self stayAction];

}

- (void)removeMissNode
{
    BaseNode *missNode = (BaseNode *)[self childNodeWithName:@"miss"];
    if (missNode) {
        [missNode removeFromParent];
    }
}

- (void)createMissNode
{
    BaseNode *missNode = (BaseNode *)[self childNodeWithName:@"miss"];
    if (!missNode) {
        BaseNode *missNode = [BaseNode spriteNodeWithTexture:self.model.missArr[0]];
        missNode.name = @"miss";
        missNode.alpha = 0;
        missNode.position = CGPointMake(10, 0);
        [self addChild:missNode];
        
        SKAction *action = [SKAction animateWithTextures:self.model.missArr timePerFrame:0.1];
        //5 * 8 * 0.1; MISS UP 时间
        SKAction *rep = [SKAction repeatAction:action count:6];
        SKAction *alpha0 = [SKAction fadeAlphaTo:0 duration:5 * 8 * 0.1];
        SKAction *alpha1 = [SKAction fadeAlphaTo:1 duration:8 *0.1];
        SKAction *seq1 = [SKAction sequence:@[alpha1,alpha0]];
        SKAction *gr = [SKAction group:@[rep,seq1]];
        SKAction *repp = [SKAction repeatActionForever:gr];
        [missNode runAction:repp];
    }
}

@end
