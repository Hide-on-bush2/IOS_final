//
//  DailyPlanVC+_.m
//  final
//
//

#import "DailyPlanVC.h"

#import "LTSCalendarManager.h"
#import "RightMenuView.h"
#import "ShareVC.h"
#import "AddSimplePlanView.h"
#import "AddPlanVC.h"

#import "Masonry.h"

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface DailyPlanVC ()<LTSCalendarEventSource>{
    NSMutableDictionary *eventsByDate;
}
//@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic,strong)LTSCalendarManager *manager;

@property(strong, nonatomic) UIButton *send;
@property (nonatomic,strong)AddSimplePlanView* AddView;

@end

@implementation DailyPlanVC
/*
- (IBAction)changeColor:(id)sender {
     [LTSCalendarAppearance share].calendarBgColor = RandColor;
     [LTSCalendarAppearance share].weekDayBgColor = RandColor;
     [LTSCalendarAppearance share].dayCircleColorSelected = RandColor;
     [LTSCalendarAppearance share].dayCircleColorToday = RandColor;
     [LTSCalendarAppearance share].dayBorderColorToday = RandColor;
     [LTSCalendarAppearance share].dayDotColor = RandColor;
     [LTSCalendarAppearance share].dayDotColor = RandColor;
    [LTSCalendarAppearance share].lunarDayTextColor = RandColor;
    
    [self.manager reloadAppearanceAndData];
 
}*/
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tabBarItem.title = nil; 
    [self lts_InitUI];
    
    //观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowLunar) name:@"isShowLunar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackToday) name:@"goBackToday" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sharePlan) name:@"sharePlan" object:nil];
    
    if(self.send == nil){
        self.send = [[UIButton alloc] init];
        //半径
        self.send.layer.cornerRadius = 30;
        //裁边
        self.send.layer.masksToBounds = YES;
        [self.send setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.send addTarget:self action:@selector(Sendit:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.send];

    [self.send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(310);
        make.top.equalTo(self.view).with.offset(680);
        
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPlusPlan) name:@"addPlusPlan" object:nil];
}

#pragma mark - 添加计划
-(void)Sendit:(id)sender{
    _AddView = [[AddSimplePlanView alloc] init];
    [_AddView showAlert:self.view];
}

- (void)addPlusPlan{
    [_AddView dismissAlert];
    AddPlanVC *vc = [[AddPlanVC alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    [self customPresentWith:@"oglFlip" controller:vc];
}
#pragma mark - menu
- (void)isShowLunar{
    [LTSCalendarAppearance share].isShowLunarCalender = ![LTSCalendarAppearance share].isShowLunarCalender;
   //重新加载外观
    [self.manager reloadAppearanceAndData];
}

- (void)goBackToday{
    [self.manager goBackToday];
}

- (void)sharePlan{
    ShareVC *newpage = [[ShareVC alloc] init];
    [self customPresentWith:@"oglFlip" controller:newpage];
}
- (void)customPresentWith:(NSString *)type
               controller:(UIViewController *)view{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = type;
    //可以改变subtype的类型
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:nav animated:YES completion:nil];
}
/*
- (IBAction)allweek:(id)sender {
    [self.manager showAllWeek];
}
- (IBAction)singleweek:(id)sender {
    [self.manager showSingleWeek];
}*/
#pragma mark -  init
- (void)lts_InitUI{
    
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame))];
    [self.view addSubview:self.manager.calenderScrollView];
    [self createRandomEvents];
    //self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gengduo2"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    RightMenuView* view = [[RightMenuView alloc] init];
    [view showAlert:self.view];
}
- (void)leftBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    NSLog(@"待添加...");
}

// 该日期是否有事件
- (BOOL)calendarHaveEventWithDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    //self.navigationController.title =  key;
    [self.navigationController.navigationItem setTitle:key];
    self.tabBarItem.title = @"";
    NSArray *events = eventsByDate[key];
    self.title = key;
    NSLog(@"%@",date);
    if (events.count>0) {
        
        //该日期有事件    tableView 加载数据
    }
}

/*

- (IBAction)nextMonth:(id)sender {
    [self.manager loadNextPage];
}

- (IBAction)previousMonth:(id)sender {
    [self.manager loadPreviousPage];
}
- (IBAction)monday:(id)sender {
    [LTSCalendarAppearance share].firstWeekday = 2;
    [self.manager reloadAppearanceAndData];
}
- (IBAction)sunday:(id)sender {
    [LTSCalendarAppearance share].firstWeekday = 1;

    [self.manager reloadAppearanceAndData];
}
- (IBAction)full:(id)sender {
    [LTSCalendarAppearance share].weekDayFormat = LTSCalendarWeekDayFormatFull;
    [self.manager.weekDayView reloadAppearance];
}
- (IBAction)fullShort:(id)sender {
    [LTSCalendarAppearance share].weekDayFormat = LTSCalendarWeekDayFormatShort;
    [self.manager.weekDayView reloadAppearance];
}
- (IBAction)single:(id)sender {
    [LTSCalendarAppearance share].weekDayFormat = LTSCalendarWeekDayFormatSingle;
    [self.manager.weekDayView reloadAppearance];
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];

    for(int i = 0; i < 10; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];

        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];

        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }

        [eventsByDate[key] addObject:randomDate];
    }
    
    [self.manager reloadAppearanceAndData];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    return dateFormatter;
}

@end
