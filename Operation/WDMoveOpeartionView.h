//
//  WDMoveOpeartionView.h
//  HotSchool
//
//  Created by 吴冬 on 2018/5/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMoveOpeartionView : UIView
@property (nonatomic ,copy)void (^moveBlock)(NSString *direction,CGPoint point);
@property (nonatomic ,copy)void (^stopBlock)(NSString *direction);

@end
