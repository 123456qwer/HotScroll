//
//  WDActionTool.m
//  HotSchool
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDActionTool.h"

@implementation WDActionTool


+ (SKAction *)moveActionWithMoveArr:(NSArray <SKTexture *>*)moveArr
                               time:(NSTimeInterval)time
{
    if (moveArr) {
        SKAction *moveAction = [SKAction animateWithTextures:moveArr timePerFrame:time];
        SKAction *repeatAction = [SKAction repeatActionForever:moveAction];
        
        return repeatAction;
    }
    
    return nil;
  
}

+ (void)demageAnimation:(BaseNode *)node
                  point:(CGPoint)point
                  scale:(CGFloat)scale
              demagePic:(NSString *)imageName
{
    if (node.wdNowBlood <= 0) {
        return;
    }
    
    CGFloat rotation = M_PI / 180.0 * (arc4random() % 360);
    BaseNode *demageNode = [BaseNode spriteNodeWithTexture:[WDTextureManager shareManager].demageDic[imageName]];
    demageNode.xScale = scale;
    demageNode.yScale = scale;
    demageNode.position = point;
    demageNode.zRotation = rotation;
    demageNode.name = imageName;
    [node addChild:demageNode];
    
    SKAction *alphaAction = [SKAction fadeAlphaTo:0 duration:0.3];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seqAction = [SKAction sequence:@[alphaAction,removeAction]];
    [demageNode runAction:seqAction];
}

+ (void)reduceBloodLabelAnimation:(BaseNode *)node
                      reduceCount:(CGFloat)count
                          isSkill:(BOOL)isSkill
{
    NSString *name = [NSString stringWithFormat:@"%lf_%@",count,node.name];
    SKLabelNode *labelNode = (SKLabelNode *)[node.parent childNodeWithName:name];
    labelNode.fontColor = [UIColor yellowColor];
}

+ (void)reduceBloodLabelAnimation:(BaseNode *)node
                      reduceCount:(CGFloat)count
{
   
    if ([node.name isEqualToString:@"shanaMonster"] || [node.name isEqualToString:@"kanaMonster"] || [node.name isEqualToString:@"boss3"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForBossReduceBloodAction object:@{@"blood":@(count)}];
    }
    
    if (node.wdNowBlood <= 0) {
        return;
    }
    
    //27 36
    
//    NSArray *fontArr = [UIFont familyNames];
//    NSString *fontName = fontArr[27];
    NSString *fontName = @"Noteworthy";

    //VCR OSD Mono
    NSString *str = [NSString stringWithFormat:@"-%0.0lf",count];
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:fontName];
    label.zPosition = 5000;
    label.text = str;
    label.name = [NSString stringWithFormat:@"%lf_%@",count,node.name];
    if ([node.name isEqualToString:@"person"]) {
        label.fontColor = [UIColor orangeColor];
    }else{
        label.fontColor = [UIColor whiteColor];
    }
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    int size = arc4random() % 5 + 20;
    label.fontSize = size;
    label.xScale = 2;
    label.yScale = 2;
    label.position = CGPointMake(node.position.x + arc4random() % 50 - 25, node.position.y);
    
    SKAction *alphaAction = [SKAction fadeAlphaTo:0 duration:1.5];
    SKAction *moveAction  = [SKAction moveToY:node.size.height + node.position.y duration:1];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *group = [SKAction group:@[alphaAction,moveAction]];
    //SKAction *music = [WDTextureManager shareManager].beAttackMusicAction;
    SKAction *seq    = [SKAction sequence:@[group,removeAction]];
    [node.parent addChild:label];
    [label runAction:seq];
}

+ (void)arrowAnimation:(BaseNode *)node
{
   
    NSInteger directionX = 1;
    if (arc4random() % 2 == 0) {
        directionX = -1;
    }
    
    NSInteger directionY = 1;
    if (arc4random() % 2 == 0) {
        directionY = -1;
    }
    
    CGFloat xMove = arc4random() % 100 + 130;
    CGFloat yMove = arc4random() % 100 + 130;
    CGFloat quan  = arc4random() % 5 + 5;
    
    xMove = directionX * xMove;
    yMove = directionY * yMove;
    
    CGPoint movePoint = CGPointMake(node.position.x + xMove, node.position.y + yMove);
    SKAction *movePointA = [SKAction moveTo:movePoint duration:0.7];
    SKAction *ra = [SKAction rotateByAngle:quan duration:0.7];
    SKAction *alp = [SKAction fadeAlphaTo:0 duration:0.7];
    SKAction *remo = [SKAction removeFromParent];
    SKAction *gro = [SKAction group:@[movePointA,ra,alp]];
    SKAction *seq = [SKAction sequence:@[gro,remo]];
    [node runAction:seq];
}

