//
//  LeftNavView+_.h
//  final
//
//  Created by jinshlin on 2021/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeMenuViewDelegate <NSObject>

-(void)LeftMenuViewClick:(NSInteger)tag;

@end

@interface LeftNavView : UIView

@property (nonatomic ,weak)id <HomeMenuViewDelegate> customDelegate;

@end

NS_ASSUME_NONNULL_END
