//
//  WDSkillView.m
//  HotSchool
//
//  Created by Mac on 2018/7/3.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDSkillView.h"

@implementation WDSkillView
{
    NSTimer *_timer;
    UILabel *_timeLabel;
    BOOL     _longAttackAction;
}

- (void)setGesture
{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureLongPresAction:)];
    gesture.minimumPressDuration = 0.3;
    [self addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer    alloc] initWithTarget:self action:@selector(gestureTapAction:)];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)gestureTapAction:(UIGestureRecognizer *)gesture
{
    if (!_longAttackAction) {
        if (_beginBlock) {
            _beginBlock();
        }
        
        self.alpha = 0.7;
    }
}

- (void)gestureLongPresAction:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if (_longAttackBeginBlock) {
            _longAttackBeginBlock();
        }
        
        _longAttackAction = YES;
        NSLog(@"长按开始!");
    }else if(gesture.state == UIGestureRecognizerStateEnded){

        if (_longAttackEndBlock) {
            _longAttackEndBlock();
        }
        
        
        _longAttackAction = NO;
        self.alpha = 0.7;
        NSLog(@"长按结束！");
    }
    
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:_imageV];
    }
    
    return _imageV;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_canUse) {
        return;
    }
    
    if (_isAttackBtn) {
        self.alpha = 0.3;
        return;
    }
    if (_timer) {
        return;
    }
    self.alpha = 0.3;
    if (_beginBlock) {
        _beginBlock();
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_timer) {
        return;
    }
    
    if (_isReturnBtn) {
        return;
    }
    self.alpha = 0.7;
}

- (void)setTimeLabel:(NSInteger)times
{
    if (_timer) {
        return;
    }
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:30];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%ld",(long)times];

    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTimes:) userInfo:nil repeats:YES];
    self.alpha = 0.2;
}

- (void)reduceTimes:(NSTimer *)timer
{
    NSInteger times = [_timeLabel.text integerValue];
    times --;
    if (times <= 0) {
        _timeLabel.text = @"";
        [timer invalidate];
        _timer = nil;
        self.alpha = 0.7;

        __weak typeof(self)weakSelf = self;
        CGRect rect = self.imageV.frame;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.imageV.frame = CGRectMake(rect.origin.x - 15, rect.origin.y - 15, rect.size.width + 30, rect.size.height + 30);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.imageV.frame = rect;
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%ld",times];
    }
    
}

- (void)clearAction
{
    _timeLabel.text = @"";
    [_timer invalidate];
    _timer = nil;
    self.alpha = 0.7;
    self.lockImageV.hidden = _canUse;
}

- (UIImageView *)lockImageV
{
    if (!_lockImageV) {
        _lockImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _lockImageV.image = [UIImage imageNamed:@"lock"];
        [self addSubview:_lockImageV];
    }
    
    return _lockImageV;
}

- (void)unlockAnimation
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.lockImageV.alpha = 0;
    } completion:^(BOOL finished) {
        CGRect rect = self.imageV.frame;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.imageV.frame = CGRectMake(rect.origin.x - 15, rect.origin.y - 15, rect.size.width + 30, rect.size.height + 30);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.imageV.frame = rect;
            } completion:^(BOOL finished) {
                weakSelf.canUse = YES;
            }];
        }];
    }];
    
}

@end
