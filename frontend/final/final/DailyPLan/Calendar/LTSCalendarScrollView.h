//
//  LTSCalendarScrollView.h
//  LTSCalendar
//
//

#import <UIKit/UIKit.h>
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekDayView.h"

@interface LTSCalendarScrollView : UIScrollView

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LTSCalendarContentView *calendarView;

@property (nonatomic,strong)UIColor *bgColor;

@property (nonatomic,strong) NSMutableArray * dataArray;

- (void)scrollToSingleWeek;

- (void)scrollToAllWeek;

@end
