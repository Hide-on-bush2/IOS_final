//
//  AddSimplePlanView.m
//  final
//
//  Created by Khynnn on 2021/1/5.
//

#import <Foundation/Foundation.h>
#import "AddSimplePlanView.h"
#import "Masonry.h"

#import "AddPlanVC.h"

@interface AddSimplePlanView()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *btn1;

//@property (nonatomic,strong) UIView * addPlanView;
//@property (nonatomic,strong) UIView * setPriorityView;
@property (nonatomic,strong) UIView * priorityView;

@property(strong, nonatomic) UIButton *date_btn;
@property(strong, nonatomic) UIButton *priority_btn;
@property(strong, nonatomic) UIButton *sendplan_btn;
@property(strong, nonatomic) UIButton *tags_btn;
@property(strong, nonatomic) UIButton *plus_btn;
@property(strong, nonatomic) UIButton *no_priority,*low_priority,*mid_priority,*high_priority;
@property(strong, nonatomic) UITextField *title_text;

@end

@implementation AddSimplePlanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self ) {
        [self initContent];
    }
    return self;
}
 
- (void)initContent{
    UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    self.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    //NSLog(@"%f,%f",self.frame.size.height,self.frame.size.width);
    self.backgroundColor = [UIColor blackColor];
    //self.alpha = 0.2;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)]];
 
    if (_contentView == nil){
        self.contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            
            make.height.mas_equalTo(450);
        }];
    }
    
    if(_priorityView == nil){
        _priorityView = [[UIView alloc] init];
        _priorityView.backgroundColor = [UIColor whiteColor];
        _priorityView.layer.cornerRadius = 8;
        _priorityView.layer.masksToBounds = YES;
        [self addSubview:_priorityView];
        
        [_priorityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(50);
            make.bottom.equalTo(_contentView.mas_top).offset(-10);
            
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(180);
        }];
        _priorityView.alpha = 1.0;
        _priorityView.hidden = YES;
    }
    [self addElement];
}

