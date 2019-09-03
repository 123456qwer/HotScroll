//
//  AnimationChestNode.m
//  begin
//
//  Created by Mac on 2018/11/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AnimationChestNode.h"
typedef NS_ENUM(NSInteger, addType)
{
    addGold = 0,
    addAttack,
    addBlood,
    addMiss,
    fireBlade,
};

@implementation AnimationChestNode
+ (AnimationChestNode *)createChestNode:(BaseNode *)superNode
                               position:(CGPoint)point
{
    WDTextureManager *manager = [WDTextureManager shareManager];
    AnimationChestNode *chestNode = [AnimationChestNode spriteNodeWithTexture:manager.woodChestArr[0]];
    chestNode.position = point;
    chestNode.zPosition = 650 - chestNode.position.y;
    chestNode.xScale = 1.5;
    chestNode.yScale = 1.5;
    chestNode.name = @"chest";
    [superNode addChild:chestNode];
    
    //[chestNode physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(50, 25) position:CGPointMake(0, 30)];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50 * 1.5, 25 * 1.5) center:CGPointMake(0, 30)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    //body.categoryBitMask = 0;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = 0;
    chestNode.physicsBody = body;
    
    SKEmitterNode *magicN = [SKEmitterNode nodeWithFileNamed:@"Magic"];
    [chestNode addChild:magicN];
    magicN.particleColor = [UIColor redColor];
    return chestNode;
}

- (void)setRandomBuff
{
    WDTextureManager *manager = [WDTextureManager shareManager];
    SKAction *textureAnimation = [SKAction animateWithTextures:manager.woodChestArr timePerFrame:0.1];
    SKAction *hiddenAction = [SKAction fadeAlphaTo:0 duration:1.5];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[hiddenAction,removeAction]];
    
    addType random_1 = arc4random() % 5;
    random_1 = fireBlade;
    [self setPhySicsBodyNone];

    __weak typeof(self)weakSelf = self;
    if (random_1 == addGold) {
        
        [self runAction:textureAnimation completion:^{
            [weakSelf runAction:seq];
            [weakSelf createAnimationWithImage:manager.moneyImage name:@"gold"];
        }];
        
    }else if(random_1 == addAttack){
     
        [self runAction:textureAnimation completion:^{
            [weakSelf runAction:seq];
            [weakSelf createAnimationWithImage:[UIImage imageNamed:@"attackImage"] name:@"attack"];
        }];
        
    }else if(random_1 == addBlood){

        [self runAction:textureAnimation completion:^{
            [weakSelf runAction:seq];
            [weakSelf createAnimationWithImage:[UIImage imageNamed:@"blood"] name:@"blood"];
        }];
        
    }else if(random_1 == fireBlade){
       
        [self runAction:textureAnimation completion:^{
            [weakSelf runAction:seq];
            [weakSelf createFireBladeNode];
        }];
        
    }else{
        [self runAction:textureAnimation completion:^{
            [weakSelf runAction:seq];
            [weakSelf createAnimationWithImage:[UIImage imageNamed:@"miss"] name:@"miss"];
        }];
    }
}

- (void)createFireBladeNode{
    BaseNode *blade = [BaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"blade"]]];
    blade.position = self.position;
    blade.zPosition = 10000;
    blade.xScale = 0.7;
    blade.yScale = 0.7;
    blade.name = @"喷射火焰剑";
    [blade setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, blade.size.width - 40, blade.size.height - 40)];
    SKAction *move1 = [SKAction moveToY:blade.position.y + 50 duration:0.7];
    SKAction *move2 = [SKAction moveToY:blade.position.y  duration:0.7];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    
    SKAction *rep = [SKAction repeatActionForever:seq];
    [blade runAction:rep];
    [self.parent addChild:blade];
}

- (void)createAnimationWithImage:(UIImage *)image
                            name:(NSString *)name

{
    BaseNode *moneyNode = [BaseNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
    moneyNode.zPosition = 100;
    moneyNode.xScale = 0.5;
    moneyNode.yScale = 0.5;
    moneyNode.alpha = 0;
    moneyNode.name = name;
    [self addChild:moneyNode];
    
    SKAction *scaleAction = [SKAction scaleTo:1 duration:0.5];
    SKAction *moveAction  = [SKAction moveToY:50 duration:0.5];
    SKAction *alphaAction = [SKAction fadeAlphaTo:1 duration:0.2];
    SKAction *gro = [SKAction group:@[alphaAction,scaleAction,moveAction]];
    
    SKAction *scaleAction2 = [SKAction scaleTo:0 duration:0.3];
    SKAction *remo = [SKAction removeFromParent];
    
    SKAction *seq = [SKAction sequence:@[gro,scaleAction2,remo]];
    __weak typeof(self)weakSelf = self;
    [moneyNode runAction:seq completion:^{
        if ([name isEqualToString:@"attack"]) {
            [weakSelf addAttack];
        }else if([name isEqualToString:@"gold"]){
            [weakSelf addGold];
        }else if([name isEqualToString:@"miss"]){
            [weakSelf addMiss];
        }else if([name isEqualToString:@"blood"]){
            [weakSelf addBlood];
        }
    }];
}

//增加血量
- (void)addBlood
{
    PersonManager *personManager = [PersonManager sharePersonManager];
    NSInteger count = arc4random() % 10 + 10;
    WDNotificationManager *notificationManager = [WDNotificationManager shareManager];
    personManager.wdBlood += count;
    [notificationManager postNotificationWithAllBlood:personManager.wdBlood nowBlood:personManager.wdBlood changeCount:0];
}

//增加攻击力
- (void)addAttack
{
    PersonManager *personManager = [PersonManager sharePersonManager];
    NSInteger count = arc4random() % 10 + 5;
    WDNotificationManager *notificationManager = [WDNotificationManager shareManager];
    personManager.wdAttack += count;
    [notificationManager postNotificationWithAttack:personManager.wdAttack];
    
}

//增加金钱
- (void)addGold
{
    WDNotificationManager *notificationManager = [WDNotificationManager shareManager];
    NSInteger count = arc4random() % 5 + 5;
    [notificationManager postNotificationWithGoldCount:count];
}

//增加MISS几率
- (void)addMiss
{
    PersonManager *personManager = [PersonManager sharePersonManager];
    WDNotificationManager *notificationManager = [WDNotificationManager shareManager];
    NSInteger count = arc4random() % 5 + 6;
    personManager.wdMiss = count;
    [notificationManager postNotificationWithMissCount:personManager.wdMiss];
}

@end