+ (SKTransition *)changeSceneRandomWithTime:(NSTimeInterval)times
                                actionIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return [SKTransition crossFadeWithDuration:times];
            break;
        case 1:
            return [SKTransition fadeWithDuration:times];
            break;
        case 2:
            return [SKTransition flipHorizontalWithDuration:times];
            break;
        case 3:
            return [SKTransition flipVerticalWithDuration:times];
            break;
        case 4:
            return [SKTransition doorsOpenHorizontalWithDuration:times];
            break;
        case 5:
            return [SKTransition doorsOpenVerticalWithDuration:times];
            break;
        case 6:
            return [SKTransition doorsCloseVerticalWithDuration:times];
            break;
        case 7:
            return [SKTransition doorsCloseHorizontalWithDuration:times];
            break;
        case 8:
            return [SKTransition doorwayWithDuration:times];
            break;
        case 9:
            return [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:times];
            break;
        case 10:
            //和push页面一样
            return [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:times];
            break;
        default:
            break;
    }
    
    return nil;
}

+ (SKAction *)deadAnimationWithAttackDirection:(BOOL)attackerIsLeft
                                       deadArr:(NSArray <SKTexture *>*)deadArr
                                          node:(BaseNode *)deadNode
{
    NSInteger index = 1;
    if (!attackerIsLeft) {
        index = -1;
    }
    
    //方向正好相反
    deadNode.xScale = (index * -1) * fabs(deadNode.xScale);
    
    
    CGPoint movePoint2 = CGPointMake(deadNode.position.x + 300 * index, deadNode.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:deadNode.size];
    CGFloat y1 = deadNode.position.y + 150;
    CGFloat y2 = deadNode.position.y;
    
    
    SKAction *move2 = [SKAction moveToX:calculatePoint2.x duration:3 * 0.15];
    SKAction *move3 = [SKAction moveToY:y1 duration:3 * 0.15 / 2.0];
    SKAction *move4 = [SKAction moveToY:y2 duration:3 * 0.15 / 2.0];
    SKAction *moveSeq = [SKAction sequence:@[move3,move4]];
    SKAction *beAttackAction = [SKAction animateWithTextures:deadArr timePerFrame:0.15];
    SKAction *group = [SKAction group:@[move2,moveSeq,beAttackAction]];
    
    SKAction *waitAction     = [SKAction waitForDuration:0.5];
    //SKAction *standAction    = [SKAction animateWithTextures:secondArr timePerFrame:0.1];
    
    SKAction *seq = [SKAction sequence:@[group,waitAction]];
    
    //跳跃的时候，黑圈不跟着移动
    SKAction *blackMo = [SKAction moveToY:deadNode.blackCircleNode.position.y - 75 duration:3 * 0.15 / 2.0];
    SKAction *blackMo2 = [SKAction moveToY:deadNode.blackCircleNode.position.y duration:3 * 0.15 / 2.0];
    SKAction *seqB = [SKAction sequence:@[blackMo,blackMo2]];
    [deadNode.blackCircleNode runAction:seqB];
    
    return seq;
}

