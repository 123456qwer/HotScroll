//
//  WDMapSelectView.h
//  begin
//
//  Created by Mac on 2018/11/6.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMapSelectView : UIView<UIScrollViewDelegate>
@property (nonatomic,copy)void (^selectSceneBlock)(NSInteger sceneIndex);
@property (nonatomic,copy)void (^cancleBlock)(void);
@end
