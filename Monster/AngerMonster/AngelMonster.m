//
//  AngelMonster.m
//  HotSchool
//
//  Created by Mac on 2018/10/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "AngelMonster.h"
#import "AngelModel.h"
@implementation AngelMonster
{
    AngelModel *_model;
    __weak BaseNode *_personNode;
    NSTimer *_greenWindTimer;

}
- (void)initActionWithModel:(WDBaseModel *)model
{
    [super initActionWithModel:model];
    
    self.delegate = self;
    self.monsterDelegate = self;
    self.name = @"angelMonster";
    _model = (AngelModel *)model;
    self.model = _model;
   
    self.min_X_Distance = 100;
    self.min_Y_Distance = 100;
    
    [self createBlackCircle];
    self.blackCircleNode.position = CGPointMake(0, -80);
    
    self.wdSpeed = 0.8;
    self.wdBlood = 600;
    self.wdNowBlood = self.wdBlood;
    self.wdAttack = 30;
    
   
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 100) center:CGPointMake(0, 0)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = 0;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = 0;
    self.physicsBody = body;
    
    CGFloat x = arc4random() % 960 + 700;
    CGFloat y = arc4random() % 250 + 100;
    self.position = CGPointMake(x, y);
    self.zPosition = 650 - self.position.y;
    self.xScale = 1.6;
    self.yScale = 1.6;
    _starMove = YES;
    //[self createGreenWindTimer];
    [self attackAction];
    
//    SKAction *action = [SKAction animateWithTextures:[_model.attack1Arr subarrayWithRange:NSMakeRange(0, 3)] timePerFrame:0.1];
//    SKAction *wait = [SKAction waitForDuration:1.5];
//    SKAction *action2 = [SKAction animateWithTextures:[_model.attack1Arr subarrayWithRange:NSMakeRange(3, 1)] timePerFrame:0.15];
//    SKAction *seq = [SKAction sequence:@[action,wait,action2]];
//    SKAction *rep = [SKAction repeatAction:seq count:100];
//    [self runAction:rep];
//
//    self.isMoveIng = YES;
    
}

- (void)createGreenWindTimer
{
    if (!_greenWindTimer) {
        _greenWindTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(greenWindAction:) userInfo:nil repeats:YES];
    }
}

- (void)greenWindAction:(NSTimer *)timer
{
    
    if (!_model || _model.skill2Arr.count == 0) {
        return;
    }
    
    BaseNode *greenNode = [BaseNode spriteNodeWithTexture:_model.skill2Arr[0]];
    greenNode.position = _personNode.position;
    greenNode.zPosition = _personNode.zPosition - 10;
    greenNode.alpha = 0;
    greenNode.name = @"angelSkill1";
    [self.parent addChild:greenNode];
    //[greenNode realBackGroundWithColor:[UIColor orangeColor]];
    //[greenNode physicalBackGroundNodeWithColor:[UIColor orangeColor] size:CGSizeMake(50, 75) position:CGPointMake(0, 0)];
    greenNode.imageWidth = 100;
    greenNode.imageHeight = 150;
    greenNode.xScale = 2.0;
    greenNode.yScale = 2.0;
    SKAction *alphaAction = [SKAction fadeAlphaTo:1 duration:1];
    SKAction *textureAction = [SKAction animateWithTextures:_model.skill2Arr timePerFrame:0.15];
    
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seqAction = [SKAction sequence:@[alphaAction,textureAction]];
    SKAction *alphaA2 = [SKAction fadeAlphaTo:0.5 duration:0.5];
    SKAction *alphaA3 = [SKAction fadeAlphaTo:1 duration:0.5];
    SKAction *repAction = [SKAction repeatAction:[SKAction sequence:@[alphaA2,alphaA3]] count:3];
    SKAction *xS = [SKAction scaleXTo:0.1 y:0.1 duration:0.15];
    

    [greenNode runAction:seqAction completion:^{
     
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100, 150) center:CGPointMake(0, 0)];
        body.allowsRotation = NO;
        body.affectedByGravity = NO;
        body.categoryBitMask = 0;
        body.contactTestBitMask = MONSTER_CONTACT;
        body.collisionBitMask = 0;
        greenNode.physicsBody = body;
        [greenNode runAction:[SKAction sequence:@[repAction,xS,removeAction]] completion:^{
        }];
        
    }];
}