- (void)addElement{
    self.date_btn = [[UIButton alloc] init];
    [self.date_btn setBackgroundImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
    //_date_btn.layer.borderWidth = 1.0;
    //_date_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.priority_btn = [[UIButton alloc] init];
    [self.priority_btn setBackgroundImage:[UIImage imageNamed:@"priority"] forState:UIControlStateNormal];
    [self.priority_btn addTarget:self action:@selector(setPriority:) forControlEvents:UIControlEventTouchUpInside];
    //_priority_btn.layer.borderWidth = 1.0;
    //_priority_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.sendplan_btn = [[UIButton alloc] init];
    [self.sendplan_btn setBackgroundImage:[UIImage imageNamed:@"sendplan"] forState:UIControlStateNormal];
    //self.sendplan_btn.layer.borderWidth = 1.0;
    //self.sendplan_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.tags_btn = [[UIButton alloc] init];
    [self.tags_btn setBackgroundImage:[UIImage imageNamed:@"tags"] forState:UIControlStateNormal];
    [self.tags_btn addTarget:self action:@selector(setTag:) forControlEvents:UIControlEventTouchUpInside];
    //self.tags_btn.layer.borderWidth = 1.0;
    //self.tags_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.plus_btn = [[UIButton alloc] init];
    [self.plus_btn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.plus_btn addTarget:self action:@selector(addPlan:) forControlEvents:UIControlEventTouchUpInside];
    //self.plus_btn.layer.borderWidth = 1.0;
    //self.plus_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.title_text = [[UITextField alloc]init];
    self.title_text.placeholder = @"例如：6点下课去拿快递";
    self.title_text.adjustsFontSizeToFitWidth = YES;
    self.title_text.delegate = self;
    //self.title_text.layer.borderWidth = 1.0;
    //self.title_text.layer.borderColor = [UIColor redColor].CGColor;
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice"]];
    //image.layer.borderWidth = 1.0;
    //image.layer.borderColor = [UIColor redColor].CGColor;
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    self.title_text.rightView = image;
    self.title_text.rightViewMode = UITextFieldViewModeAlways;
    [self.title_text becomeFirstResponder];
    
    [self.contentView addSubview:self.date_btn];
    [self.contentView addSubview:self.priority_btn];
    [self.contentView addSubview:self.tags_btn];
    [self.contentView addSubview:self.plus_btn];
    [self.contentView addSubview:self.title_text];
    [self.contentView addSubview:self.sendplan_btn];
    
    [self.title_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(15);
        make.top.equalTo(_date_btn.mas_bottom).offset(15);
        make.right.equalTo(_contentView).offset(-15);
        
        make.height.mas_equalTo(38);
    }];
    
    [self.date_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_text.mas_left);
        make.top.equalTo(_contentView).offset(20);
        make.bottom.equalTo(self.title_text.mas_top).offset(-15);
        
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.priority_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date_btn.mas_right).offset(15);
        make.top.equalTo(self.date_btn.mas_top);
        
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(28);
    }];
    
    [self.tags_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priority_btn.mas_right).offset(15);
        make.top.equalTo(self.date_btn.mas_top);
        
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(26);
    }];
    
    [self.plus_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tags_btn.mas_right).offset(15);
        make.top.equalTo(self.date_btn.mas_top);
        
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.sendplan_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.title_text);
        make.top.equalTo(self.date_btn.mas_top).offset(2);
        
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    self.no_priority = [[UIButton alloc] init];
    [self.no_priority setTitle:@"    无优先级" forState:UIControlStateNormal] ;
    [self.no_priority setTitleColor: [UIColor grayColor] forState:UIControlStateNormal] ;
    [self.no_priority addTarget:self action:@selector(noPriority:) forControlEvents:UIControlEventTouchUpInside];
    self.no_priority.backgroundColor = [UIColor whiteColor];
    self.no_priority.titleLabel.font = [UIFont systemFontOfSize: 18];
    self.no_priority.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.no_priority.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    //self.no_priority.layer.borderWidth = 1.0;
    //self.no_priority.layer.borderColor = [UIColor redColor].CGColor;
    
    self.low_priority = [[UIButton alloc] init];
    UIColor *blueColor= [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1];
    [self.low_priority setTitle:@" !  低优先级" forState:UIControlStateNormal] ;
    [self.low_priority setTitleColor: blueColor forState:UIControlStateNormal] ;
    [self.low_priority addTarget:self action:@selector(lowPriority:) forControlEvents:UIControlEventTouchUpInside];
    self.low_priority.backgroundColor = [UIColor whiteColor] ;
    self.low_priority.titleLabel.font = [UIFont systemFontOfSize: 18];
    self.low_priority.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.low_priority.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    //self.low_priority.layer.borderWidth = 1.0;
    //self.low_priority.layer.borderColor = [UIColor redColor].CGColor;
    
    self.mid_priority = [[UIButton alloc] init];
    [self.mid_priority setTitle:@"!!  中优先级" forState:UIControlStateNormal] ;
    [self.mid_priority setTitleColor: [UIColor orangeColor ] forState:UIControlStateNormal] ;
    [self.mid_priority addTarget:self action:@selector(midPriority:) forControlEvents:UIControlEventTouchUpInside];
    self.mid_priority.backgroundColor = [UIColor whiteColor] ;
    self.mid_priority.titleLabel.font = [UIFont systemFontOfSize: 18];
    self.mid_priority.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.mid_priority.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    //self.mid_priority.layer.borderWidth = 1.0;
    //self.mid_priority.layer.borderColor = [UIColor redColor].CGColor;
    
    self.high_priority = [[UIButton alloc] init];
    [self.high_priority setTitle:@"!!! 高优先级" forState:UIControlStateNormal] ;
    [self.high_priority setTitleColor: [UIColor colorWithRed:220/255.0 green:20/255.0 blue:60/255.0 alpha:1 ] forState:UIControlStateNormal] ;
    [self.high_priority addTarget:self action:@selector(highPriority:) forControlEvents:UIControlEventTouchUpInside];
    self.high_priority.backgroundColor = [UIColor whiteColor] ;
    self.high_priority.titleLabel.font = [UIFont systemFontOfSize: 18];
    self.high_priority.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.high_priority.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    //self.high_priority.layer.borderWidth = 1.0;
   // self.high_priority.layer.borderColor = [UIColor redColor].CGColor;

    [_priorityView addSubview:self.no_priority];
    [_priorityView addSubview:self.low_priority];
    [_priorityView addSubview:self.mid_priority];
    [_priorityView addSubview:self.high_priority];

    [_no_priority mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priorityView.mas_left);
        make.bottom.equalTo(_priorityView).with.offset(-10);
        make.right.equalTo(_priorityView.mas_right);
        
        make.height.mas_equalTo(40);
    }];
    
    [self.low_priority mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.no_priority.mas_left);
        make.bottom.equalTo(self.no_priority.mas_top);
        make.right.equalTo(self.no_priority.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.mid_priority mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.no_priority.mas_left);
        make.bottom.equalTo(self.low_priority.mas_top);
        make.right.equalTo(self.no_priority.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.high_priority mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.no_priority.mas_left);
        make.bottom.equalTo(self.mid_priority.mas_top);
        make.right.equalTo(self.no_priority.mas_right);
        make.height.mas_equalTo(40);
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.title_text resignFirstResponder];
    return YES;
}
- (void)textFieldDidChanged:(UITextField *)textField {
    // 判断是否存在高亮字符，如果有，则不进行字数统计和字符串截断
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return;
    }
    if (_title_text.text.length == 0) {
        _sendplan_btn.enabled = NO;
        _title_text.rightView.hidden = NO;
    }
    else{
        _sendplan_btn.enabled = YES;
        _title_text.rightView.hidden = YES;
    }
}
/*
//textfield随键盘上移
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.title_text.frame;
    int offset = frame.origin.y + 160  - (self.frame.size.height -216.0);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];

    [UIView setAnimationDuration:0.5f];

    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示

    if(offset > 0)
        self.frame = CGRectMake(0.0f, -offset,self.frame.size.width, self.frame.size.height);

    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    [self.alphaView removeFromSuperview];
}
*/
#pragma mark -设置标签
-(void)setTag:(id)sender{
    self.title_text.text = @"#";
}

