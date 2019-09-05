//
//  WDBaseModel.h
//  HotSchool
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDBaseModel : NSObject

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSArray <SKTexture *>*moveArr;
@property (nonatomic,copy)NSArray <SKTexture *>*stayArr;
@property (nonatomic,copy)NSArray <SKTexture *>*beAttackArr;
@property (nonatomic,copy)NSArray <SKTexture *>*winArr;
@property (nonatomic,copy)NSArray <SKTexture *>*missArr;

@property (nonatomic,strong)SKAction *arrowMusicAction;
@property (nonatomic,strong)SKAction *beAttackMusicAction;
@property (nonatomic,strong)SKAction *musicAttackAction; //怪物


@property (nonatomic,strong)SKAction *musicAttackAction1; //人物攻击
@property (nonatomic,strong)SKAction *musicAttackAction2;
@property (nonatomic,strong)SKAction *musicAttackAction3;
@property (nonatomic,strong)SKAction *musicAttackAction4;

@property (nonatomic,strong)SKAction *musicSkillAction1; //人物技能
@property (nonatomic,strong)SKAction *musicSkillAction2;
@property (nonatomic,strong)SKAction *musicSkillAction3;
@property (nonatomic,strong)SKAction *musicSkillAction4;

//相反操作状态
@property (nonatomic,copy)NSArray <SKTexture *>*debuffForQuestion;


/** 移动动画数组 name:如 person1_move_*/
- (void)setMoveArrWithPicName:(NSString *)movePicName
                        count:(NSInteger)count;

- (void)setStayArrWithPicName:(NSString *)stayPicName
                        count:(NSInteger)count;



/** 根据图片名字返回texture数组 */
- (NSMutableArray <SKTexture *>*)textureArrayWithName:(NSString *)name
                                                count:(NSInteger)count;



- (NSMutableArray <SKTexture *>*)questionArr;

- (void)setTextures;

@end
