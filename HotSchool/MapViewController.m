//
//  MapViewController.m
//  begin
//
//  Created by Mac on 2019/4/23.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "MapViewController.h"
#import "MapTableView.h"
#import "MapCollectionView.h"
@interface MapViewController ()
{
    MapTableView *_normalTableView;
    UIScrollView *_bgScrollView;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"gogogo.jpg"];
    [self.view addSubview:imageView];
    
 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createCollectionTableView];
    [self createCloseBtn];
}

- (void)createCloseBtn
{
    CGFloat cancelBtnWidth = 176 / 2.0;
    CGFloat cancelBtnHeight = 84 / 2.0;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - cancelBtnWidth, 20, cancelBtnWidth, cancelBtnHeight)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
}

- (void)cancelAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"地图map消失");
    }];
}

- (void)createCollectionTableView
{
    NSLog(@"%@",[NSThread currentThread]);
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_bgScrollView];
    
    _bgScrollView.pagingEnabled = YES;
    
    CGFloat leftPage = 10;
    CGFloat topPage  = 10;
    
    CGFloat page = 10;
    
    
    CGFloat width = (kScreenWidth - leftPage * 5.f) / 4.0;
    CGFloat height = (kScreenHeight - topPage * 4.f) / 3.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(page, page, page, page);
    layout.minimumLineSpacing = page;
    layout.minimumInteritemSpacing = page;
    
    NSArray *mapAllArr = @[@[@"wdFirstScene.jpg",@"wdSecondScene.jpg",@"wdThirdScene.jpg",@"wdFourScene.jpg",@"Boss1Scene",@"wdFifthScene.jpg",@"wdSixthScene.jpg",@"wdSevenScene.jpg",@"wdEightScene.jpg",@"Boss2Scene",@"wdNinthScene.jpg",@"wdTenScene.jpg"],
  @[@"WD11Scene.jpg",@"WD12Scene.jpg",@"thirdSceneImage",@"wdFourScene.jpg",@"Boss1Scene",@"wdFifthScene.jpg",@"wdSixthScene.jpg",@"wdSevenScene.jpg",@"wdEightScene.jpg",@"Boss2Scene",@"wdNinthScene.jpg",@"Boss1Scene"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *bigStarArr = [NSMutableArray arrayWithCapacity:mapAllArr.count];
    for (int i = 0; i < mapAllArr.count; i ++) {
       
        NSArray *mapArrs = mapAllArr[i];
        NSMutableArray *starArr = [NSMutableArray array];
        for (int j = 0; j < mapArrs.count; j ++) {
            NSString *key = [NSString stringWithFormat:@"starNum_%d",j + i * 12];
            NSInteger starCount = [defaults integerForKey:key];
            [starArr addObject:@(starCount)];
        }
        
        [bigStarArr addObject:starArr];
       
    }
    
    
    
    for (int i = 0; i < mapAllArr.count; i++) {
        CGFloat x = i * kScreenWidth;
        MapCollectionView *collectionView = [[MapCollectionView alloc] initWithFrame:CGRectMake(x, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        collectionView.mapArr = mapAllArr[i];
        collectionView.starArr = bigStarArr[i];
        collectionView.starIndex = i * 12;
        [_bgScrollView addSubview:collectionView];
        
        __weak typeof(self)weakSelf = self;
        [collectionView setSelectSceneBlock:^(NSInteger sceneIndex) {
            if (weakSelf.selectSceneBlock) {
                weakSelf.selectSceneBlock(sceneIndex);
            }
            
            [weakSelf dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }
   
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth * mapAllArr.count, 0);
}

- (void)createNormalTableView
{
    _normalTableView = [[MapTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _normalTableView.pagingEnabled = YES;
    [self.view addSubview:_normalTableView];
    
    __weak typeof(self)weakSelf = self;
    [_normalTableView setSelectSceneBlock:^(NSInteger sceneIndex) {
        if (weakSelf.selectSceneBlock) {
            weakSelf.selectSceneBlock(sceneIndex);
        }
        
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    NSInteger index = [[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex];
    index -= 1;
    if (index >= 0) {
         [_normalTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
   
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"地图map消失");
    }];
}



@end
