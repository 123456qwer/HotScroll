//
//  PersonManager.m
//  HotSchool
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "PersonManager.h"
#import "BaseNode.h"
static PersonManager *manager = nil;

@implementation PersonManager
{
    int _missAddCount;
    NSTimer *_missTimer;
}
+ (PersonManager *)sharePersonManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[PersonManager alloc] init];
        }
    });
    
    return manager;
}

- (void)setShana{
    _skill1Name = @"shana_skill_1";
    _skill2Name = @"shana_skill_2";
    _skill3Name = @"shana_skill_3";
    _skill4Name = @"shana_skill_4";
}

- (void)setPerson
{
    _skill1Name = @"person1_skill1";
    _skill2Name = @"person1_skill2";
    _skill3Name = @"person1_skill3";
    _skill4Name = @"person1_skill4";
}

- (void)setKana
{
    _skill1Name = @"kana_skill1";
    _skill2Name = @"kana_skill2";
    _skill3Name = @"kana_skill3";
    _skill4Name = @"kana_skill4";
}

- (void)initPersonProperty{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults floatForKey:kAttackKey] == 0) {
        [defaults setFloat:20.f forKey:kAttackKey];
    }
    
    if ([defaults floatForKey:kBloodKey] == 0) {
        [defaults setFloat:150.f forKey:kBloodKey];
    }
    
    if ([defaults floatForKey:kSpeedKey] == 0) {
        [defaults setFloat:7.f forKey:kSpeedKey];
    }
    
    if ([defaults floatForKey:kMissKey] == 0) {
        [defaults setFloat:5.f forKey:kMissKey];
    }
    
    if ([defaults integerForKey:kSceneIndex] == 0) {
        [defaults setInteger:0 forKey:kSceneIndex];
    }
    
    if (![defaults objectForKey:kNameKey]) {
        [defaults setObject:@"person" forKey:kNameKey];
    }
    
    [defaults setFloat:200.f forKey:kBloodKey];
    [defaults setFloat:20.f forKey:kAttackKey];

    //self.name = @"kana";
    self.name = [defaults objectForKey:kNameKey];
    self.wdSpeed  = [defaults floatForKey:kSpeedKey];
    self.wdAttack = [defaults floatForKey:kAttackKey];
    self.wdBlood  = [defaults floatForKey:kBloodKey];
    self.wdMoney  = [defaults floatForKey:kMoneyKey];
    self.wdMiss   = [defaults floatForKey:kMissKey];
    self.passive_miss = [defaults boolForKey:kPassive_miss];
    self.passive_fireBlade = [defaults boolForKey:kPassive_fireBlade];
    self.passive_suckBlood = [defaults boolForKey:kPassive_suckBlood];
    
    if ([self.name isEqualToString:@"shana"]) {
        [manager setShana];
    }else if([self.name isEqualToString:@"person"]){
        [manager setPerson];
    }else if([self.name isEqualToString:@"kana"]){
        [manager setKana];
    }
    
 
}

- (void)initPersonEffectWithPerson:(BaseNode *)personNode
{
    _personNode = personNode;
    //火刀
    if (self.passive_fireBlade) {
        [self setFireBlade];
    }
    
    //吸血
    if (self.passive_suckBlood) {
        
    }
    
    //闪避
    if (self.passive_miss) {
        [self setMiss];
    }
}

#pragma mark ----火焰剑----
- (void)setFireBlade
{
    [self createFireBladeNodeWithPerson:_personNode];
}

- (void)removeFireBlade{
    SKEmitterNode *eNode = (SKEmitterNode *)[_personNode.parent childNodeWithName:@"火焰剑攻击"];
    [eNode removeFromParent];
}

- (void)createFireBladeNodeWithPerson:(BaseNode *)personNode{
    SKEmitterNode *eNode = [SKEmitterNode nodeWithFileNamed:@"Fire"];
    eNode.position = personNode.position;
    eNode.name = @"火焰剑攻击";
    eNode.zPosition = 10;
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:5.f];
    body.contactTestBitMask = 0;
    body.categoryBitMask = 0;
    body.collisionBitMask = 0;
    body.affectedByGravity = NO;
    eNode.physicsBody = body;
    [personNode.parent addChild:eNode];
}

