//
//  WDTestSeting.h
//  begin
//
//  Created by Mac on 2018/10/29.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDSceneManager : NSObject
+ (WDSceneManager *)shareSeting;

@property (nonatomic,assign)CGFloat xMove;//地图相对于屏幕移动了多少
@property (nonatomic,assign)CGFloat moneyX;
@property (nonatomic,assign)CGFloat moneyY;
@property (nonatomic,assign)CGPoint moneyImagePoint; //金币Label横坐标
@property (nonatomic,assign)NSInteger selectIndex; //当前关卡


/** 场景天气 */
- (void)setSceneWeatherWithSuperNode:(BaseNode *)node;
/** 死亡场景动画 */
- (void)deadSceneAnimation:(BaseNode *)node
                    bgNode:(BaseNode *)bgNode;

@end
