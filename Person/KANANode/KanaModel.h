//
//  KanaModel.h
//  begin
//
//  Created by Mac on 2019/2/12.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "WDBaseModel.h"

@interface KanaModel : WDBaseModel
@property (nonatomic,copy)NSArray <SKTexture *>*skill1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill2Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill3Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill4Arr;

@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*attack2Arr;
@property (nonatomic,copy)SKTexture *beAttack;


@end
