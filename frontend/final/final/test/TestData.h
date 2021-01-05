//
//  TestData.h
//  final
//
//  Created by Khynnn on 2020/12/23.
//

#import <Foundation/Foundation.h>

@interface TestData : NSObject

@property(nonatomic, strong)NSMutableArray *data;

+(instancetype)singleInstance;

-(NSMutableArray*)ListType;
-(NSMutableArray*)detailWithType:(NSString*)type;

-(NSMutableArray*)AllTag;
-(NSMutableArray*)detailWithTag:(NSString*)tag;

-(NSMutableArray*)detailWithCompleted;
-(NSMutableArray*)detailWithNotCompleted;

@end
