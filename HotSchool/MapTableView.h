//
//  MapTableView.h
//  begin
//
//  Created by Mac on 2019/4/23.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapTableView : UITableView
@property (nonatomic,copy)void (^selectSceneBlock)(NSInteger sceneIndex);

@end

NS_ASSUME_NONNULL_END
