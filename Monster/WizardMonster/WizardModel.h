//
//  WizardModel.h
//  begin
//
//  Created by Mac on 2018/12/12.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBaseModel.h"

@interface WizardModel : WDBaseModel
@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*flashArr;
@property (nonatomic,strong)SKTexture *shadowTexture;
@property (nonatomic,strong)SKTexture *cloudTexture;
@property (nonatomic,strong)SKAction *musicFlashAction;

@end
