//
//  ShanaModel.h
//  HotSchool
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShanaModel : WDBaseModel
//person2_attack4_1
@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack2Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack3Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack4Arr;
@property (nonatomic,copy)SKTexture *beAttackTexture;
@property (nonatomic,copy)SKTexture *beAttack;

//跳跃攻击1
@property (nonatomic,copy)NSArray <SKTexture *>*skill1Arr;
//隐身切入
@property (nonatomic,copy)NSArray <SKTexture *>*skill2Arr;
//跳跃攻击火刀
@property (nonatomic,copy)NSArray <SKTexture *>*skill3Arr;



@end
