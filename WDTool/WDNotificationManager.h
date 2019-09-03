//
//  WDNotificationManager.h
//  begin
//
//  Created by Mac on 2018/11/9.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, AttackBtnType) {
    
    attack = 0,
    talk,
    click
    
};
@interface WDNotificationManager : NSObject

+ (WDNotificationManager *)shareManager;


/** 根据type变换攻击按钮的图片 */
- (void)postNotificationForAttackType:(AttackBtnType)type;
/** 改变血量 */
- (void)postNotificationWithAllBlood:(CGFloat)allBlood
                            nowBlood:(CGFloat)nowBlood
                         changeCount:(CGFloat)count;
/** 改变攻击力 */
- (void)postNotificationWithAttack:(CGFloat)attack;
/** 改变金钱 */
- (void)postNotificationWithGoldCount:(NSInteger)count;
/** 金币飞行动画 */
- (void)postNotificationForGoldFly;
/** 改变闪避值 */
- (void)postNotificationWithMissCount:(CGFloat)count;
/** 更换角色的通知 */
- (void)postNotificationForChangePerson;
/** 召唤小怪通知 */
- (void)postNotificationForCallMonster;

@end
