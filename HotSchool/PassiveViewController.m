//
//  PassiveViewController.m
//  begin
//
//  Created by Mac on 2019/4/24.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "PassiveViewController.h"
#import "PassiveBtn.h"
typedef NS_ENUM(NSInteger, BTN_TYPE)
{
    CENTER = 300,
    LEFT,
    RIGHT,
};

@interface PassiveViewController ()
{
    UIScrollView *_bgScrollView;
    NSArray      *_passiveDataArr;
    
    PassiveBtn *_centerBtn;
    PassiveBtn *_leftBtn;
    PassiveBtn *_rightBtn;
}
@end

@implementation PassiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_RGB(199, 237, 204, 1);
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgScrollView.backgroundColor = UICOLOR_RGB(199, 237, 204, 1);
    _bgScrollView.pagingEnabled = YES;
    [self.view addSubview:_bgScrollView];
    
    [self createPassiveView];
   
    [self createCloseBtn];
    
    [self createPassiveSelectView];
}

- (void)createPassiveSelectView
{
    CGFloat width = 85;
    
    _centerBtn = [[PassiveBtn alloc] initWithFrame:CGRectMake((kScreenWidth - width) / 2.0, kScreenHeight - width - 20, width, width)];
    [_centerBtn addTarget:self action:@selector(removePassiveAction:) forControlEvents:UIControlEventTouchUpInside];
    _centerBtn.tag = CENTER;
    [_centerBtn setImage:[UIImage imageNamed:@"attackOpeation"] forState:UIControlStateNormal];
    [self.view addSubview:_centerBtn];
    
    
    _leftBtn = [[PassiveBtn alloc] initWithFrame:CGRectMake(_centerBtn.left - width - 30, kScreenHeight - width - 20, width, width)];
    [_leftBtn addTarget:self action:@selector(removePassiveAction:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.tag = LEFT;
    [_leftBtn setImage:[UIImage imageNamed:@"attackOpeation"] forState:UIControlStateNormal];
    [self.view addSubview:_leftBtn];
    
    
    _rightBtn = [[PassiveBtn alloc] initWithFrame:CGRectMake(_centerBtn.right + 30, kScreenHeight - width - 20, width, width)];
    [_rightBtn addTarget:self action:@selector(removePassiveAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.tag = RIGHT;
    [_rightBtn setImage:[UIImage imageNamed:@"attackOpeation"] forState:UIControlStateNormal];
    [self.view addSubview:_rightBtn];
    
    PersonManager *manager = [PersonManager sharePersonManager];
    
    if (manager.passive_fireBlade) {
        [self setBtnImage:@"blade"];
    }
    
    if (manager.passive_miss) {
        [self setBtnImage:@"shana_miss_2"];
    }
    
    if (manager.passive_suckBlood) {
        [self setBtnImage:@"passive_suckBlood"];
    }
    
}



- (void)createPassiveView
{
    //722 523
    CGFloat width = 722 / 2.0;
    CGFloat height = 523 / 2.0;
    
    
    int Level = 10; //10个关卡
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int allStarCount = 0;
    for (int i = 0; i < Level; i ++) {
        NSString *key = [NSString stringWithFormat:@"starNum_%d",i];
        allStarCount += [defaults integerForKey:key];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
    NSArray *passiveSkill = @[@"blade",@"shana_miss_2",@"passive_suckBlood",@"",@""];
    for (int i = 0; i < 3; i ++) {
        NSString *name = @"learnPassive";
        [arr addObject:name];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - width) / 2.0 + i * kScreenWidth, (kScreenHeight - height) / 2.0 - 50, width, height)];
        imageView.image = [UIImage imageNamed:@"learnPassive"];
        imageView.userInteractionEnabled = YES;
        [_bgScrollView addSubview:imageView];
        
        UIImageView *passiveImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        passiveImageV.image = [UIImage imageNamed:passiveSkill[i]];
        [imageView addSubview:passiveImageV];
        // passiveImageV.backgroundColor = [UIColor cyanColor];
        // passiveImageV.alpha = 0.7;
        [self setImageViewWithIndex:i imageView:passiveImageV superImageView:imageView];
        
        CGFloat btnWidth = 60.f;
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake((imageView.width - btnWidth) / 2.0, imageView.height - btnWidth - 20, btnWidth, btnWidth);
        [selectBtn setImage:[UIImage imageNamed:@"attackOpeation"] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = i + 100;
        selectBtn.userInteractionEnabled = NO;
        [imageView addSubview:selectBtn];
        
        [self setSelectImageWithAllStar:allStarCount index:i imageView:selectBtn];
        
    }
    
    _passiveDataArr = arr;
    
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth * _passiveDataArr.count, 0);
}


//小按钮上的图片
- (void)setSelectImageWithAllStar:(int)allStar
                            index:(int)index
                        imageView:(UIButton *)selectBtn
{
    
    UIImageView *greenImageV = [[UIImageView alloc] initWithFrame:CGRectMake((60 - 45.f) / 2.0, (60 - 45.f) / 2.0, 45.f, 45.f)];
    greenImageV.image = [UIImage imageNamed:@"lock"];
    [selectBtn addSubview:greenImageV];
    
    switch (index) {
        case 0:
        {
            if (allStar >= 10) {
                greenImageV.image = [UIImage imageNamed:@"blade"];
                selectBtn.userInteractionEnabled = YES;
            }
            
        }
            break;
            case 1:
        {
            if (allStar >= 12) {
                greenImageV.image = [UIImage imageNamed:@"shana_miss_2"];
                greenImageV.frame = CGRectMake(0, 0, 60, 60);
                selectBtn.userInteractionEnabled = YES;
            }
        }
            break;
        case 2:
        {
            if(allStar >= 14){
                greenImageV.image = [UIImage imageNamed:@"passive_suckBlood"];
                //100,713 / (1024 / 100)
                CGFloat width = 45.f;
                CGFloat height = 713 / (1024 / 45.f);
                CGFloat x = (60 - width) / 2.0;
                CGFloat y = (60 - height) / 2.0;
                greenImageV.frame = CGRectMake(x, y, width, height);
                selectBtn.userInteractionEnabled = YES;
            }
        }
            break;
            
            
        default:
            break;
    }
}

- (void)setImageViewWithIndex:(int)index
                    imageView:(UIImageView *)passiveImageView
               superImageView:(UIImageView *)bgImageView
{
    NSArray *fontArr = [UIFont familyNames];
    NSString *fontName = fontArr[27];
    UIFont *font = [UIFont fontWithName:fontName size:25];
    switch (index) {
        case 0:
        {
            NSString *text = @"attack + 10\nunlock --> 10 star";
            CGSize size = [text boundingRectWithSize:CGSizeMake(bgImageView.width - 40 - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
            passiveImageView.frame = CGRectMake(40, 40, 80, 80);
            UILabel *attackLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 + 80 + 10, 40, size.width, size.height)];
            attackLabel.text = text;
            attackLabel.font = font;
            attackLabel.numberOfLines = 0;
            attackLabel.textColor = [UIColor whiteColor];
            //attackLabel.backgroundColor = [UIColor cyanColor];
            [bgImageView addSubview:attackLabel];
        }
            break;
            case 1:
        {
            font = [UIFont fontWithName:fontName size:23];
            passiveImageView.frame = CGRectMake(5,20, 160, 160);
            NSString *text = @"miss + %100\ncd 6s, continued 4s\nunlock --> 12 star";
            CGSize size = [text boundingRectWithSize:CGSizeMake(bgImageView.width - 40 - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
            UILabel *attackLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 + 80 + 10, 40, size.width, size.height)];
            attackLabel.text = text;
            attackLabel.font = font;
            attackLabel.numberOfLines = 0;
            attackLabel.textColor = [UIColor whiteColor];
            //attackLabel.backgroundColor = [UIColor cyanColor];
            [bgImageView addSubview:attackLabel];
        }
            break;
            case 2:
        {
            //1024 × 713
            font = [UIFont fontWithName:fontName size:25];
            passiveImageView.frame = CGRectMake(30,45, 100,713 / (1024 / 100));
            NSString *text = @"Suck Blood %5\nunlock --> 12 star";
            CGSize size = [text boundingRectWithSize:CGSizeMake(bgImageView.width - 40 - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
            UILabel *attackLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 + 80 + 10, 40, size.width, size.height)];
            attackLabel.text = text;
            attackLabel.font = font;
            attackLabel.numberOfLines = 0;
            attackLabel.textColor = [UIColor whiteColor];
            //attackLabel.backgroundColor = [UIColor cyanColor];
            [bgImageView addSubview:attackLabel];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark 选中技能
- (void)selectAction:(UIButton *)sender
{
    if (sender.tag == 100) {
        [self setBtnImage:@"blade"];
    }else if(sender.tag == 101){
        [self setBtnImage:@"shana_miss_2"];
    }else if(sender.tag == 102){
        [self setBtnImage:@"passive_suckBlood"];
    }
    
    NSLog(@"选中技能了！ %ld",sender.tag);
}


- (void)setBtnImage:(NSString *)imageName
{
    
    if ([imageName isEqualToString:_leftBtn.imageName]||[imageName isEqualToString:_centerBtn.imageName]||[imageName isEqualToString:_rightBtn.imageName]) {
        return;
    }
    
    if (!_leftBtn.selected) {

        [_leftBtn setImageViewWithName:imageName];
       
    }else if(!_centerBtn.selected){
        
        [_centerBtn setImageViewWithName:imageName];
        
    }else if(!_rightBtn.selected){
        
        [_rightBtn setImageViewWithName:imageName];
        
    }
}

#pragma mark 取消技能
- (void)removePassiveAction:(PassiveBtn *)sender
{
    [sender removePassive];
    
    /*
    switch (sender.tag) {
        case CENTER:
        {
            NSLog(@"选中中间按钮");
        }
            break;
        case LEFT:
        {
            NSLog(@"选中左边按钮");
        }
            break;
        case RIGHT:
        {
            NSLog(@"选中右边按钮");
        }
            break;
            
        default:
            break;
    }
     */
     
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
