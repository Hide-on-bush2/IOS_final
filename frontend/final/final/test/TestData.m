//
//  TestData.m
//  final
//
//  Created by Khynnn on 2020/12/23.
//

#import <Foundation/Foundation.h>
#import "TestData.h"

@implementation TestData

@synthesize data = _data;

-(id)init{
    if(self = [super init]){
        self.data = [NSMutableArray array];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:10];
        //向词典中动态添加数据
        [dictionary setObject:@"123456" forKey:@"ID"];
        [dictionary setObject:@"学习" forKey:@"title"];
        [dictionary setObject:@"2021/1/08" forKey:@"date"];
        [dictionary setObject:@"！！中优先级" forKey:@"priority"];
        [dictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isCompleted"];
        [dictionary setObject:@"学业清单" forKey:@"type"];
        [dictionary setObject:@"" forKey:@"tag"];
        [self.data addObject:dictionary];
        
        NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionaryWithCapacity:10];
        //向词典中动态添加数据
        [dictionary1 setObject:@"234567" forKey:@"ID"];
        [dictionary1 setObject:@"考试" forKey:@"title"];
        [dictionary1 setObject:@"2021/1/09" forKey:@"date"];
        [dictionary1 setObject:@"！！！高优先级" forKey:@"priority"];
        [dictionary1 setObject:[NSNumber numberWithBool:NO] forKey:@"isCompleted"];
        [dictionary1 setObject:@"学业清单" forKey:@"type"];
        [dictionary1 setObject:@"" forKey:@"tag"];
        [self.data addObject:dictionary1];
        
        NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionaryWithCapacity:10];
        //向词典中动态添加数据
        [dictionary2 setObject:@"345678" forKey:@"ID"];
        [dictionary2 setObject:@"运动" forKey:@"title"];
        [dictionary2 setObject:@"2021/1/10" forKey:@"date"];
        [dictionary2 setObject:@"！低优先级" forKey:@"priority"];
        [dictionary2 setObject:[NSNumber numberWithBool:YES] forKey:@"isCompleted"];
        [dictionary2 setObject:@"" forKey:@"type"];
        [dictionary2 setObject:@"低优先级" forKey:@"tag"];
        [self.data addObject:dictionary2];
        
        NSMutableDictionary *dictionary3 = [NSMutableDictionary dictionaryWithCapacity:10];
        //向词典中动态添加数据
        [dictionary3 setObject:@"456789" forKey:@"ID"];
        [dictionary3 setObject:@"旅游" forKey:@"title"];
        [dictionary3 setObject:@"2021/1/20" forKey:@"date"];
        [dictionary3 setObject:@"无优先级" forKey:@"priority"];
        [dictionary3 setObject:[NSNumber numberWithBool:YES] forKey:@"isCompleted"];
        [dictionary3 setObject:@"" forKey:@"type"];
        [dictionary3 setObject:@"无优先级" forKey:@"tag"];
        [self.data addObject:dictionary3];
       /* NSArray* array = @[
            @{
                @"ID":@"123456",
                @"title": @"学习",
                @"date": @"2021/1/08",
                @"priority": @"！！中优先级",
                @"isCompleted":@NO,
                @"type":@"学业清单",
                @"tag":@""
            },
            @{
                @"ID":@"234567",
                @"title": @"考试",
                @"date": @"2021/1/09",
                @"priority": @"！！！高优先级",
                @"isCompleted":@NO,
                @"type":@"学业清单",
                @"tag":@""
            },
            @{
                @"ID":@"345678",
                @"title": @"运动",
                @"date": @"2021/1/10",
                @"priority": @"！低优先级",
                @"isCompleted":@NO,
                @"type":@"",
                @"tag":@"低优先级"
            },
            @{
                @"ID":@"456789",
                @"title": @"旅游",
                @"date": @"2021/1/20",
                @"priority": @"无优先级",
                @"isCompleted":@YES,
                @"type":@"",
                @"tag":@"无优先级"
            },
        ];
        self.data = [array mutableCopy];*/
    }
    return self;
}

+(instancetype)singleInstance{
    static TestData *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[TestData alloc]init];
    }
    return myInstance;
}
//返回全部清单类型
-(NSMutableArray*)ListType{
    NSMutableArray *result = [NSMutableArray array];
    for(id key in _data){
        if(key[@"type"] != nil && ![key[@"type"] isEqual:@""])
            [result addObject:key[@"type"]];
    }
    return result;
}
//按清单类型返回全部此清单的信息
-(NSMutableArray*)detailWithType:(NSString*)type{
    NSMutableArray *result = [NSMutableArray array];
    for(id key in _data){
        if([key[@"type"] isEqual:type])
            [result addObject:key];
    }
    return result;
}
//返回全部标签信息
-(NSMutableArray*)AllTag{
    NSMutableArray *result = [NSMutableArray array];
    for(id key in _data){
        if(key[@"tag"] != nil && ![key[@"tag"] isEqual:@""])
            [result addObject:key[@"tag"]];
    }
    return result;
}

//按标签返回对应数据
-(NSMutableArray*)detailWithTag:(NSString*)tag{
    NSMutableArray *result = [NSMutableArray array];
    for(id key in _data){
        if([key[@"tag"] isEqual:tag])
            [result addObject:key];
    }
    return result;
}

//
-(NSMutableArray*)detailWithCompleted{
    NSMutableArray *result = [NSMutableArray array];
    for(id key in _data){
        //if([key[@"isCompleted"] isEqual:@YES])
        if([key[@"isCompleted"] boolValue])
            [result addObject:key];
    }
    return result;
}

-(NSMutableArray*)detailWithNotCompleted{
    NSMutableArray *result = [NSMutableArray array];
    for(id key in _data){
        //if([key[@"isCompleted"] isEqual:@NO])
        if(![key[@"isCompleted"] boolValue])
            [result addObject:key];
    }
    return result;
}

@end