#pragma mark ----火焰剑相关----
+ (void)fireBladeActionWithPerson:(BaseNode *)personNode;
{
    if (![PersonManager sharePersonManager].passive_fireBlade) {
        return;
    }
    
    SKEmitterNode *node = (SKEmitterNode *)[personNode.parent childNodeWithName:@"火焰剑攻击"];
    if (node && node.physicsBody.categoryBitMask == 0 && ([personNode.name isEqualToString:@"person"]||[personNode.name isEqualToString:@"shana"]||[personNode.name isEqualToString:@"kana"])) {
        
        SKAction *move1 = [SKAction moveToX:personNode.position.x + 600 * personNode.directon duration:0.5];
        SKAction *move2 = [SKAction moveToX:personNode.position.x duration:0.5];
        node.physicsBody.categoryBitMask = 1;
        [PersonManager sharePersonManager].isFireAttackIng = YES;
        [node runAction:[SKAction sequence:@[move1,move2]] completion:^{
            node.physicsBody.categoryBitMask = 0;
        }];
 
    }
}

+ (void)fireBladeMove:(BaseNode *)personNode
{
    SKEmitterNode *node = (SKEmitterNode *)[personNode.parent childNodeWithName:@"火焰剑攻击"];
    if (node) {
        //右边
        CGFloat x = 0;
        CGFloat y = 0;
       
        if ([manager.name isEqualToString:@"person"]){
            y = personNode.position.y - 60;
            x = personNode.position.x - personNode.directon * 80;
        }
        
        if ([manager.name isEqualToString:@"kana"]){
            y = personNode.position.y + 20;
            x = personNode.position.x - personNode.directon;
        }
        
        //夏娜玩家
        if ([manager.name isEqualToString:@"shana"]) {
            if (personNode.isMoveIng) {
                y = personNode.position.y - 50;
                x = personNode.position.x - personNode.directon * 45;
            }else{
                y = personNode.position.y + 25;
                x = personNode.position.x + personNode.directon * 55;
            }
           
        }
        

        node.position = CGPointMake(x, y);
        node.targetNode = personNode.parent;
        node.zPosition = 100000;
        
    }
    
}

#pragma mark ----miss %100 闪避率相关 ----
- (void)missAction:(NSTimer *)timer
{
    if (_personNode == nil) {
        [timer invalidate];
    }
    
    _missAddCount ++;
    if (_missAddCount >= 10) {
        [[WDNotificationManager shareManager]postNotificationWithMissCount:100];
        _personNode.wdMiss = self.wdMiss + 100;
        _missAddCount = 0;
        
        WDTextureManager *manager = [WDTextureManager shareManager];
        
        BaseNode *missNode = [BaseNode spriteNodeWithTexture:manager.passive_missArr[0]];
        missNode.name = @"miss";
        missNode.alpha = 0;
        missNode.position = CGPointMake(10, 0);
        [_personNode addChild:missNode];
        
        SKAction *action = [SKAction animateWithTextures:manager.passive_missArr timePerFrame:0.1];
        //5 * 8 * 0.1; MISS UP 时间
        SKAction *rep = [SKAction repeatAction:action count:6];
        SKAction *alpha0 = [SKAction fadeAlphaTo:0 duration:5 * 8 * 0.1];
        SKAction *alpha1 = [SKAction fadeAlphaTo:1 duration:8 *0.1];
        SKAction *seq1 = [SKAction sequence:@[alpha1,alpha0]];
        
        SKAction *gr = [SKAction group:@[rep,seq1]];
        SKAction *removeA = [SKAction removeFromParent];
        __weak typeof(self)weakSelf = self;
        [missNode runAction:[SKAction sequence:@[gr,removeA]] completion:^{
            [[WDNotificationManager shareManager]postNotificationWithMissCount:weakSelf.wdMiss];
            weakSelf.personNode.wdMiss = weakSelf.wdMiss;
        }];
    }
}

- (void)setMiss
{
    if (!_missTimer) {
        _missTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(missAction:) userInfo:nil repeats:YES];
    }
    
    [[WDTextureManager shareManager]setMissArr:YES];
}

- (void)removeMiss
{
    if (_missTimer) {
        [_missTimer invalidate];
        _missTimer = nil;
    }
    
    [[WDTextureManager shareManager]setMissArr:NO];
}

@end
