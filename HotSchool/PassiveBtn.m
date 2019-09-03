//
//  PassiveBtn.m
//  begin
//
//  Created by Mac on 2019/4/25.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "PassiveBtn.h"

@implementation PassiveBtn

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 50) / 2.0, (self.height - 50) / 2.0, 50, 50)];
        [self addSubview:_selectImageView];
    }
    
    return _selectImageView;
}

- (void)setImageViewWithName:(NSString *)imageName
{
    self.selectImageView.image = [UIImage imageNamed:imageName];
    self.imageName = imageName;
    self.selected = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    PersonManager *personManager = [PersonManager sharePersonManager];
    if ([imageName isEqualToString:@"shana_miss_2"]) {
        self.selectImageView.frame = CGRectMake(5, 0, self.width, self.height);
        if (!personManager.passive_miss) {
            personManager.passive_miss = YES;
            [personManager setMiss];
        }
        
        [defaults setBool:YES forKey:kPassive_miss];
        
    }else if([imageName isEqualToString:@"blade"]){
        self.selectImageView.frame = CGRectMake((self.width - 60) / 2.0, (self.height - 60) / 2.0, 60, 60);
       
        if (!personManager.passive_fireBlade) {
            personManager.passive_fireBlade = YES;
            [personManager setFireBlade];
        }
        
        [defaults setBool:YES forKey:kPassive_fireBlade];

       
    }else if([imageName isEqualToString:@"passive_suckBlood"]){
        
        personManager.passive_suckBlood = YES;
        //100,713 / (1024 / 100)
        CGFloat width = 70.f;
        CGFloat height = 713 / (1024 / 70.f);
        CGFloat x = (self.width - width) / 2.0;
        CGFloat y = (self.height - height) / 2.0;
        self.selectImageView.frame = CGRectMake(x, y, width, height);
        
        [defaults setBool:YES forKey:kPassive_suckBlood];
    }
    
}

- (void)removePassive
{
    NSString *imageName = _imageName;
    PersonManager *personManager = [PersonManager sharePersonManager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([imageName isEqualToString:@"shana_miss_2"]) {

        personManager.passive_miss = NO;
        [personManager removeMiss];
        [defaults setBool:NO forKey:kPassive_miss];

    }else if([imageName isEqualToString:@"blade"]){

        personManager.passive_fireBlade = NO;
        [personManager removeFireBlade];
        [defaults setBool:NO forKey:kPassive_fireBlade];

    }else if([imageName isEqualToString:@"passive_suckBlood"]){
        
        personManager.passive_suckBlood = NO;
        [defaults setBool:NO forKey:kPassive_suckBlood];

    }
    
    self.selected = NO;
    self.selectImageView.image = nil;
    self.imageName = @"";
}

@end