+ (SKAction *)downAnimation:(BOOL)attackerIsLeft
                    downArr:(NSArray <SKTexture *>*)downArr
                       node:(BaseNode *)downNode
             circlePosition:(CGPoint)point
{
    NSInteger index = 1;
    if (!attackerIsLeft) {
        index = -1;
    }
    
    downNode.blackCircleNode.position = point;
    //方向正好相反
    downNode.xScale = (index * -1) * fabs(downNode.xScale);
    
    
    CGPoint movePoint2 = CGPointMake(downNode.position.x + 400 * index, downNode.position.y);
    CGPoint calculatePoint2 = [WDCalculateTool calculateMaxMoveXAndY:movePoint2 maxX:2500 maxY:650 personSize:downNode.size];
    CGFloat y1 = downNode.position.y + 150;
    CGFloat y2 = downNode.position.y;
    
    
    SKAction *move2 = [SKAction moveToX:calculatePoint2.x duration:3 * 0.15];
    SKAction *move3 = [SKAction moveToY:y1 duration:3 * 0.15 / 2.0];
    SKAction *move4 = [SKAction moveToY:y2 duration:3 * 0.15 / 2.0];
    SKAction *moveSeq = [SKAction sequence:@[move3,move4]];
    SKAction *beAttackAction = [SKAction animateWithTextures:[downArr subarrayWithRange:NSMakeRange(0, 3)] timePerFrame:0.15];
    SKAction *waitAction     = [SKAction waitForDuration:0.3];
    SKAction *standAction = [SKAction animateWithTextures:[downArr subarrayWithRange:NSMakeRange(3, 3)] timePerFrame:0.15];
    SKAction *seqTexture = [SKAction sequence:@[beAttackAction,waitAction,standAction]];
    SKAction *group = [SKAction group:@[move2,moveSeq,seqTexture]];
    
    //SKAction *standAction    = [SKAction animateWithTextures:secondArr timePerFrame:0.1];
    
    //跳跃的时候，黑圈不跟着移动
    SKAction *blackMo = [SKAction moveToY:downNode.blackCircleNode.position.y - 75 duration:3 * 0.15 / 2.0];
    SKAction *blackMo2 = [SKAction moveToY:downNode.blackCircleNode.position.y duration:3 * 0.15 / 2.0];
    SKAction *seqB = [SKAction sequence:@[blackMo,blackMo2]];
    [downNode.blackCircleNode runAction:seqB];
    
    return group;
}

+ (void)showDiedText:(SKScene *)scene
{
    SKTexture *D = [SKTexture textureWithImage:[UIImage imageNamed:@"D"]];
    SKTexture *Ia = [SKTexture textureWithImage:[UIImage imageNamed:@"I"]];
    SKTexture *E = [SKTexture textureWithImage:[UIImage imageNamed:@"E"]];

    BaseNode *node1 = [BaseNode spriteNodeWithTexture:D];
    node1.zPosition = 100000;
    node1.anchorPoint = CGPointMake(0, 0);
    CGFloat y = 650 / 2.0 + node1.size.height / 2.0;
    node1.position = CGPointMake(1334 / 2.0 - node1.size.width * 2, y);
    node1.alpha = 0;
    [scene addChild:node1];
    
    BaseNode *node2 = [BaseNode spriteNodeWithTexture:Ia];
    node2.zPosition = 100000;
    node2.anchorPoint = CGPointMake(0, 0);
    node2.position = CGPointMake(1334 / 2.0 - node2.size.width , y);
    node2.alpha = 0;
    [scene addChild:node2];
    
    BaseNode *node3 = [BaseNode spriteNodeWithTexture:E];
    node3.zPosition = 100000;
    node3.anchorPoint = CGPointMake(0, 0);
    node3.position = CGPointMake(1334 / 2.0, y);
    node3.alpha = 0;
    [scene addChild:node3];
    
    BaseNode *node4 = [BaseNode spriteNodeWithTexture:D];
    node4.zPosition = 100000;
    node4.anchorPoint = CGPointMake(0, 0);
    node4.position = CGPointMake(1334 / 2.0 + node4.size.width, y);
    node4.alpha = 0;
    [scene addChild:node4];
    
    SKAction *moveAction = [SKAction moveToY:650 / 2.0 - node1.size.height / 2.0  duration:0.5];
    SKAction *alpha = [SKAction fadeAlphaTo:1 duration:0.5];
    
    SKAction *g = [SKAction group:@[moveAction,alpha]];
    
    [node1 runAction:g];
    [node2 runAction:g];
    [node3 runAction:g];
    [node4 runAction:g];
}

