//
//  WDTestSeting.m
//  begin
//
//  Created by Mac on 2018/10/29.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDSceneManager.h"
static WDSceneManager *shareSeting = nil;
@implementation WDSceneManager

+ (WDSceneManager *)shareSeting
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareSeting == nil) {
            shareSeting = [[WDSceneManager alloc] init];
        }
    });
    
    return shareSeting;
}




- (void)setSceneWeatherWithSuperNode:(BaseNode *)node
{
   // int random = arc4random() % 2;
  
  
}



//雪天
- (void)snow:(BaseNode *)node
{
    SKEmitterNode *snow = [SKEmitterNode nodeWithFileNamed:@"Snow"];
    snow.position = CGPointMake(0, 750);
    snow.zPosition = 100000;
    snow.particlePositionRange = CGVectorMake(node.size.width * 2.0, 0);
    snow.particleBirthRate = 50;
    [node addChild:snow];
    
}

//雨天
- (void)rain:(BaseNode *)node{
    SKEmitterNode *rain = [SKEmitterNode nodeWithFileNamed:@"Rain"];
    rain.position = CGPointMake(0, 750);
    rain.zPosition = 100000;
    rain.particlePositionRange = CGVectorMake(node.size.width * 2.0, 0);
    rain.particleBirthRate = 1000;
    [node addChild:rain];
}

- (void)deadSceneAnimation:(BaseNode *)node
                    bgNode:(BaseNode *)bgNode
{
    SKEmitterNode *deadFire = [SKEmitterNode nodeWithFileNamed:@"DeadFire"];
    deadFire.position = node.position;
    deadFire.zPosition = 100000;
    [bgNode addChild:deadFire];
}

@end
