//
//  ShooterModel.h
//  HotSchool
//
//  Created by 吴冬 on 2018/7/29.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBaseModel.h"

@interface ShooterModel : WDBaseModel
@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,copy)SKTexture *beAttackTexture;
@property (nonatomic,copy)SKTexture *arrowTexture;
@end
