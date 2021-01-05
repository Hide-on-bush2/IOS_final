//
//  LTSCalendarCollectionCell.h
//  LTSCalendar
//
//

#import <UIKit/UIKit.h>
#import "LTSCalendarDayItem.h"
@interface LTSCalendarCollectionCell : UICollectionViewCell
@property (nonatomic,strong)LTSCalendarDayItem *item;
@property (nonatomic,assign)BOOL isSelected;
@end
