//
//  BaseScene+CreateMonster.h
//  begin
//
//  Created by Mac on 2019/4/8.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BaseScene.h"


@interface BaseScene (CreateMonster)
/** 创建射手怪物 */
- (ShooterMonster *)createShooterMonster;

/** 创建盗贼怪物 */
- (ThiefMonster *)createThiefMonster;

/** 创建巫师(闪电) */
- (WizardMonster *)createWizardMonster;

/** 创建巫师(火球) */
- (MagicMonster *)createMagicMonster;

/** 创建阻击手 */
- (SniperMonster *)createSniperMonster;

/** 创建野蛮人 */
- (SavageMonster *)createSavageMonster;

/** 天使怪 */
- (AngelMonster *)createAngleMonster;

/** 大刀兵 */
- (BigBladeMonster *)createBigBladeMonster;

/** 弓手2 */
- (BowMonster *)createBowMonster;

/** 弓手3 */
- (Bow2Monster *)create2BowMonster;

/** 枪兵 */
- (SpearMonster *)createSpearMonster;

/** 枪兵2 */
- (Spear2Monster *)createSpear2Monster;

/** 叉兵 */
- (ForkMonster *)createForkMonster;

/** 斧兵 */
- (AXEMonster *)createAXEMonster;

/** 加农兵 */
- (CannonMonster *)createCannonMonster;

/** BOSS3 */
- (Boss3Monster *)createBoss3Monster;


/** 创建随机的敌人 length:不能创建之前没有出现过的怪物  */
- (void)createRandomMonster:(NSInteger)length;

@end