- (void)setPersonNode:(BaseNode *)personNode;
{
    [super setPersonNode:personNode];
    _personNode = personNode;
}

- (void)attackPersonNode
{
    CGFloat distanceX = self.position.x - _personNode.position.x;
    CGFloat distanceY = self.position.y - _personNode.position.y;
    
    BOOL isLeft = NO;
    if (distanceX < 0) {
        isLeft = YES;
    }
    
    CGFloat attackNumber = self.wdAttack;
    
    NSArray *arr = @[@(arc4random() % 5 + attackNumber),@(arc4random() % 5 + attackNumber),@(arc4random() % 5 + 10 + attackNumber),@(arc4random() % 5 + 15 + attackNumber)];
    CGFloat fudongNumber = [arr[self.attackType]integerValue] + 100;
    CGFloat bigDistance = 150;
    
    if (fabs(distanceX) < bigDistance && fabs(distanceY) < 100) {
        [_personNode.delegate beAttackAction:isLeft attackCount:fudongNumber];
    }
    
}

- (void)beAttackAction:(BOOL)attackerIsLeft
           attackCount:(CGFloat)count
{
    //已经被攻击的状态，不能连续被搞
    if (self.isBeAttackIng || self.isDeadIng) {
        return;
    }
    
    
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:count];
    [WDActionTool demageAnimation:self point:CGPointMake(0, 10) scale:0.5 demagePic:@"demage1"];
    self.wdNowBlood -= count;
    if (self.wdNowBlood <= 0) {
        [self clearAction];
        self.isDeadIng = YES;
        [self removeAllActions];
        [self.delegate deadAction:attackerIsLeft];
        return;
    }
    
    
    if (self.isSkillAttackIng) {
        NSLog(@"夏娜在释放技能的时候被屌丝攻击到了！！！！");
        //[self downAction:attackerIsLeft];
        
    }else{
        if (attackerIsLeft) {
            SKAction *moveTo = [SKAction moveToX:self.position.x + 40 duration:0.3];
            [self runAction:moveTo];
        }else{
            SKAction *moveTo = [SKAction moveToX:self.position.x - 40 duration:0.3];
            [self runAction:moveTo];
        }
    }
}

- (void)deadAction:(BOOL)attackerIsLeft
{
    [super deadAnimation:attackerIsLeft];
}

- (void)afterUpActionAttack
{
    CGFloat xDirection = 1;
    CGFloat distanceX = self.position.x - _personNode.position.x;
    CGFloat distanceY = self.position.y - _personNode.position.y - 25;
    if (distanceX > 0) {
        xDirection = -1;
    }else{
        xDirection = 1;
    }
    
    self.xScale = xDirection * fabs(self.xScale);
    
    CGFloat speed = 1000.f;
    CGFloat aDX = fabs(distanceX);
    CGFloat aDY = fabs(distanceY);
    //斜边英文。。。。等比计算
    CGFloat hypotenuse = sqrt(aDX * aDX + aDY * aDY);
 
    
    NSTimeInterval times = hypotenuse / speed;
    //NSLog(@"天使冲击时间是: %lf \n距离是: %lf",times,hypotenuse);
    SKAction *goToPersonAction = [SKAction moveTo:CGPointMake(_personNode.position.x,_personNode.position.y + 25) duration:times];
    SKAction *attackA = [SKAction animateWithTextures:[_model.attack1Arr subarrayWithRange:NSMakeRange(0, 3)] timePerFrame:times / 3.0];
    SKAction *gro = [SKAction group:@[goToPersonAction,attackA]];
    
    SKAction *attackB = [SKAction animateWithTextures:[_model.attack1Arr subarrayWithRange:NSMakeRange(3, 4)] timePerFrame:0.15];
    
    SKAction *blackCircleRecover = [SKAction moveToY:-80 duration:times];
    [self.blackCircleNode runAction:blackCircleRecover];

    
    __weak typeof(self)weakSelf = self;
    [weakSelf runAction:gro completion:^{
        [weakSelf attackPersonNode];
        [weakSelf runAction:attackB completion:^{
            weakSelf.isAttackIng = NO;
            [weakSelf performSelector:@selector(attackAction) withObject:nil afterDelay:3];
        }];
    }];
}

