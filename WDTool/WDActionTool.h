//
//  WDActionTool.h
//  HotSchool
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BaseNode.h"
#import "BaseScene.h"
@interface WDActionTool : NSObject
/**
 人物移动动画
 @param moveArr 动画图片数组
 @param time 每张的时间间隔
 */
+ (SKAction *)moveActionWithMoveArr:(NSArray <SKTexture *>*)moveArr
                               time:(NSTimeInterval)time;


/**
 扣除血量字数动画

 @param node  被击中的node<一般label添加到她的父视图上>
 @param count 扣除的血量
 */
+ (void)reduceBloodLabelAnimation:(BaseNode *)node
                      reduceCount:(CGFloat)count;

/**
 扣除血量字数动画<技能版>
 
 @param node  被击中的node<一般label添加到她的父视图上>
 @param count 扣除的血量
 */
+ (void)reduceBloodLabelAnimation:(BaseNode *)node
                      reduceCount:(CGFloat)count
                          isSkill:(BOOL)isSkill;

/** 被攻击动画效果 */
+ (void)demageAnimation:(BaseNode *)node
                  point:(CGPoint)point
                  scale:(CGFloat)scale
              demagePic:(NSString *)imageName;

/**
 箭矢被技能挡开
 */
+ (void)arrowAnimation:(BaseNode *)node;



/** 切屏随机动画方法 */
+ (SKTransition *)changeSceneRandomWithTime:(NSTimeInterval)times
                                actionIndex:(NSInteger)index;



/** 死亡方法 */
+ (SKAction *)deadAnimationWithAttackDirection:(BOOL)attackerIsLeft
                                       deadArr:(NSArray <SKTexture *>*)deadArr
                                          node:(BaseNode *)deadNode;



/** 被击倒方法 */
+ (SKAction *)downAnimation:(BOOL)attackerIsLeft
                    downArr:(NSArray <SKTexture *>*)downArr
                       node:(BaseNode *)downNode
             circlePosition:(CGPoint)point;


/** 掉落金币的动画效果 */
+ (void)dropMoneyAnimation:(BaseNode *)superNode
                  position:(CGPoint)point
                      gold:(NSInteger)gold;

/**
 显示died字样
 */
+ (void)showDiedText:(SKScene *)scene;


/** 闪躲攻击 */
+ (void)missAnimation:(BaseNode *)node;

#pragma mark buffAction
/** 问号 */
+ (void)debuffForQuestion:(BaseNode *)superNode
                 textures:(NSArray <SKTexture *>*)arr
                 position:(CGPoint)point;


/** 结余 */
+ (void)showPassLabelWithScene:(BaseScene *)scene
;
@end