+ (void)dropMoneyAnimation:(BaseNode *)superNode
                  position:(CGPoint)point
                      gold:(NSInteger)gold
{
   
    if (arc4random() % 3 != 0) {
        return;
    }
    
    SKTexture *texture = [SKTexture textureWithImage:[WDTextureManager shareManager].moneyImage];
    //创建金币
    BaseNode *node = [BaseNode spriteNodeWithTexture:texture];
    node.position = point;
    node.zPosition = 10;
    node.alpha = 1;
    node.name = @"money";
    node.xScale = 0.5;
    node.yScale = 0.5;
    [node setMonsterNormalPhybodyWithFrame:CGRectMake(0, 0, node.size.width, node.size.height)];
    [superNode addChild:node];
    
    SKEmitterNode *magicN = [SKEmitterNode nodeWithFileNamed:@"Magic"];
    [node addChild:magicN];
    
    SKAction *move1 = [SKAction moveToY:node.position.y + 10 duration:0.7];
    SKAction *move2 = [SKAction moveToY:node.position.y  duration:0.7];
    SKAction *seq2 = [SKAction sequence:@[move1,move2]];
    
    SKAction *rep = [SKAction repeatAction:seq2 count:5];
    SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.5];
    SKAction *xScale = [SKAction scaleTo:0 duration:0.5];
    SKAction *g = [SKAction group:@[alpha,xScale]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[rep,g,remove]];
    [node runAction:seq];
    
    
//    NSString *goldText = [NSString stringWithFormat:@"x%ld",gold];
//    SKLabelNode *goldNode = [SKLabelNode labelNodeWithFontNamed:@"VCR OSD Mono"];
//    goldNode.fontColor = [UIColor whiteColor];
//    goldNode.text = goldText;
//    goldNode.zPosition = 20;
//    goldNode.position = CGPointMake(0, 40);
//    goldNode.fontSize = 50;
//    [node addChild:goldNode];

//    [node runAction:seq completion:^{
//        WDNotificationManager *manager = [WDNotificationManager shareManager];
//        [manager postNotificationWithGoldCount:gold];
//    }];
}

+ (void)missAnimation:(BaseNode *)node
{
    NSString *str = @"miss";
    UIColor *color = [UIColor yellowColor];
    if ([node.name isEqualToString:@"person"]) {
        str = @"miss";
        color = [UIColor orangeColor];
    }else{
        int random = arc4random() % 3;
        if (random == 0) {
            str = @"not work";
        }else if(random == 1){
            str = @"useless";
        }
    }
    
   
    
    
//    NSArray *fontArr = [UIFont familyNames];
//    NSString *fontName = fontArr[27];
    NSString *fontName = @"Noteworthy";
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:fontName];
    label.zPosition = 5000;
    label.text = str;
    label.fontColor = color;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.fontSize = 25;
    label.xScale = 2;
    label.yScale = 2;
    label.position = CGPointMake(node.position.x, node.position.y);
    
    SKAction *alphaAction = [SKAction fadeAlphaTo:0 duration:1.5];
    SKAction *moveAction  = [SKAction moveToY:node.size.height + node.position.y duration:1];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *group = [SKAction group:@[alphaAction,moveAction]];
    SKAction *seq    = [SKAction sequence:@[group,removeAction]];
    
    [node.parent addChild:label];
    [label runAction:seq];
    
  
}


+ (void)debuffForQuestion:(BaseNode *)superNode
                 textures:(NSArray <SKTexture *>*)arr
                 position:(CGPoint)point
{
    
    if (arr.count == 0) {
        return;
    }
    
    BaseNode *questionNode = [BaseNode spriteNodeWithTexture:arr[0]];
    questionNode.zPosition = 1000;
    questionNode.position = point;
    questionNode.name     = @"question";
    [superNode addChild:questionNode];
    
    SKAction *textureAction = [SKAction animateWithTextures:arr timePerFrame:0.05];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[textureAction,removeAction]];
    [questionNode runAction:seq completion:^{
        superNode.oppositeDebuff = NO;
    }];
    
}

