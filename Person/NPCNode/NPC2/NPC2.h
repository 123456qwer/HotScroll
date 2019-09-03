//
//  NPC2.h
//  HotSchool
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "BaseNode.h"
#import "Person1Model.h"
#import "ShanaModel.h"

@interface NPC2 : BaseNode

- (void)standAction;
- (void)setPerson1Model:(Person1Model *)model;
- (void)setShanaModel:(ShanaModel *)model;
- (void)setKanaModel:(KanaModel *)model;

@property (nonatomic,assign)NSInteger index;

@end
