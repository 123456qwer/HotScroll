//
//  SniperModel.h
//  begin
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "WDBaseModel.h"

@interface SniperModel : WDBaseModel
@property (nonatomic,copy)NSArray <SKTexture *>*attack1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*blastArr;
@property (nonatomic,strong)SKTexture *star;
@property (nonatomic,strong)SKTexture *circle;
@property (nonatomic,strong)SKAction *musicSniperLine;
@end
