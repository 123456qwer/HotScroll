//
//  BaseScene+CreateMonster.m
//  begin
//
//  Created by Mac on 2019/4/8.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "BaseScene+CreateMonster.h"

typedef NS_ENUM(NSInteger ,MonsterType) {
    SHOOTER_MONSTER      = 0,
    THIEF_MONSTER        = 1,
    WIZARD_MONSTER       = 2,
    MAGIC_MONSTER        = 3,
    SNIPER_MONSTER       = 4,
    SAVAGE_MONSTER       = 5,
    ANGEL_MONSTER        = 6,
    BIGBLADE_MONSTER     = 7,
    BOW_MONSTER          = 8,
    BOW2_MONSTER         = 9,
    SPEAR_MONSTER        = 10,
    SPEAR2_MONSTER       = 11,
    
};

@implementation BaseScene (CreateMonster)
- (ShooterMonster *)createShooterMonster
{
    if (self.shooterNum > self.nextSceneNum) {
        return nil;
    }
    
    ShooterModel *model = [self.textureManager shooterModel];
    ShooterMonster *_shooterMonster = [[ShooterMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"shooter_%d",self.shooterNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_shooterMonster];
    [self addAllMonsterCount];
    
    return _shooterMonster;
}


- (ThiefMonster *)createThiefMonster
{
    if (self.thiefNum > self.nextSceneNum) {
        return nil;
    }
    
    ThiefModel *model = [self.textureManager thiefModel];
    ThiefMonster *_thiefMonster = [[ThiefMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"thief_%d",self.thiefNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_thiefMonster];
    [self addAllMonsterCount];

    return _thiefMonster;
    
}


- (WizardMonster *)createWizardMonster
{
    if (self.wizardNum > self.nextSceneNum) {
        return nil;
    }
    
    WizardModel *model = [self.textureManager wizardModel];
    WizardMonster *_monster = [[WizardMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"wizard_%d",self.wizardNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];

    return _monster;
}

- (MagicMonster *)createMagicMonster
{
    if (self.magicNum > self.nextSceneNum) {
        return nil ;
    }
    MagicModel *model = [self.textureManager magicModel];
    MagicMonster *_magicMonster = [MagicMonster spriteNodeWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"magic_%d",self.magicNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_magicMonster];
    [self addAllMonsterCount];

    return _magicMonster;
}

- (SniperMonster *)createSniperMonster
{
    if (self.sniperNum > self.nextSceneNum) {
        return nil;
    }
    
    SniperModel *model = [self.textureManager sniperModel];
    SniperMonster *_sniperMonster = [SniperMonster spriteNodeWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"sniper_%d",self.sniperNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_sniperMonster];
    [self addAllMonsterCount];

    return _sniperMonster;
}

- (SavageMonster *)createSavageMonster
{
    if (self.savageNum > self.nextSceneNum) {
        return nil;
    }
    
    SavageModel *model = [self.textureManager savageModel];
    SavageMonster *_savageMonster = [[SavageMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"savage_%d",self.savageNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_savageMonster];
    [self addAllMonsterCount];

    return _savageMonster;
}

- (AngelMonster *)createAngleMonster
{
    if (self.angelNum > self.nextSceneNum) {
        return nil;
    }
    AngelModel *model = [self.textureManager angelModel];
    AngelMonster *_angelMonster = [[AngelMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"angel_%d",self.angelNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_angelMonster];
    [self addAllMonsterCount];
    
    return _angelMonster;
}

- (BigBladeMonster *)createBigBladeMonster
{
    if (self.bigBladeNum > self.nextSceneNum) {
        return nil;
    }
    BigBladeModel *model = [self.textureManager bladeModel];
    BigBladeMonster *_bladeMonster = [[BigBladeMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"blade_%d",self.bigBladeNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_bladeMonster];
    [self addAllMonsterCount];
    
    return _bladeMonster;
}

- (BowMonster *)createBowMonster
{
    if (self.bowNum > self.nextSceneNum) {
        return nil;
    }
    BowModel *model = [self.textureManager bowModel];
    BowMonster *_monster = [[BowMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"bowbow_%d",self.bowNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    return _monster;
}

- (Bow2Monster *)create2BowMonster
{
    if (self.bow2Num > self.nextSceneNum) {
        return nil;
    }
    Bow2Model *model = [self.textureManager bow2Model];
    Bow2Monster *_monster = [[Bow2Monster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"bowbow2_%d",self.bow2Num ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    
    return _monster;
}

- (SpearMonster *)createSpearMonster
{
    if (self.spearNum > self.nextSceneNum) {
        return nil;
    }
    SpearModel *model = [self.textureManager spearModel];
    SpearMonster *_monster = [[SpearMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"spear_%d",self.spearNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    
    return _monster;
}


- (Spear2Monster *)createSpear2Monster
{
    Spear2Model *model = [self.textureManager spear2Model];
    Spear2Monster *_monster = [[Spear2Monster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"spear_%d",self.spear2Num ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    
    return _monster;
}

- (ForkMonster *)createForkMonster
{
    ForkModel *model = [self.textureManager forkModel];
    ForkMonster *_monster = [[ForkMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"forkfork_%d",self.forkNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    
    return _monster;
}

- (AXEMonster *)createAXEMonster
{
    AXEModel *model = [self.textureManager axeModel];
    AXEMonster *_monster = [[AXEMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"axeaxe_%d",self.axeNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    
    return _monster;
}


- (CannonMonster *)createCannonMonster
{
    CannonModel *model = [self.textureManager cannonModel];
    CannonMonster *_monster = [[CannonMonster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"cannon_%d",self.axeNum ++];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    
    return _monster;
}

- (Boss3Monster *)createBoss3Monster
{
    Boss3Model *model = [self.textureManager boss3Model];
    Boss3Monster *_monster = [[Boss3Monster alloc] initWithTexture:model.moveArr[0]];
    NSString *nameStr = [NSString stringWithFormat:@"boss3"];
    [self initMonsterWithModel:model name:nameStr monster:_monster];
    [self addAllMonsterCount];
    
    return _monster;
}

- (void)addAllMonsterCount
{
    //self.allMonsterNum ++;
}

- (void)initMonsterWithModel:(WDBaseModel *)model
                        name:(NSString *)nameStr
                     monster:(BaseMonsterNode *)monsterNode
{
    [monsterNode setPersonNode:self.personNode];
    [monsterNode initActionWithModel:model];
    
    monsterNode.isAttackIng = YES;
    monsterNode.alpha = 0;
    monsterNode.name = nameStr;
    [self.bgNode addChild:monsterNode];
    
    __weak typeof(self)weakSelf = self;
    [monsterNode setDeadBlock:^(NSString *name) {
        [weakSelf.sceneDelegate removeMonsterWithName:name];
    }];
    
    [self randomBeginAction:monsterNode name:nameStr];
}


- (void)randomBeginAction:(BaseMonsterNode *)monseterNode
                     name:(NSString *)nameStr
{
    if (arc4random() % 2 == 0) {
        [self setSmokeWithMonster:monseterNode name:nameStr];
    }else{
        [self setLightWithMonster:monseterNode name:nameStr];
    }
}

//烟雾出场
- (void)setSmokeWithMonster:(BaseMonsterNode *)monsterNode name:(NSString *)nameStr
{
    
    BaseNode *node = [BaseNode spriteNodeWithTexture:self.textureManager.smokeArr[0]];
    
    node.position = monsterNode.position;
    node.zPosition = 10000;
    node.name = @"smoke";
    node.xScale = 1.5;
    node.yScale = 1.5;
    [self.bgNode addChild:node];
    SKAction *lightA = [SKAction animateWithTextures:self.textureManager.smokeArr timePerFrame:0.075];
    SKAction *alphaA = [SKAction fadeAlphaTo:0.2 duration:self.textureManager.smokeArr.count * 0.075];
    SKAction *r = [SKAction removeFromParent];
    SKAction *s = [SKAction sequence:@[[SKAction group:@[lightA,alphaA]],r]];
    
    [monsterNode runAction:[SKAction fadeAlphaTo:1 duration:self.textureManager.smokeArr.count * 0.075]];
    [monsterNode setPhySicsBodyNone];
    [self.monsterDic setObject:monsterNode forKey:nameStr];

    [node runAction:s completion:^{
        monsterNode.isAttackIng = NO;
        [monsterNode setPhy];
    }];
}


//紫色灯光出场
- (void)setLightWithMonster:(BaseMonsterNode *)monsterNode name:(NSString *)nameStr
{
    
    BaseNode *node = [BaseNode spriteNodeWithTexture:self.textureManager.lightArr[0]];
    
    node.position = monsterNode.position;
    node.zPosition = 10000;
    node.name = @"light";
    [self.bgNode addChild:node];
    SKAction *lightA = [SKAction animateWithTextures:self.textureManager.lightArr timePerFrame:0.05];
    SKAction *s = [SKAction sequence:@[lightA]];
    
    [monsterNode runAction:[SKAction fadeAlphaTo:1 duration:self.textureManager.lightArr.count * 0.05]];
    [monsterNode setPhySicsBodyNone];
    [self.monsterDic setObject:monsterNode forKey:nameStr];

    [node runAction:s completion:^{
        [node runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.5],[SKAction removeFromParent]]]];
        monsterNode.isAttackIng = NO;
        [monsterNode setPhy];
    }];
}

- (void)createRandomMonster:(NSInteger)length
{
    
    NSArray *actionNameArr = @[@"createShooterMonster",@"createThiefMonster",@"createWizardMonster",@"createMagicMonster",@"createSniperMonster",@"createSavageMonster",@"createAngleMonster",@"createBigBladeMonster",@"createBowMonster",@"create2BowMonster",@"createSpearMonster",@"createSpear2Monster"];
    
    if (length > actionNameArr.count) {
        length = actionNameArr.count;
    }
    
    NSInteger index = arc4random() % length;
    //index = 2;
    
    index = [self limitMonsterWithIndex:index];

    NSString *method = actionNameArr[index];
    SEL action = NSSelectorFromString(method);
    if ([self respondsToSelector:action]) {
        [self performSelector:action withObject:nil afterDelay:0];
    }
}

- (NSInteger)limitMonsterWithIndex:(MonsterType)index
{
    
    switch (index) {
        case THIEF_MONSTER:
            {
                if (self.thiefNum >= 2) {
                    return 0;
                }
            }
            break;
            case WIZARD_MONSTER:
        {
            if (self.wizardNum >= 1) {
                return 0;
            }
        }
            break;
            case MAGIC_MONSTER:
        {
            if (self.magicNum >= 2) {
                return 0;
            }
        }
            break;
            case SAVAGE_MONSTER:
        {
            if (self.savageNum >= 1) {
                return 0;
            }
        }
            break;
            case ANGEL_MONSTER:
        {
            if (self.angelNum >= 2) {
                return 0;
            }
        }
            break;
            
        default:
            break;
    }
    
    return index;
}

@end
