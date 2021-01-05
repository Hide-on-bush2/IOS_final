//
//  LTSCalendarScrollView.m
//  LTSCalendar
//

#import "LTSCalendarScrollView.h"
#import "RecordModel.h"
#import "DynamicCell.h"
#import "Masonry.h"

#import "LTSCalendarManager.h"

#import "TestData.h"

@interface LTSCalendarScrollView()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong)UIView *line;
//日期
@property (nonatomic,strong , readonly) NSDate *currentSelectedDate;

@property (nonatomic, strong) UIButton *sectionTitleBtns;

@end

@implementation LTSCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
/*
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}
*/
- (void)initUI{
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    //self.backgroundColor = [LTSCalendarAppearance share].scrollBgcolor;
    self.backgroundColor = [UIColor whiteColor];
    LTSCalendarContentView *calendarView = [[LTSCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, 390, [LTSCalendarAppearance share].weekDayHeight*[LTSCalendarAppearance share].weeksToDisplay)];
    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    //self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame),0.5)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame))];
    self.tableView.backgroundColor = self.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.scrollEnabled = [LTSCalendarAppearance share].isShowSingleWeek;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:self.tableView];
    
    //self.line.backgroundColor = self.backgroundColor;
    //[self addSubview:self.line];
    [LTSCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_tableView addGestureRecognizer:longPress];
    
    //观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"updateData" object:nil];
    [self showContent];
}

- (void)updateData{
    [self showContent];
    [_tableView reloadData];
    //[self viewDidLoad];
    NSLog(@"updateData");
}

- (UIButton *)sectionTitleBtns{
    if (!_sectionTitleBtns) {
        _sectionTitleBtns = [[UIButton alloc] init];
        [_sectionTitleBtns setSelected:YES];
    }
    return _sectionTitleBtns;
}

#pragma mark - tableView Data
- (void)showContent{
    _dataArray = [NSMutableArray array];
    
    NSMutableArray *temp = [NSMutableArray array];
    for(id key in [[TestData singleInstance] detailWithNotCompleted]){
        RecordModel *model = [[RecordModel alloc]init];
        model.title = key[@"title"];
        model.date = key[@"date"];
        model.priority = key[@"priority"];
        model.isCompleted = key[@"isCompleted"];
        model.type = key[@"type"];
        model.tag = key[@"tag"];
        model.ID = key[@"ID"];
        
        [temp addObject:model];
    }
    [_dataArray addObject:temp];
    
    NSMutableArray *temp1 = [NSMutableArray array];
    for(id key in [[TestData singleInstance] detailWithCompleted]){
        RecordModel *model = [[RecordModel alloc]init];
        model.title = key[@"title"];
        model.date = key[@"date"];
        model.priority = key[@"priority"];
        model.isCompleted = key[@"isCompleted"];
        model.type = key[@"type"];
        model.tag = key[@"tag"];
        model.ID = key[@"ID"];
        
        [temp1 addObject:model];
    }
    [_dataArray addObject:temp1];
    //NSLog(@"Completed%@",[[TestData singleInstance] detailWithCompleted]);
    //NSLog(@"Not completed%@",[[TestData singleInstance] detailWithNotCompleted]);
    NSLog(@"_dataArray %@",_dataArray);
    
    [self.tableView reloadData];
}

