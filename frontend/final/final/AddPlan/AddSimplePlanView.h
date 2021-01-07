//
//  AddSimplePlanView.h
//  final
//
//  Created by Khynnn on 2021/1/5.
//

#import <UIKit/UIKit.h>

@interface AddSimplePlanView : UIView
// 时间，优先级，标签，清单列表，具体计划内容是TextField中黑色字体部分
@property (nonatomic,strong) NSDate *date;

@property (nonatomic,strong) NSString *priority;
@property (nonatomic,strong) NSString *tagName;
@property (nonatomic,strong) NSString *listType;

- (void)showAlert:(UIView *)view;
- (void)dismissAlert;

@end
