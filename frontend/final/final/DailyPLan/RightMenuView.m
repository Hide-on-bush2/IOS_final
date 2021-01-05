//
//  RightMenuView.m
//  final
//
//  Created by Khynnn on 2021/1/4.
//

#import "RightMenuView.h"
#import "Masonry.h"

#import "LTSCalendarManager.h"


@interface RightMenuView()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *btn1;

@end

@implementation RightMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self ) {
        [self initContent];
    }
    return self;
}
 
- (void)initContent{
    UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    self.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    //NSLog(@"%f,%f",self.frame.size.height,self.frame.size.width);
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)]];
 
    if (_contentView == nil){
        self.contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(100);
            make.right.equalTo(self.mas_right).offset(-10);
            
            make.height.mas_equalTo(150);
            make.width.mas_equalTo(150);
        }];
        
        [self addElement];
    }
    
}

- (void)addElement{
    UIView *menu1 = [[UIView alloc] init];
    //menu1.layer.borderWidth = 1.0;
    //menu1.layer.borderColor = [UIColor redColor].CGColor;
    //将UIView设为可交互的：
    menu1.userInteractionEnabled = YES;
    //添加tap手势
    UITapGestureRecognizer* meg_singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLunar:)];
    [meg_singleTap setNumberOfTapsRequired:1];
    [meg_singleTap setNumberOfTouchesRequired:1];
    [menu1 addGestureRecognizer:meg_singleTap];
    [self.contentView addSubview:menu1];
    
    UIImage *ima1 = [UIImage imageNamed:@"rightMenu1"];
    UIImageView *imageLunar = [[UIImageView alloc] initWithImage:ima1];
    //imageLunar.backgroundColor = [UIColor whiteColor];
    //imageLunar.layer.borderWidth = 1.0;
    //imageLunar.layer.borderColor = [UIColor blackColor].CGColor;
    imageLunar.contentMode = UIViewContentModeScaleAspectFit;
    [menu1 addSubview:imageLunar];
    
    UILabel* label_1 = [[UILabel alloc] init];
    label_1.text = @"阴历显隐";
    label_1.font = [UIFont systemFontOfSize:15];
    //label_1.layer.borderWidth = 1.0;
    //label_1.layer.borderColor = [UIColor yellowColor].CGColor;
    [menu1 addSubview:label_1];
    
    _btn1 = [[UIButton alloc] init];
    _btn1.layer.cornerRadius = 6.0;
    _btn1.layer.borderColor = [UIColor grayColor].CGColor;
    _btn1.layer.borderWidth = 1.0f;
    _btn1.selected = NO;
    [_btn1 setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateSelected];
    [menu1 addSubview:_btn1];
    
    [menu1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView);
        make.top.equalTo(_contentView).with.offset(10);
        make.right.equalTo(_contentView);
        
        make.height.mas_equalTo(40);
    }];
    [imageLunar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(menu1).with.offset(20);
        make.top.equalTo(menu1).with.offset(10);
        make.bottom.equalTo(menu1).with.offset(-10);
        
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menu1);
        make.left.equalTo(imageLunar.mas_right).offset(15);
        make.bottom.equalTo(menu1);
    }];
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(menu1).with.offset(-10);
        make.top.equalTo(menu1).with.offset(14);
        make.bottom.equalTo(menu1).with.offset(-14);
        
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(12);
    }];
    
    UIView *menu2 = [[UIView alloc] init];
    //menu2.layer.borderWidth = 1.0;
    //menu2.layer.borderColor = [UIColor redColor].CGColor;
    menu2.userInteractionEnabled = YES;
    UITapGestureRecognizer* today_singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackToday:)];
    [today_singleTap setNumberOfTapsRequired:1];
    [today_singleTap setNumberOfTouchesRequired:1];
    [menu2 addGestureRecognizer:today_singleTap];
    [self.contentView addSubview:menu2];
    
    UIImage *ima2 = [UIImage imageNamed:@"today"];
    UIImageView *imageToday = [[UIImageView alloc] initWithImage:ima2];
    imageToday.contentMode = UIViewContentModeScaleAspectFit;
    [menu2 addSubview:imageToday];
    
    UILabel* label_2 = [[UILabel alloc] init];
    label_2.text = @"回到今天";
    label_2.font = [UIFont systemFontOfSize:15];
    //label_2.layer.borderWidth = 1.0;
    //label_2.layer.borderColor = [UIColor yellowColor].CGColor;
    [menu2 addSubview:label_2];
    
    [menu2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView);
        make.top.equalTo(menu1.mas_bottom);
        make.right.equalTo(_contentView);
        
        make.height.mas_equalTo(40);
    }];
    [imageToday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(menu2).with.offset(20);
        make.top.equalTo(menu2).with.offset(10);
        make.bottom.equalTo(menu2).with.offset(-10);
        
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menu2);
        make.left.equalTo(imageToday.mas_right).offset(15);
        make.bottom.equalTo(menu2);
    }];
    
    UIView *menu3 = [[UIView alloc] init];
    //menu3.layer.borderWidth = 1.0;
    //menu3.layer.borderColor = [UIColor redColor].CGColor;
    menu3.userInteractionEnabled = YES;
    UITapGestureRecognizer* fen_singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fenXiang:)];
    [fen_singleTap setNumberOfTapsRequired:1];
    [fen_singleTap setNumberOfTouchesRequired:1];
    [menu3 addGestureRecognizer:fen_singleTap];
    [self.contentView addSubview:menu3];
    
    UIImage *ima3 = [UIImage imageNamed:@"fenxiang"];
    UIImageView *imageFen = [[UIImageView alloc] initWithImage:ima3];
    imageFen.contentMode = UIViewContentModeScaleAspectFit;
    [menu3 addSubview:imageFen];
    
    UILabel* label_3 = [[UILabel alloc] init];
    label_3.text = @"分享";
    label_3.font = [UIFont systemFontOfSize:15];
    //label_3.layer.borderWidth = 1.0;
    //label_3.layer.borderColor = [UIColor yellowColor].CGColor;
    [menu3 addSubview:label_3];
    
    [menu3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView);
        make.top.equalTo(menu2.mas_bottom);
        make.right.equalTo(_contentView);
        
        make.height.mas_equalTo(40);
    }];
    [imageFen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(menu3).with.offset(17);
        make.top.equalTo(menu3).with.offset(5);
        make.bottom.equalTo(menu3).with.offset(-5);
        
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    [label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menu3);
        make.left.equalTo(imageFen.mas_right).offset(8);
        make.bottom.equalTo(menu3);
    }];
}

- (void)showLunar:(UITapGestureRecognizer *)sender{
    [self notificate_lunar];
    _btn1.selected = !_btn1.selected;
    NSLog(@"%d",_btn1.selected);
}
- (void)notificate_lunar{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goBackToday" object:nil];
}

- (void)fenXiang:(UITapGestureRecognizer *)sender{
    //NSLog(@"fenxiang");
    [self notificate_share];
}
- (void)notificate_share{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sharePlan" object:nil];
}

- (void)goBackToday:(UITapGestureRecognizer *)sender{
    [self notificate_today];
}
- (void)notificate_today{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goBackToday" object:nil];
}

- (void)showAlert:(UIView *)view{
    if (!view) {
        return;
    }
    [view addSubview:self];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.1;
    }];
    
    [view addSubview:_contentView];

    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(100);
        make.right.equalTo(self.mas_right).offset(-10);
        
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(150);
    }];

    self.contentView.transform = CGAffineTransformMakeTranslation(0.01, view.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
}
 
- (void)dismissAlert {
    UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, window.frame.size.height);
        self.contentView.alpha = 0.1;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
}



@end
