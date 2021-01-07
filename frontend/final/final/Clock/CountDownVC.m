//
//  CountDownVC+_.m
//  final
//
//  Created by jinshlin on 2021/1/5.
//

#import "CountDownVC.h"
#import "CycleView.h"

#define PROGRESSW self.view.frame.size.width
#define PROGRESSH self.view.frame.size.height


@interface CountDownVC ()
{
    CycleView *cycle;
    NSTimer * _timer;  //定时器
    NSInteger _seconds;
}

@property (strong, nonatomic) UIButton * ssButton;
@property (strong, nonatomic) UIButton * endButton;
@property (strong, nonatomic) UILabel *countLabel;
@property (assign, nonatomic) NSInteger totalTime;

@end

@implementation CountDownVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"倒计时";
    cycle = [[CycleView alloc]initWithFrame:CGRectMake((PROGRESSW-150)/5, 240, 300, 300)];
    [self.view addSubview:cycle];
    
    [self _loadViews];
}


- (void) _loadViews{
    
    self.ssButton = [[UIButton alloc]initWithFrame:CGRectMake((PROGRESSW-60)/2.5, 620, 120, 40)];
    self.ssButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    self.ssButton.backgroundColor = [UIColor colorWithRed:92./256. green:128./256. blue:221./256. alpha:1.];
    [self.ssButton setTitle:@"开始" forState:UIControlStateNormal];
    [self.ssButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.ssButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ssButton addTarget:self action:@selector(countDownEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.ssButton.layer setMasksToBounds:YES];
    [self.ssButton.layer setCornerRadius:10];
    self.ssButton.tag = 1;
    
    self.endButton = [[UIButton alloc]initWithFrame:CGRectMake((PROGRESSW-60)/2.5, 680, 120, 40)];
    self.endButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    self.endButton.backgroundColor = [UIColor colorWithRed:92./256. green:128./256. blue:221./256. alpha:1.];
    [self.endButton setTitle:@"结束" forState:UIControlStateNormal];
    [self.endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endButton addTarget:self action:@selector(endEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.endButton.layer setMasksToBounds:YES];
    [self.endButton.layer setCornerRadius:10];
    self.endButton.tag = 1;
    
    self.totalTime = 600;
    
    UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 80)];
    countLabel.center = cycle.center;
    countLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:self.view.frame.size.width/7];
    countLabel.textAlignment = NSTextAlignmentCenter;
    NSString * startTime=[NSString stringWithFormat:@"%d:%02li",self.totalTime/60,self.totalTime%60];
    countLabel.text=startTime;
    [self.view addSubview:self.countLabel = countLabel];
    
    [self.view addSubview:self.ssButton];
    [self.view addSubview:self.endButton];

}


-(void)countDownEvent:(UIButton*)button
{
    button.selected = !button.selected;
    if(_timer==nil)
    {
        cycle.progress = 1;
        //每隔1秒刷新一次页面
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        NSLog(@"开始计时.....");
    }
    else
    {
        [_timer invalidate];   //让定时器失效
        cycle.progress = 0;
        _timer=nil;
        NSString * startTime=[NSString stringWithFormat:@"%d:%02li",self.totalTime/60,self.totalTime%60];
        self.countLabel.text=startTime;
        NSLog(@"停止");
        
    }
}

-(void)endEvent:(id)sender{
    self.totalTime = 600;
    NSString * startTime=[NSString stringWithFormat:@"%d:%02li",self.totalTime/60,self.totalTime%60];
    self.countLabel.text=startTime;
    NSLog(@"结束");
}

#pragma mark - runAction
- (void) runAction
{
    self.totalTime--;
    NSString * startTime=[NSString stringWithFormat:@"%d:%02li",self.totalTime/60,self.totalTime%60];
    self.countLabel.text=startTime;
    [self.view addSubview:self.countLabel];
    
}




@end
