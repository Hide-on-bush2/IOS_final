//
//  RecordModel+_.h
//  final
//
//  Created by jinshlin on 2020/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *priority;
//是否完成的优先级高于其他标签
//@property BOOL isCompleted;
@property (nonatomic, strong) NSNumber *isCompleted;
//清单类型
@property (nonatomic, strong) NSString *type;
//标签
@property (nonatomic, strong) NSString *tag;

@end

NS_ASSUME_NONNULL_END
