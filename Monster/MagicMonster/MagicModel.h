//
//  MagicModel.h
//  begin
//
//  Created by Mac on 2018/11/5.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicModel : WDBaseModel
@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,strong)SKTexture *shadowTexture;
@property (nonatomic,copy)NSArray <SKTexture *>*meteoriteArr1;
@property (nonatomic,copy)NSArray <SKTexture *>*meteoriteArr2;

@end
