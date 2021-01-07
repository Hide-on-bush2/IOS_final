//
//  ClockVC.m
//  final
//
//  Created by jinshlin on 2020/12/21.
//

#import "ClockVC.h"
#import "CountDownVC.h"
#import "Masonry.h"

#define kW self.view.frame.size.width
#define kH self.view.frame.size.height
int count=0;

@interface ClockVC ()
{
        NSTimer * _timer;  //定时器
        NSInteger _seconds;
}

//开始暂停按钮
@property (nonatomic,weak) UIButton * ssButton;

//计次按钮
@property (nonatomic,weak) UIButton * jcButton;

//右上角计次时间
@property (nonatomic,weak) UILabel * conLabel;

//中间秒表
@property (nonatomic,weak) UILabel * ctLabel;

//下面的每次记录的时间
@property (nonatomic,weak) UITableView * tableView;

//
@property (nonatomic,weak) UITableViewCell * cell;

//存放记录的数组
@property (nonatomic,strong) NSMutableArray * jcArray;

@end


@implementation ClockVC 

#pragma mark - 懒加载
- (NSMutableArray *)jcArray
{
    if (_jcArray==nil)
    {
        _jcArray=[NSMutableArray array];
    }
    return  _jcArray;
}

#pragma mark - 入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadViews];
}

- (void) _loadViews
{
    self.navigationItem.title=@"秒表";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"countdown"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    //小时钟---一直计时
    UILabel * conLabel=[[UILabel alloc]initWithFrame:CGRectMake(267, 90, 110, 50)];
    //conLabel.backgroundColor=[UIColor redColor];
    conLabel.text=@"00:00";
    conLabel.font=[UIFont fontWithName:nil size:25];
    self.conLabel=conLabel;
    [self.view addSubview:conLabel];
    
    //秒表
    UILabel * ctLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,120,kW,150)];
    //ctLabel.backgroundColor=[UIColor redColor];
    ctLabel.text=@"00:00";
    ctLabel.textAlignment=NSTextAlignmentCenter;
    ctLabel.font=[UIFont fontWithName:nil size:75];
    self.ctLabel=ctLabel;
    [self.view addSubview:ctLabel];
    
    //下方视图
    UIView * bView=[[UIView alloc]initWithFrame:CGRectMake(0,300,kW,140)];
    bView.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    
    [self.view addSubview:bView];
    
    //NSLog(@"%f",bView.frame.origin.y);
    
    //开始停止按钮
    UIButton * ssButton=[[UIButton alloc]initWithFrame:CGRectMake((kW-200)/3, 20, 100, 100)];
    ssButton.backgroundColor=[UIColor whiteColor];
    ssButton.layer.cornerRadius=50;
    [ssButton setTitle:@"开始" forState:UIControlStateNormal];
    [ssButton setTitle:@"停止" forState:UIControlStateSelected];
    [ssButton setTitleColor:[UIColor colorWithRed:92./256. green:128./256. blue:221./256. alpha:1.] forState:UIControlStateNormal];
    [ssButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    ssButton.tag=1;
    [ssButton addTarget:self action:@selector(StartStop:) forControlEvents:UIControlEventTouchUpInside];
    self.ssButton=ssButton;
    [bView addSubview:ssButton];
    
    
    //计次按钮
    UIButton * jcButton=[[UIButton alloc]initWithFrame:CGRectMake(((kW-200)/3)*2+100, 20, 100, 100)];
    jcButton.backgroundColor=[UIColor whiteColor];
    jcButton.layer.cornerRadius=50;
    [jcButton setTitle:@"计次" forState:UIControlStateNormal];
    [jcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [jcButton addTarget:self action:@selector(CountNum) forControlEvents:UIControlEventTouchUpInside];
    self.jcButton=jcButton;
    [bView addSubview:jcButton];
    
    //点击计次按钮时记录的每次时间,存放到对应的cell上
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 450, kW, kH-370-60) style:UITableViewStylePlain];
    tableView.rowHeight=50;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    
}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    
    CountDownVC *VC = [[CountDownVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
     
}

#pragma mark - ssButton按钮的点击事件
- (void)StartStop:(UIButton*)button
{
    button.selected = !button.selected;
    if(_timer==nil)
    {
        //每隔0.01秒刷新一次页面
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        NSLog(@"开始计时.....");
    }
    else
    {
        [_timer invalidate];   //让定时器失效
        _timer=nil;
        _ctLabel.text=@"00:00";
        _conLabel.text=@"00:00";
        _seconds=0;
        self.cell=nil;
        self.jcArray=nil;
        [self.tableView reloadData];
        NSLog(@"计时停止.....");
    }
    
    
}


#pragma mark - runAction
- (void) runAction
{
    _seconds++;
    //动态改变开始时间
    NSString * startTime=[NSString stringWithFormat:@"%02li:%02li",_seconds/100/60%60,_seconds/100%60];
    _ctLabel.text=startTime;
    
}

#pragma mark - 计次
- (void)CountNum
{
    count++;
    _conLabel.text=_ctLabel.text;
   // NSLog(@"这是记录的第**** %i ****个时间数据: %@",count,_conLabel.text);
    [self.jcArray addObject:_conLabel.text];
//    NSLog(@"%@",self.jcArray);
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identy=@"JRTable";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identy];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
    }
    cell.textLabel.text = self.jcArray[indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    self.cell=cell;
    return  self.cell;
}

@end
