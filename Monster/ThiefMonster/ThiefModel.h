//
//  ThiefModel.h
//  HotSchool
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBaseModel.h"

@interface ThiefModel : WDBaseModel
@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*hiddenArr;
@property (nonatomic,strong)SKTexture *dropTexture;//隐身攻击多次流汗动画
@end
