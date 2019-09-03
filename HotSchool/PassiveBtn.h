//
//  PassiveBtn.h
//  begin
//
//  Created by Mac on 2019/4/25.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassiveBtn : UIButton
@property (nonatomic,strong)UIImageView *selectImageView;
@property (nonatomic,copy)NSString *imageName;


/** 开启被动 */
- (void)setImageViewWithName:(NSString *)imageName;

/** 关闭被动 */
- (void)removePassive;
@end

NS_ASSUME_NONNULL_END
