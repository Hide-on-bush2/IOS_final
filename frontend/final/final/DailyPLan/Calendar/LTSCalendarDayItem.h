//
//  LTSCalendarDayItem.h
//  LTSCalendar
//
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface LTSCalendarDayItem : NSObject
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,assign)BOOL isOtherMonth;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,strong)UIColor *eventDotColor;
@property (nonatomic,assign)BOOL showEventDot;
@end
