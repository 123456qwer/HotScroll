//
//  Person1Model.h
//  HotSchool
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBaseModel.h"

@interface Person1Model : WDBaseModel

@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack2Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack3Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack4Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack5Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attackFastArr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill2Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill1LightArr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill3LightArr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill2LightArr;
@property (nonatomic,copy)NSArray <SKTexture *>*jumpArr;

@property (nonatomic,copy)NSArray <SKTexture *>*skill4LightArr;

@property (nonatomic,copy)NSArray <SKTexture *>*defenseArr;
@property (nonatomic,copy)SKTexture *beAttack;


@property (nonatomic,strong)SKAction *attack1MusicAction;
@property (nonatomic,strong)SKAction *attack2MusicAction;
@property (nonatomic,strong)SKAction *attack3MusicAction;
@property (nonatomic,strong)SKAction *attack4MusicAction;


@property (nonatomic,strong)SKAction *skill4MusicAction;
@property (nonatomic,strong)SKAction *skill1MusicAction;
@property (nonatomic,strong)SKAction *skill2MusicAction;


@end
