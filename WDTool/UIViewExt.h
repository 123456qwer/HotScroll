//
//  UIViewExt.h
//  iOSLibrary
//
//  Created by yihang zhuang on 2/11/11.
//  Copyright 2011 hangmou. All rights reserved.
//

#import <Foundation/Foundation.h>

/** view的常用位置设置方法 */
@interface UIView (UIViewExt)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property(nonatomic) CGFloat left;
//非向下取整
@property(nonatomic) CGFloat leftNF;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property(nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property(nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property(nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property(nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property(nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property(nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property(nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property(nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property(nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property(nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property(nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property(nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property(nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property(nonatomic) CGSize size;

- (void)removeAllSubviews;

/**
 * Add by yuemeng 2015.3.19
   height增量
 */
- (void)addWidth:(CGFloat)width;
- (void)addHeight:(CGFloat)height;
/// X轴偏移
- (void)addOriginX:(CGFloat)offsetX;
/// Y轴偏移
- (void)addOriginY:(CGFloat)offsetY;
///固定X轴
- (void)setOriginX:(CGFloat)offsetX;
///固定Y轴
- (void)setOriginY:(CGFloat)offsetY;
///设定起始Y和高度
- (void)setOriginY:(CGFloat)offsetY height:(CGFloat)height;
/** 切圆角 */
- (void)clipCornerToBounds:(CGFloat)cornerRadius;

@end