+ (void)showPassLabelWithScene:(BaseScene *)scene
{
   
    
    int size = 50;

    //VCR OSD Mono
    NSInteger times = scene.useTimes;
    NSInteger second = times % 60;
    NSInteger minute = times / 60;
    NSInteger hour   = times / 60 / 60;
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    
//    NSArray *fontArr = [UIFont familyNames];
//    NSString *fontName2 = fontArr[27];
    
    NSString *fontName2 = @"Noteworthy";

    
    SKLabelNode *timeLabel2 = [SKLabelNode labelNodeWithFontNamed:fontName2];
    timeLabel2.zPosition = 100000;
    timeLabel2.text = @"TIME：";
    timeLabel2.fontColor = [UIColor whiteColor];
    timeLabel2.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    timeLabel2.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    timeLabel2.fontSize = size;
    timeLabel2.alpha = 0;
    //    label.xScale = 2;
    //    label.yScale = 2;
    [scene addChild:timeLabel2];
    
    //NSString *fontName = fontArr[27];
    NSString *fontName = @"Noteworthy";

    SKLabelNode *timeLabel1 = [SKLabelNode labelNodeWithFontNamed:fontName];
    timeLabel1.zPosition = 100000;
    timeLabel1.text = timeStr;
    timeLabel1.fontColor = [UIColor whiteColor];
    timeLabel1.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    timeLabel1.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    timeLabel1.fontSize = size;
    timeLabel1.alpha = 0;
//    label.xScale = 2;
//    label.yScale = 2;
    [scene addChild:timeLabel1];
    CGFloat timeWidth1 = timeLabel1.frame.size.width;
    CGFloat timeWidth2 = timeLabel2.frame.size.width;

    timeLabel1.position = CGPointMake(1334.0 / 2.0 - timeWidth1 / 2.0 + 100, 650 / 2.0 + 200);
    timeLabel2.position = CGPointMake(timeLabel1.position.x - timeWidth2 - 15, 650 / 2.0 + 200);
    
    SKTexture *texture1 = nil;
    if (scene.useTimes <= scene.starTimes) {
        texture1 = [SKTexture textureWithImage:[UIImage imageNamed:@"star"]];
    }else{
        texture1 = [SKTexture textureWithImage:[UIImage imageNamed:@"star_black"]];
    }
    
    BaseNode *starNode1 = [BaseNode spriteNodeWithTexture:texture1];
    starNode1.zPosition = 100000;
    starNode1.xScale = 0.25;
    starNode1.yScale = 0.25;
    starNode1.alpha = 0;
    [scene addChild:starNode1];
    
    starNode1.position = CGPointMake(timeLabel1.position.x + starNode1.frame.size.width / 2.0 + timeWidth1 + 10, timeLabel1.position.y);


    
    SKLabelNode *blood1 = [SKLabelNode labelNodeWithFontNamed:fontName];
    blood1.zPosition = 100000;
    blood1.text = @"BLOOD：";
    blood1.fontColor = [UIColor whiteColor];
    blood1.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    blood1.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    blood1.fontSize = size;
    blood1.alpha = 0;
    [scene addChild:blood1];
    
    CGFloat bloodPercent = scene.personNode.wdNowBlood / scene.personNode.wdBlood;
    
    SKLabelNode *blood2 = [SKLabelNode labelNodeWithFontNamed:fontName];
    blood2.zPosition = 100000;
    blood2.text = [NSString stringWithFormat:@"%0.00lf%%",bloodPercent * 100];
    blood2.fontColor = [UIColor whiteColor];
    blood2.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    blood2.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    blood2.fontSize = size;
    blood2.alpha = 0;
    [scene addChild:blood2];

    SKTexture *texture2 = nil;
    if (scene.personNode.wdNowBlood == scene.personNode.wdBlood) {
        texture2 = [SKTexture textureWithImage:[UIImage imageNamed:@"star"]];
    }else{
        texture2 = [SKTexture textureWithImage:[UIImage imageNamed:@"star_black"]];
    }
    
    
    BaseNode *starNode2 = [BaseNode spriteNodeWithTexture:texture2];
    starNode2.zPosition = 100000;
    starNode2.xScale = 0.25;
    starNode2.yScale = 0.25;
    starNode2.alpha = 0;
    [scene addChild:starNode2];
    
    blood1.position = CGPointMake(timeLabel2.position.x, timeLabel2.position.y - timeLabel2.frame.size.height - 15);
    blood2.position = CGPointMake(blood1.position.x + blood1.frame.size.width, blood1.position.y);
    starNode2.position = CGPointMake(blood2.position.x + starNode2.frame.size.width / 2.0 + 10 + blood2.frame.size.width, blood2.position.y);
    
    
    SKAction *alphaAction = [SKAction fadeAlphaTo:1 duration:0.6];
    [scene.personNode isCanNotAttack];
    [timeLabel2 runAction:alphaAction completion:^{
        [timeLabel1 runAction:alphaAction completion:^{
            [starNode1 runAction:alphaAction completion:^{
                [blood1 runAction:alphaAction completion:^{
                    [blood2 runAction:alphaAction completion:^{
                        [starNode2 runAction:alphaAction completion:^{
                            NSLog(@"%@",scene.personNode);
                            scene.personNode.isAttackIng = NO;
                        }];
                    }];
                }];
            }];
        }];
    }];
    
    
    
    
}



@end
