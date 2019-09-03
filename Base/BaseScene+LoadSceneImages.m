//
//  BaseScene+LoadSceneImages.m
//  begin
//
//  Created by Mac on 2019/5/14.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BaseScene+LoadSceneImages.h"

@implementation BaseScene (LoadSceneImages)
/** 提前加载地图资源 */
- (void)loadImageDataAction
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        [self.textureManager loadSceneWithClassName:NSStringFromClass([self class])];
        //加载主角
        [self loadPersonNode];
       
        //避免第一次加载label卡顿
        NSString *fontName = @"Noteworthy";
        NSString *str = [NSString stringWithFormat:@"-%0.0lf",0.1];
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:fontName];
        label.text = str;
        [self addChild:label];
        
        //[label removeFromParent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //结束加载，通知视图更新
            if (self.loadImageFinishBlock) {
                self.loadImageFinishBlock();
            }
        });
         
    });
}

@end
