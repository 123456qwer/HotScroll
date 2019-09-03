//
//  WDCalculateTool.h
//  HotSchool
//
//  Created by 吴冬 on 2018/5/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDCalculateTool : NSObject


/** 计算人物移动和方向 */
+ (NSDictionary *)calculateDirection:(CGPoint)point1
                               point:(CGPoint)point2
                               speed:(CGFloat)speed;


/** 计算人物的最大位移空间 */
+ (CGPoint)calculateMaxMoveXAndY:(CGPoint)movePoint
                            maxX:(CGFloat)maxX
                            maxY:(CGFloat)maxY
                      personSize:(CGSize)size;


/**
 判断是否可以躲闪攻击

 @param percent 几率
 */
+ (BOOL)missAttack:(CGFloat)percent;


/** 判断人物是否在怪物左边 */
+ (BOOL)personIsLeft:(CGPoint)personPoint
                 monsterPoint:(CGPoint)monsterPoint;


/**
 根据图片生成图片数据集<行走、攻击等>

 @param line 行
 @param arrange 列
 @param imageSize 图片总像素大小
 @return arr
 */
+ (NSArray *)arrWithLine:(NSInteger)line
                      arrange:(NSInteger)arrange
                    imageSize:(CGSize)imageSize
                subImageCount:(NSInteger)count
                        image:(UIImage *)image;

+ (void)showAlertWithText:(NSString *)text
                  btnText:(NSString *)btnText;
@end
