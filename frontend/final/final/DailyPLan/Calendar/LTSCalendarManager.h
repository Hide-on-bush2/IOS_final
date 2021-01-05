//
//  LTSCalendarManager.h
//  LTSCalendar
//
//

#import <Foundation/Foundation.h>
#import "LTSCalendarScrollView.h"
#import "LTSCalendarEventSource.h"
@interface LTSCalendarManager : NSObject
@property (nonatomic,strong)LTSCalendarScrollView *calenderScrollView;

@property (nonatomic,strong) LTSCalendarWeekDayView *weekDayView;

@property (weak, nonatomic) id<LTSCalendarEventSource> eventSource;

@property (nonatomic,strong , readonly) NSDate *currentSelectedDate;


///回到今天
- (void)goBackToday;

/// 重新加载外观
- (void)reloadAppearanceAndData;

///  前一页。上个月
- (void)loadPreviousPage;
///   下一页 下一个月

- (void)loadNextPage;
- (void)showSingleWeek;
- (void)showAllWeek;
@end