#pragma mark - tableView设置
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
// return 1;
    if([[TestData singleInstance] detailWithCompleted].count == 0)
        return 1;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return  20;
    if(section == 0){
        return [[TestData singleInstance] detailWithNotCompleted].count;
    }
    else if(section == 1){
        //return [[TestData singleInstance] detailWithCompleted].count;
        // 判断是否展开
        if (self.sectionTitleBtns.isSelected) {
            //RPCategoryModel *categoryModel = self.category[section];
            //return categoryModel.childs.count;
            return [[TestData singleInstance] detailWithCompleted].count;
        }
            return 0;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicCell * cell = [DynamicCell dynamicCellWithTable:tableView];
    cell.model = _dataArray[indexPath.section][indexPath.row];
    //cell.layer.borderWidth = 1.0;
    //cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1)
        return @"已完成";
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //if(section == 0)
    //    return 0;
    //else
        return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:234.0/255.0 blue:244.0/255.0 alpha:100];
    if (section == 1){
        //将UIView设为可交互的：
        myView.userInteractionEnabled = YES;
        //添加tap手势
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTitleBtnClick:)];
        //给触发事件传参
        //[myView setTag:1];
        //默认为单击触发，也可通过以下方法设置双击，三击...
        [singleTap setNumberOfTapsRequired:1];
        //设置手指个数：
        [singleTap setNumberOfTouchesRequired:1];
        //将手势添加至UIView中
        [myView addGestureRecognizer:singleTap];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    //titleLabel.text=[self.keys objectAtIndex:section];
    if (section == 1)
        titleLabel.text =  @"已完成";
    else{
        titleLabel.text = @"今日";
    }
    //titleLabel.layer.borderWidth = 1.0;
    //titleLabel.layer.borderColor = [UIColor redColor].CGColor;
    //myView.layer.borderWidth = 1.0;
    //myView.layer.borderColor = [UIColor redColor].CGColor;
    [myView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myView).with.offset(20);
        make.top.equalTo(myView).with.offset(5);
    }];
    
    UILabel *number = [[UILabel alloc] init];
    number.textColor=[UIColor grayColor];
    number.backgroundColor = [UIColor clearColor];
    number.font = [UIFont systemFontOfSize:12];
    NSUInteger temp = [[TestData singleInstance] detailWithCompleted].count;
    if (section == 1)
        number.text = [[NSNumber numberWithInteger:temp]stringValue];
    //NSLog(@"number %@",number.text);
    //number.layer.borderWidth = 1.0;
    //number.layer.borderColor = [UIColor redColor].CGColor;
    [myView addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myView).with.offset(5);
        make.right.equalTo(myView).with.offset(-20);
    }];
    //[titleLabel release];
    return myView;
}

- (void)sectionTitleBtnClick:(UITapGestureRecognizer *)sender{
    // 修改组标题按钮的状态
    self.sectionTitleBtns.selected = !self.sectionTitleBtns.isSelected;
    // 刷新单独一组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
  
    if (scrollView != self) {
        return;
    }
  
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    self.calendarView.maskView.hidden = false;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
         self.tableView.scrollEnabled = true;
        self.calendarView.maskView.hidden = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        
        self.tableView.scrollEnabled = false;
        if ([LTSCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)+offsetY;
    self.tableView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame);
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
   
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}
//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [self.calendarView setUpVisualRegion];
}


- (void)scrollToSingleWeek{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
 
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[LTSCalendarAppearance share].weekDayHeight*([LTSCalendarAppearance share].weeksToDisplay-1));
}

# pragma mark - cell移动
- (IBAction)longPressGestureRecognized:(id)sender {
 
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;

    
    CGPoint location = [longPress locationInView:_tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
 
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
     
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
              sourceIndexPath = indexPath;

              UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
              // Take a snapshot of the selected row using helper method.
              snapshot = [self customSnapshotFromView:cell];

              // Add the snapshot as subview, centered at cell's center...
              __block CGPoint center = cell.center;
              snapshot.center = center;
              snapshot.alpha = 0.0;
              [self.tableView addSubview:snapshot];
              [UIView animateWithDuration:0.25 animations:^{
                // Offset for gesture location.
                center.y = location.y;
                snapshot.center = center;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshot.alpha = 0.98;

                // Black out.
                cell.backgroundColor = [UIColor whiteColor];
              } completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;

            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... update data source.
                //[self.objects exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;

                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {

            [snapshot removeFromSuperview];
            snapshot = nil;

            }];
            sourceIndexPath = nil;
            break;
        }
    }
}
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;

    return snapshot;
}

@end
