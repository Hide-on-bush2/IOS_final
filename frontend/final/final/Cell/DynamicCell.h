//
//  DynamicCell+_.h
//  final
//
//  Created by jinshlin on 2020/12/22.
//


#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface DynamicCell : UITableViewCell

@property (nonatomic,strong) RecordModel * model;

@property (nonatomic, strong) NSString *ID;

+ (DynamicCell *)dynamicCellWithTable:(UITableView *)table;

@end

