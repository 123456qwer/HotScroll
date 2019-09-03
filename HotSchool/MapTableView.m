//
//  MapTableView.m
//  begin
//
//  Created by Mac on 2019/4/23.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "MapTableView.h"
#import "MapTableViewCell.h"
@interface MapTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_mapArr;
    NSArray *_starArr;  //每一关的星星数量
    NSInteger _nowMapIndex;
}

@end

@implementation MapTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        _nowMapIndex = [[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex];
        [self setMapArr];
        [self registerNib:[UINib nibWithNibName:@"MapTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    
    return self;
}

- (void)setMapArr{
    _mapArr = @[@"wdFirstScene.jpg",@"wdSecondScene.jpg",@"wdThirdScene.jpg",@"wdFourScene.jpg",@"Boss1Scene",@"wdFifthScene.jpg",@"wdSixthScene.jpg",@"wdSevenScene.jpg",@"wdEightScene.jpg",@"Boss2Scene",@"wdNinthScene.jpg"];
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *starArr = [NSMutableArray arrayWithCapacity:_mapArr.count];
    for (int i = 0; i < _mapArr.count; i ++) {
        NSString *key = [NSString stringWithFormat:@"starNum_%d",i];
        NSInteger starCount = [defaults integerForKey:key];
        [starArr addObject:@(starCount)];
    }
    
    _starArr = starArr;
}

#pragma mark ----tableViewDataSource----
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = UICOLOR_RGB(204, 232, 207, 1);
    cell.mapImageView.image = [UIImage imageNamed:_mapArr[indexPath.row]];
    
    [cell setStarWithStarCount:[_starArr[indexPath.row]integerValue]];
    if (indexPath.row <= _nowMapIndex) {
        cell.lockImageView.hidden = YES;
    }else{
        cell.lockImageView.hidden = NO;
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mapArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark ----tableViewDelegate----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > _nowMapIndex) {
        return;
    }
    
    NSLog(@"%ld",indexPath.row);
    if (_selectSceneBlock) {
        _selectSceneBlock(indexPath.row + 1);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MapTableViewCell *acell = (MapTableViewCell *)cell;
    acell.mapImageView.alpha = 0.3;
    [UIView animateWithDuration:1 animations:^{
        acell.mapImageView.alpha = 1;
    }];
    
    
}

@end
