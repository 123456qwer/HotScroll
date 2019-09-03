//
//  WDBaseLearnView.h
//  HotSchool
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBaseLearnView : UIView
@property (nonatomic,copy)void (^bugWithTagBlock)(NSInteger tag);
@end
