//
//  WDMapSelectView.m
//  begin
//
//  Created by Mac on 2018/11/6.
//  Copyright © 2018年 吴冬. All rights reserved.
//

#import "WDMapSelectView.h"

@implementation WDMapSelectView
{
    UIScrollView *_scrollView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self bgImageView];
        [self createScrollView];
        [self createCloseBtn];
    }
    return self;
}

- (void)bgImageView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"mapSelectBg" ofType:@"jpg"];
//    UIImage *mapImage = [UIImage imageWithContentsOfFile:imagePath];
    UIImage *mapImage = [UIImage imageNamed:@"mapSelectBg.jpg"];
    bgImageView.image = mapImage;
    [self addSubview:bgImageView];
}

- (void)createCloseBtn
{
    CGFloat cancelBtnWidth = 176 / 2.0;
    CGFloat cancelBtnHeight = 84 / 2.0;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - cancelBtnWidth, 20, cancelBtnWidth, cancelBtnHeight)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
}

- (void)cancelAction:(UIButton *)sender
{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    
    [self createMapView];
}

- (void)createMapView
{
   
    //目前关卡数量
    //NSInteger page = 5;
    
    
    [self createPageView:0 nowNumber:0];
    [self createBossPageView:1 image:[UIImage imageNamed:@"Boss1Scene"] mapNumber:4];
    [self createPageView:2 nowNumber:5];
    [self createBossPageView:3 image:[UIImage imageNamed:@"Boss2Scene"] mapNumber:9];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 4, 0);
    
}

- (void)createBossPageView:(NSInteger)index
                     image:(UIImage *)image
                 mapNumber:(NSInteger)number
{
    NSInteger sceneIndex = [[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex];
    CGFloat x = index * kScreenWidth;
    CGFloat page =  45 / 2.0;
    CGFloat width = kScreenWidth - page * 2.0;
    CGFloat height = kScreenHeight - page * 2.0;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + page, page, width,height)];
    [btn addTarget:self action:@selector(selectMap:) forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.backgroundColor = UICOLOR_RANDOM;
    btn.tag = number;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius  = 5.f;
    [_scrollView addSubview:btn];

    UIImage *lockIm = [UIImage imageNamed:@"lock"];

    if (sceneIndex >= number) {
        [btn setImage:image forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        btn.alpha = 0.9;
    }else{
        //130 x 130 lock
        CGFloat lockWidth = 130 / 2.0;
        btn.userInteractionEnabled = NO;
        [btn setImage:image forState:UIControlStateNormal];
        UIImageView *lockImage = [[UIImageView alloc] initWithFrame:CGRectMake((btn.width - lockWidth) / 2.0, (btn.height - lockWidth) / 2.0, lockWidth, lockWidth)];
        lockImage.image = lockIm;
        [btn addSubview:lockImage];
        btn.alpha = 0.3;
    }
}

- (void)createPageView:(NSInteger)pageIndex
             nowNumber:(NSInteger)number
{
    //NSInteger realCount = index * 4;
    
    CGFloat page = 45 / 2.0;
    CGFloat middlePage = 90 / 2.0;
    CGFloat width = (kScreenWidth - page - page - middlePage) / 2.0;
    CGFloat height = (kScreenHeight - page - page - middlePage) / 2.0;
    
    NSArray *map1NameArr = @[@"wdFirstScene.jpg",@"wdSecondScene.jpg",@"wdThirdScene.jpg",@"wdFourScene.jpg"];
    NSArray *map2NameArr = @[@"wdFifthScene.jpg",@"wdSixthScene.jpg",@"wdSevenScene.jpg",@"wdEightScene.jpg"];
    NSArray *allMapArr = @[map1NameArr,@[],map2NameArr];
   
    NSInteger sceneIndex = [[NSUserDefaults standardUserDefaults]integerForKey:kSceneIndex];
    //NSString *lockImagePath = [[NSBundle mainBundle] pathForResource:@"lock" ofType:@"png"];
    //UIImage *lockIm = [UIImage imageWithContentsOfFile:lockImagePath];
    UIImage *lockIm = [UIImage imageNamed:@"lock"];
    
    for (int i = 0; i < 4; i ++) {
        
        NSArray *mapName = allMapArr[pageIndex];
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:mapName[i] ofType:@"png"];
//        UIImage *mapImage = [UIImage imageWithContentsOfFile:imagePath];
        
        NSInteger y = page + i / 2 * (page + height + page);
        NSInteger x = page + (i % 2) * (page + width + page) + pageIndex * kScreenWidth;
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width,height)];
        [btn addTarget:self action:@selector(selectMap:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.backgroundColor = UICOLOR_RANDOM;
        btn.tag = number + i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius  = 3.f;
        [_scrollView addSubview:btn];
        
        if (number + i < sceneIndex + 1) {
            UIImage *mapImage = [UIImage imageNamed:mapName[i]];
            [btn setImage:mapImage forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
           // btn.alpha = 0.9;
        }else{
            //130 x 130 lock
            CGFloat lockWidth = 130 / 2.0;
            UIImage *mapImage = [UIImage imageNamed:mapName[i]];
            [btn setImage:mapImage forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            UIImageView *lockImage = [[UIImageView alloc] initWithFrame:CGRectMake((btn.width - lockWidth) / 2.0, (btn.height - lockWidth) / 2.0, lockWidth, lockWidth)];
            lockImage.image = lockIm;
            [btn addSubview:lockImage];
           // btn.alpha = 0.3;
        }
    }
    
    
}

- (void)selectMap:(UIButton *)sender
{
//    NSInteger page = sender.tag / 100;    //页码
//    NSInteger index = sender.tag - page * 100;
    
    NSInteger sceneIndex = sender.tag;
    
    if (self.selectSceneBlock) {
        self.selectSceneBlock(sceneIndex + 1);
    }
    
    NSLog(@"%ld",sceneIndex);
}

@end
