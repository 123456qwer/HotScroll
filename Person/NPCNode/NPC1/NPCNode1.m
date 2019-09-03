//
//  NPCNode1.m
//  HotSchool
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "NPCNode1.h"
#import "NPCModel1.h"
@implementation NPCNode1
{
    NPCModel1 *_model;
    SKSpriteNode *_blackCircleNode;
    BOOL _isStand;
}

- (void)initActionWithModel:(WDBaseModel *)model
{
    [self setStand:YES];
    _model = (NPCModel1 *)model;
    [self createBlackCircle];

    _blackCircleNode = self.blackCircleNode;
    _blackCircleNode.position = CGPointMake(8,  - 53);
    self.name = @"NPC1";

    //[self physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(60, 100) position:CGPointMake(0, 0)];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60 * 1.3, 100 * 1.3) center:CGPointMake(0, 0)];
    
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.collisionBitMask = 0;
    body.contactTestBitMask = SHANA_CONTACT;
    
    self.physicsBody = body;
}

- (void)stayAction
{
    if (!_isStand) {
        return;
    }
    self.alpha = 1;
    [self removeAllActions];
    SKAction *stayA = [SKAction animateWithTextures:_model.sitArr timePerFrame:0.15];
    BaseNode *butterNode = (BaseNode *)[self childNodeWithName:@"butterFly"];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(0, 0) duration:0.15 * _model.sitArr.count];
    [butterNode runAction:moveAction];
    __weak typeof(self)weakSelf = self;
    [self runAction:stayA completion:^{
        [weakSelf setStand:NO];
    }];
}

- (void)setStand:(BOOL)isStand
{
    _isStand = isStand;
}

- (void)standAction
{
    [self setStand:YES];
    [self removeAllActions];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = _model.sitArr.count - 1; i >= 0; i--) {
        SKTexture *texture = _model.sitArr[i];
        [arr addObject:texture];
    }
    
    SKAction *action = [SKAction animateWithTextures:arr timePerFrame:0.15];
    SKAction *action2 = [SKAction animateWithTextures:_model.learnArr timePerFrame:0.15];
    SKAction *seq = [SKAction sequence:@[action,action2]];
    
    SKAction *moveB = [SKAction moveToY:self.position.y + 5 duration:0.8];
    SKAction *moveA = [SKAction moveToY:self.position.y duration:0.8];
    SKAction *seqMove = [SKAction sequence:@[moveB,moveA]];
    
    SKAction *alpha1 = [SKAction fadeAlphaTo:0.7 duration:0.8];
    SKAction *alpha2 = [SKAction fadeAlphaTo:1.0 duration:0.8];
    SKAction *seqAlpha = [SKAction sequence:@[alpha1,alpha2]];
    
    SKAction *grou  = [SKAction group:@[seqMove,seqAlpha]];
    SKAction *rep = [SKAction repeatActionForever:grou];
   
    SKAction *seq2 = [SKAction sequence:@[seq,rep]];
    
    
   

    BaseNode *butterNode = (BaseNode *)[self childNodeWithName:@"butterFly"];
    
    CGFloat y = self.size.height / 2.0 - butterNode.size.height / 2.0 - 5;
    CGFloat x = self.size.width / 2.0 * - 1 + 20;
 
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake(x, y) duration:0.15 * 5 ];
    
    [butterNode runAction:moveAction];
    [self runAction:seq2 completion:^{
        
    }];
}

- (void)clearAction
{
    [super clearAction];
}

@end
