//
//  WDBaseModel.m
//  HotSchool
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDBaseModel.h"

@implementation WDBaseModel

- (void)setMoveArrWithPicName:(NSString *)movePicName
                        count:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++ ) {
        NSString *moveNameStr = [NSString stringWithFormat:@"%@%d",movePicName,i+1];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:moveNameStr]];
        [arr addObject:texture];
    }
    
    _moveArr = arr;
}

- (void)setStayArrWithPicName:(NSString *)stayPicName
                        count:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++ ) {
        NSString *moveNameStr = [NSString stringWithFormat:@"%@%d",stayPicName,i+1];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:moveNameStr]];
        [arr addObject:texture];
    }
    
    _stayArr = arr;
}

- (NSMutableArray <SKTexture *>*)textureArrayWithName:(NSString *)name
                                                count:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        NSString *picNameStr = [NSString stringWithFormat:@"%@%d",name,i+1];
        UIImage *image = [UIImage imageNamed:picNameStr];
        if (!image) {
            break;
        }
        SKTexture *texture = [SKTexture textureWithImage:image];
        [arr addObject:texture];
    }
    
    return arr;
}

- (NSMutableArray <SKTexture *>*)questionArr{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:72];
    //057_爱给网_aigei_com
    for (int i = 0; i < 72; i ++) {
        NSString *picNameStr = [NSString stringWithFormat:@"%03d_爱给网_aigei_com",i];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:picNameStr]];
        [arr addObject:texture];
    }
    
    return arr;
}

- (void)setTextures
{
    
}

- (void)dealloc
{
    //NSLog(@"%@ Model释放了！",self.name);
}

@end