//攻击
- (void)attackAction
{
    if ([self isCanNotAttack]) {
        return;
    }
    
    CGFloat upHeight = 400;
    CGFloat upTime = 0.6;
    
    CGPoint upPosition = CGPointMake(self.position.x, self.position.y + upHeight);
  
    
    SKAction *upAction = [SKAction moveToY:upPosition.y duration:upTime];
    SKAction *moveAction = [SKAction animateWithTextures:self.model.moveArr timePerFrame:0.1];
    SKAction *gr = [SKAction group:@[upAction,moveAction]];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:gr completion:^{
        [weakSelf afterUpActionAttack];
    }];
    

    //SKAction *attackTextureA = [SKAction animateWithTextures:_model.attack1Arr timePerFrame:0.15];
    
    
    SKAction *blackCircleAction = [SKAction moveToY:self.blackCircleNode.position.y - upHeight / 2.0 - self.blackCircleNode.size.height - self.blackCircleNode.size.height / 2.0 duration:upTime];
    [self.blackCircleNode runAction:blackCircleAction];
    

}

- (void)blinkMove:(CGFloat)move_x{
    
    SKAction *move = [SKAction moveToX:move_x duration:0.5];
    SKAction *alphaA = [SKAction fadeAlphaTo:0 duration:0.1];
    SKAction *waitA  = [SKAction waitForDuration:0.2];
    SKAction *alphaB = [SKAction fadeAlphaTo:1 duration:0.2];
    
    SKAction *seq = [SKAction sequence:@[alphaA,waitA,alphaB]];
    SKAction *group = [SKAction group:@[seq,move]];
    
    [self runAction:group];
}

//移动
- (void)monsterMoveAction:(BaseNode *)personNode
{
    [self moveActionWithPersonNodePosition:personNode.position];
}

//一直靠近玩家移动
- (void)moveActionWithPersonNodePosition:(CGPoint)personPosition
{
    if ([self isCanNotMove]) {
        return;
    }
    
    CGFloat distanceX = self.position.x - personPosition.x;
    CGFloat distanceY = self.position.y - personPosition.y;

    CGFloat bigX;
    CGFloat bigY;
    
    NSInteger xDirection = 1;
    NSInteger yDirection = 1;
    if (distanceX > 0) {
        bigX = self.position.x;
        xDirection = -1;
    }else{
        bigX = personPosition.x;
        xDirection = 1;
    }
    
    if (distanceY > 0) {
        yDirection = -1;
        bigY = self.position.y;
    }else{
        yDirection = 1;
        bigY = personPosition.y;
    }
    
    //CGFloat blinkMoveX = 350;
    if (distanceX < 150) {
        
        //NSLog(@"天使距离过紧 x: %lf",distanceX);
        //[self blinkMove:blinkMoveX * xDirection];
        //return;
    }
    
//    CGFloat aDX = fabs(distanceX);
//    CGFloat aDY = fabs(distanceY);
    //斜边英文。。。。等比计算
    //CGFloat hypotenuse = sqrt(aDX * aDX + aDY * aDY);
    
//    CGFloat moveX = self.wdSpeed * aDX / hypotenuse * xDirection;
//    CGFloat moveY = self.wdSpeed * aDY / hypotenuse * yDirection;
    
    if (_starMove) {
        self.xScale = xDirection * fabs(self.xScale);
//        self.position = CGPointMake(self.position.x + moveX, self.position.y + moveY);
        self.zPosition = 650 - self.position.y + 60;
    }
  
    
 
    
    if (!self.isMoveIng) {
        
        self.isMoveIng = YES;
        //6张
        SKAction *moveAction = [SKAction animateWithTextures:self.model.moveArr timePerFrame:0.2];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}


- (void)clearAction
{
    [super clearAction];
    
    if (_greenWindTimer) {
        [_greenWindTimer invalidate];
        _greenWindTimer = nil;
    }
    
}

@end
