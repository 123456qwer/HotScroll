//
//  WDMoveOpeartionView.m
//  HotSchool
//
//  Created by 吴冬 on 2018/5/8.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDMoveOpeartionView.h"

@implementation WDMoveOpeartionView
{
    CGPoint _movePoint;
    CGPoint _startPoint;
    CGPoint _location;
    
    UIImageView *_smallCircle;
    UIImageView *_bigCircle;
    
    NSString *_direction;
    CGPoint   _personMovePoint;
    
    CADisplayLink *_moveLink;
    BOOL _isStopMove;
}

- (void)moveAction
{
    if (_isStopMove) {
    
        return;
    }
    if (_moveBlock) {
        _moveBlock(_direction,_personMovePoint);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        _isStopMove = YES;
        
        _moveLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveAction)];
        [_moveLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        
        CGFloat smallWidth = 40 / 1334.0 * (kScreenWidth * 2);
        CGFloat bigWidth   = 120 / 1334.0 * (kScreenWidth * 2);
        CGFloat page       = 100 / 1334.0 * (kScreenWidth * 2);
        
        CGFloat Xp = 0;
        CGFloat Yp = 0;
        if (IS_IPHONEX) {
            Xp = 20;
            Yp = 15;
        }
        _location =  CGPointMake(page + Xp, kScreenHeight - page + Yp);
        
        _bigCircle   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bigWidth, bigWidth)];
        _bigCircle.image = [UIImage imageNamed:@"attackOpeation"];
        [self addSubview:_bigCircle];
        
        _smallCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, smallWidth, smallWidth)];
        _smallCircle.image = [UIImage imageNamed:@"skillOpeation"];
        [self addSubview:_smallCircle];
        
        _smallCircle.alpha = 0.5;
        _bigCircle.alpha   = 0.1;
  
        _smallCircle.center = _location;
        _bigCircle.center   = _location;
        _startPoint         = _location;
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _smallCircle.center = _location;
    _isStopMove = YES;
    if (_stopBlock) {
        _stopBlock(_direction);
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isStopMove = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGFloat x = 0;
    CGFloat y = 0;
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInView:self];
        CGFloat bigX = fabs(location.x - _startPoint.x);
        CGFloat bigY = fabs(location.y - _startPoint.y);
        
        CGFloat edge = sqrt(bigX * bigX + bigY * bigY);
        
        CGFloat x_long = 40 / edge * bigX;
        CGFloat y_long = 40 / edge * bigY;
        
        //最大小圆圈移动距离不超过40
        if (edge >= 40) {
            
            if (location.x > _startPoint.x) {
                _movePoint.x = _startPoint.x + x_long;
            }else{
                _movePoint.x = _startPoint.x - x_long;
            }
            
            if (location.y > _startPoint.y) {
                _movePoint.y = _startPoint.y + y_long;
            }else{
                _movePoint.y = _startPoint.y - y_long;
            }
            
        }else{
            _movePoint.x = location.x;
            _movePoint.y = location.y;
        }
        
        //速度获取统一用全局管理
        CGFloat speed = [PersonManager sharePersonManager].wdSpeed;
        NSDictionary *dic = [WDCalculateTool calculateDirection:location point:_startPoint speed:speed];
        
        _direction = dic[@"direction"];
        x = [dic[@"x"]floatValue];
        y = [dic[@"y"]floatValue];
        _personMovePoint = CGPointMake(x,y);

        _smallCircle.center = _movePoint;
    }
    
   
}



@end
