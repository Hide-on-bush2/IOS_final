//
//  LTSCalendarCollectionViewFlowLauout.h
//  LTSCalendar
//
//

#import <UIKit/UIKit.h>

@interface LTSCalendarCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign) NSUInteger itemCountPerRow;

//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;
@end