#pragma mark -跳转到添加页面
-(void)addPlan:(id)sender{
    //AddPlanVC *vc = [[AddPlanVC alloc] init];
    //[super.navigationController pushViewController:vc animated:YES];
    [self notificate_add];
}

- (void)notificate_add{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPlusPlan" object:nil];
}

#pragma mark -优先级
-(void)setPriority:(id)sender{
    self.title_text.text = @"!";
    _priorityView.hidden = !_priorityView.hidden;
}

-(void)noPriority:(id)sender{
    NSString * str = @"!无优先级 " ;
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    //设置字体大小
    //[attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28] range:NSMakeRange(0, 4)];
    self.title_text.attributedText = attr;
    //self.title_text.text = @"!无优先级";
}

-(void)lowPriority:(id)sender{
    //self.title_text.text = @"!低优先级";
    NSString * str = @"!低优先级 ";
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    UIColor *blueColor= [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1];
    [attr addAttribute:NSForegroundColorAttributeName value:blueColor range:NSMakeRange(0, 5)];
    self.title_text.attributedText = attr;
}

-(void)midPriority:(id)sender{
    //self.title_text.text = @"!中优先级";
    NSString * str = @"!中优先级 ";
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor ] range:NSMakeRange(0, 5)];
    self.title_text.attributedText = attr;
}

-(void)highPriority:(id)sender{
    //self.title_text.text = @"!高优先级";
    NSString * str = @"!高优先级 ";
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:220/255.0 green:20/255.0 blue:60/255.0 alpha:1 ] range:NSMakeRange(0, 5)];
    self.title_text.attributedText = attr;
}

- (void)showAlert:(UIView *)view{
    if (!view) {
        return;
    }
    [view addSubview:self];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.2;
    }];
 
    [view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        
        make.height.mas_equalTo(450);
    }];

    [view addSubview:_priorityView];
    [_priorityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.bottom.equalTo(_contentView.mas_top).offset(-10);
        
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(180);
    }];
    _priorityView.hidden = YES;

    self.contentView.transform = CGAffineTransformMakeTranslation(0.01, view.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
}
 
- (void)dismissAlert {
    UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, window.frame.size.height);
        self.contentView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self.priorityView removeFromSuperview];
    }];
}
 

@end
