//
//  GameScene.m
//  HotSchool
//
//  Created by 吴冬 on 2018/5/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
 
    SKSpriteNode *_personNode;
    SKSpriteNode *_bgNode;
    NSArray      *_moveArr;
    NSArray      *_blackCircleArr;
    SKSpriteNode *_blackCircleNode;
    
    SKTexture *_textTexutre;
    BOOL          _isAnimation;
}

- (void)didMoveToView:(SKView *)view {


    NSString *textStr = @"angel_move_";
    
    _textTexutre = [SKTexture textureWithImage:[UIImage imageNamed:@"angel_move_1"]];
    _personNode = [[SKSpriteNode alloc] initWithTexture:_textTexutre];
    _personNode.position = CGPointMake(200, 300);
    _personNode.xScale = 0.8;
    _personNode.yScale = 0.8;
    [self addChild:_personNode];
   
    SKTexture *textureD = [SKTexture textureWithImage:[UIImage imageNamed:@"person_black_circle_1"]];
    _blackCircleNode = [[SKSpriteNode alloc] initWithTexture:textureD];
    _blackCircleNode.position = CGPointMake(0,  - _personNode.size.height / 0.8 / 2.0);
    [_personNode addChild:_blackCircleNode];
    
    NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i ++) {
        
        NSString *imageName = [NSString stringWithFormat:@"person_black_circle_%d",i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        SKTexture *texture = [SKTexture textureWithImage:image];
        [arr2 addObject:texture];
    }
    _blackCircleArr = arr2;
    SKAction *moveAction = [SKAction animateWithTextures:_blackCircleArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:moveAction];
    [_blackCircleNode runAction:rep];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 6; i ++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@%d",textStr,i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        SKTexture *texture = [SKTexture textureWithImage:image];
        [arr addObject:texture];
    }
    
    _moveArr = arr;
    SKAction *moveAction1 = [SKAction animateWithTextures:_moveArr timePerFrame:0.15];
    SKAction *rep1 = [SKAction repeatActionForever:moveAction1];
 
    
    
    [_personNode runAction:rep1 completion:^{
        
    }];
}


- (void)moveActionWithDirection:(NSString *)direction
                       position:(CGPoint)point
{

    CGPoint personPoint = _personNode.position;
    CGPoint movePoint = CGPointMake(personPoint.x + point.x, personPoint.y + point.y);
    
    _personNode.position = movePoint;
    
    if ([direction isEqualToString:@"left"]) {
        _personNode.xScale = -1 * fabs(_personNode.xScale);
    }else if ([direction isEqualToString:@"right"]){
        _personNode.xScale = 1 * fabs(_personNode.xScale);
    }
    
    if ([direction isEqualToString:@"1"]) {
        //[_personNode removeAllActions];
        _isAnimation = NO;
    
        _personNode.texture = _textTexutre;
    }else{
        if (_isAnimation) {
            return;
        }
        _isAnimation = YES;
    }
}



- (void)dealloc{
    NSLog(@"测试scene释放");
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
