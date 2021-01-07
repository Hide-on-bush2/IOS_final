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

@property(strong, nonatomic) UIButton *date_btn;
@property(strong, nonatomic) UIButton *priority_btn;
@property(strong, nonatomic) UIButton *sendplan_btn;
@property(strong, nonatomic) UIButton *tags_btn;
@property(strong, nonatomic) UIButton *plus_btn;

@property(strong, nonatomic) UIButton *type_btn;
@property(strong, nonatomic) UILabel *type_name;

@property (nonatomic,strong) UIView * priorityView;
@property(strong, nonatomic) UIButton *no_priority,*low_priority,*mid_priority,*high_priority;

@property (nonatomic,strong) UIView * listView;
@property(strong, nonatomic) UIButton *inbox,*study,*work;

//@property (nonatomic,strong) DatePickerView *datePicker;
@property (nonatomic,strong) UIView * datePickerView;

@property(strong, nonatomic) UITextField *title_text;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (nonatomic,strong) UIButton *cancelBlock;
@property (nonatomic,strong) UIButton *sureBlock;
@property (strong, nonatomic) UILabel *datePickerTitle;

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
        _contentView.layer.cornerRadius = 10;
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
    
    if(_listView == nil){
        _listView = [[UIView alloc] init];
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.layer.cornerRadius = 8;
        _listView.layer.masksToBounds = YES;
        [self addSubview:_listView];
        
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(150);
            make.bottom.equalTo(_contentView.mas_top).offset(-10);
            
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(140);
        }];
        _listView.alpha = 1.0;
        _listView.hidden = YES;
    }
    
    if(_datePickerView == nil){
        _datePickerView = [[UIView alloc] init];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.layer.cornerRadius = 8;
        _datePickerView.layer.masksToBounds = YES;
        [self addSubview:_datePickerView];
        
        [_datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset((self.frame.size.width-300)/2);
            make.bottom.equalTo(_contentView.mas_top).offset(-10);
            
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(160);
        }];
        _datePickerView.alpha = 1.0;
        _datePickerView.hidden = YES;
    }
    
    [self addElement];
    [self addPriorityView];
    [self addListType];
    [self addDatePickView];
}
#pragma mark - 发布计划
- (void)sendPlan:(id)sender{
    [self getTag];
    //post,注：优先级和清单类型 我没赋值
    //NSString *plan = [_title_text.text stringByReplacingOccurrencesOfString:self.priority withString:@""];
    //plan = [plan stringByReplacingOccurrencesOfString:self.tagName withString:@""];
    
    
    [self dismissAlert];
}

- (void)getTag{
    //获取第一个以#开头，空格结尾的tag
    NSString *result =@"";
    NSString *temp = nil;
    int first = -1;
    for(int i =0; i < [_title_text.text length]; i++)
    {
       temp = [_title_text.text substringWithRange:NSMakeRange(i, 1)];
        if([temp isEqual:@"#"]){
            first = i;
            break;
        }
    }
    if(first != -1){
        for(int i = first+1; i < [_title_text.text length]; i++)
        {
           temp = [_title_text.text substringWithRange:NSMakeRange(i, 1)];
            if([temp isEqual:@" "]){
                break;
            }
            else{
                [result stringByAppendingString:temp];
            }
        }
    }
    self.tagName = result;
}

#pragma mark - 监听输入
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

#pragma mark - 时间选择器

- (void)selectData:(id)sender{
    _priorityView.hidden = YES;
    _listView.hidden = YES;
    _datePickerView.hidden = !_datePickerView.hidden;

}

- (void)saveDate:(id)sender{
    self.date = _datePicker.date;
    
    NSDate *theDate = _datePicker.date;//该属性返回选中的时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//返回一个日期格式对象
    dateFormatter.dateFormat = @"YYYY-MM-dd";//该属性用于设置日期格式为YYYY-MM-dd HH-mm-ss
    NSLog(@"%@",[dateFormatter stringFromDate:theDate]);
    
    _datePickerView.hidden = !_datePickerView.hidden;
}

- (void)cancelDatePick:(id)sender{
    _datePickerView.hidden = !_datePickerView.hidden;
}

#pragma mark - 设置标签
-(void)setTag:(NSInteger)tag{
    _priorityView.hidden = YES;
    _listView.hidden = YES;
    _datePickerView.hidden =YES;
    //self.title_text.text = [_title_text.text stringByAppendingString:@"#"];
    
    NSString * str = @"#";
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    //[attr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 1)];
    NSMutableAttributedString * temp = [[NSMutableAttributedString alloc]initWithAttributedString:self.title_text.attributedText];
    [temp appendAttributedString:attr];
    self.title_text.attributedText = temp;
}

#pragma mark - 跳转到添加页面
-(void)addPlan:(id)sender{
    //AddPlanVC *vc = [[AddPlanVC alloc] init];
    //[super.navigationController pushViewController:vc animated:YES];
    [self notificate_add];
    
}

- (void)notificate_add{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPlusPlan" object:nil];
}

#pragma mark - 优先级
-(void)setPriority:(id)sender{
    //self.title_text.text = @"!";
    _listView.hidden = YES;
    _datePickerView.hidden =YES;
    _priorityView.hidden = !_priorityView.hidden;
    
}

-(void)noPriority:(id)sender{
    NSString * str = @"!无优先级 ";
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    //设置字体大小
    //[attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28] range:NSMakeRange(0, 4)];
    [attr appendAttributedString:self.title_text.attributedText];
    self.title_text.attributedText = attr;
    //self.title_text.text = @"!无优先级";
    _priorityView.hidden = !_priorityView.hidden;
}

-(void)lowPriority:(id)sender{
    //self.title_text.text = @"!低优先级";
    NSString * str = @"!低优先级 ";
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    UIColor *blueColor= [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1];
    [attr addAttribute:NSForegroundColorAttributeName value:blueColor range:NSMakeRange(0, 5)];
    [attr appendAttributedString:self.title_text.attributedText];
    self.title_text.attributedText = attr;
    _priorityView.hidden = !_priorityView.hidden;
}

-(void)midPriority:(id)sender{
    //self.title_text.text = @"!中优先级";
    NSString * str = @"!中优先级 ";
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor ] range:NSMakeRange(0, 5)];
    [attr appendAttributedString:self.title_text.attributedText];
    self.title_text.attributedText = attr;
    _priorityView.hidden = !_priorityView.hidden;
}

-(void)highPriority:(id)sender{
    //self.title_text.text = @"!高优先级";
    NSString * str = @"!高优先级 ";
    //添加富文本对象
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:220/255.0 green:20/255.0 blue:60/255.0 alpha:1 ] range:NSMakeRange(0, 5)];
    [attr appendAttributedString:self.title_text.attributedText];
    self.title_text.attributedText = attr;
    _priorityView.hidden = !_priorityView.hidden;
}

# pragma mark - 清单类型
-(void)setListTpye:(id)sender{
    _priorityView.hidden = YES;
    _datePickerView.hidden =YES;
    _listView.hidden = !_listView.hidden;
}

-(void)setInboxType:(UIButton *)inbox{
    _listView.hidden = !_listView.hidden;
    _type_name.text = @"收集箱";
}
-(void)setWorkType:(UIButton *)work{
    _listView.hidden = !_listView.hidden;
    _type_name.text = @"工作安排";
}
-(void)setStudyType:(UIButton *)study{
    _listView.hidden = !_listView.hidden;
    _type_name.text = @"学习任务";
}
-(void)setPersonalType:(UIButton *)personal{
    _listView.hidden = !_listView.hidden;
    _type_name.text = @"个人备忘";
}


# pragma mark - showAlert and dismissAlert

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
    
    [view addSubview:_listView];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(150);
        make.bottom.equalTo(_contentView.mas_top).offset(-10);
        
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(140);
    }];
    _listView.hidden = YES;
    
    [view addSubview:_datePickerView];
    [_datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((self.frame.size.width-300)/2);
        make.bottom.equalTo(_contentView.mas_top).offset(-10);
        
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(160);
    }];
    _datePickerView.hidden = YES;

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
        [self.listView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
    }];
}
# pragma mark - 布局
- (void)addElement{
    self.date_btn = [[UIButton alloc] init];
    [self.date_btn setBackgroundImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
    [self.date_btn addTarget:self action:@selector(selectData:) forControlEvents:UIControlEventTouchUpInside];
    //_date_btn.layer.borderWidth = 1.0;
    //_date_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.priority_btn = [[UIButton alloc] init];
    [self.priority_btn setBackgroundImage:[UIImage imageNamed:@"priority"] forState:UIControlStateNormal];
    [self.priority_btn addTarget:self action:@selector(setPriority:) forControlEvents:UIControlEventTouchUpInside];
    //_priority_btn.layer.borderWidth = 1.0;
    //_priority_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.sendplan_btn = [[UIButton alloc] init];
    [self.sendplan_btn setBackgroundImage:[UIImage imageNamed:@"sendplan"] forState:UIControlStateNormal];
    [self.sendplan_btn addTarget:self action:@selector(sendPlan:) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.type_btn = [[UIButton alloc] init];
    [self.type_btn setBackgroundImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    [self.type_btn addTarget:self action:@selector(setListTpye:) forControlEvents:UIControlEventTouchUpInside];
    //self.type_btn.layer.borderWidth = 1.0;
    //self.type_btn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.type_name = [[UILabel alloc] init];
    _type_name.textColor = [UIColor grayColor];
    _type_name.text = @"收集箱";
    _type_name.font = [UIFont systemFontOfSize:14];
    //self.type_name.layer.borderWidth = 1.0;
    //self.type_name.layer.borderColor = [UIColor redColor].CGColor;
 
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
    [self.contentView addSubview:self.type_btn];
    [self.contentView addSubview:self.type_name];
    
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
    
    [self.type_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tags_btn.mas_right).offset(15);
        make.top.equalTo(self.date_btn.mas_top);
        
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.type_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.type_btn.mas_right).offset(5);
        make.top.equalTo(self.date_btn.mas_top);
        
        make.height.mas_equalTo(30);
        //make.width.mas_equalTo(100);
    }];
    
    [self.plus_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.type_name.mas_right).offset(15);
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
}
#pragma mark - 布局(优先级）
- (void)addPriorityView{
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
#pragma mark - 布局(清单类型）
- (void)addListType{
    self.inbox = [[UIButton alloc] init];
    [self.inbox setTitle:@"收集箱" forState:UIControlStateNormal] ;
    [self.inbox setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.inbox addTarget:self action:@selector(setInboxType:) forControlEvents:UIControlEventTouchUpInside];
    //self.inbox.backgroundColor = [UIColor whiteColor];
    self.inbox.titleLabel.font = [UIFont systemFontOfSize: 18];
    self.inbox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.inbox.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    //self.inbox.layer.borderWidth = 1.0;
    //self.inbox.layer.borderColor = [UIColor redColor].CGColor;
    
    self.work = [[UIButton alloc] init];
    UIColor *blueColor= [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1];
    [self.work setTitle:@"工作安排" forState:UIControlStateNormal] ;
    [self.work setTitleColor: blueColor forState:UIControlStateNormal] ;
    [self.work addTarget:self action:@selector(setWorkType:) forControlEvents:UIControlEventTouchUpInside];
    //self.work.backgroundColor = [UIColor whiteColor];
    self.work.titleLabel.font = [UIFont systemFontOfSize: 18];
    self.work.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.work.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    //self.work.layer.borderWidth = 1.0;
    //self.work.layer.borderColor = [UIColor redColor].CGColor;
    
    self.study = [[UIButton alloc] init];
    [self.study setTitle:@"学习任务" forState:UIControlStateNormal] ;
    [self.study setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal] ;
    [self.study addTarget:self action:@selector(setStudyType:) forControlEvents:UIControlEventTouchUpInside];
    //self.study.backgroundColor = [UIColor whiteColor] ;
    self.study.titleLabel.font = [UIFont systemFontOfSize: 18];
    self.study.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.study.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    //self.study.layer.borderWidth = 1.0;
    //self.study.layer.borderColor = [UIColor redColor].CGColor;


    [self.listView addSubview:self.inbox];
    [self.listView addSubview:self.work];
    [self.listView addSubview:self.study];

    [self.study mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_listView.mas_left);
        make.bottom.equalTo(_listView).with.offset(-10);
        make.right.equalTo(_listView.mas_right);
        
        make.height.mas_equalTo(40);
    }];
    
    [self.work mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.study);
        make.bottom.equalTo(self.study.mas_top);
        make.right.equalTo(self.study);
        make.height.mas_equalTo(40);
    }];
    
    [self.inbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.study);
        make.bottom.equalTo(self.work.mas_top);
        make.right.equalTo(self.study);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark - 布局（时间选择器）
- (void)addDatePickView{
    self.datePickerTitle = [[UILabel alloc] init];
    _datePickerTitle.textColor = [UIColor blackColor];
    _datePickerTitle.text = @"选择时间";
    _datePickerTitle.textAlignment = NSTextAlignmentCenter;
    _datePickerTitle.font = [UIFont systemFontOfSize:18];
    [self.datePickerView addSubview:_datePickerTitle];
    //self.datePickerTitle.layer.borderWidth = 1.0;
    //self.datePickerTitle.layer.borderColor = [UIColor redColor].CGColor;
    
    self.cancelBlock = [[UIButton alloc] init];
    [self.cancelBlock setTitle:@"取消" forState:UIControlStateNormal] ;
    [self.cancelBlock setTitleColor: [UIColor colorWithRed:92./256. green:128./256. blue:221./256. alpha:1.] forState:UIControlStateNormal];
    _cancelBlock.backgroundColor = [UIColor whiteColor];
    //self.cancelBlock.layer.borderWidth = 1.0;
    //self.cancelBlock.layer.borderColor = [UIColor redColor].CGColor;
    [self.cancelBlock addTarget:self action:@selector(cancelDatePick:) forControlEvents:UIControlEventTouchUpInside];
    [self.datePickerView addSubview:_cancelBlock];
    
    self.sureBlock = [[UIButton alloc] init];
    [self.sureBlock setTitle:@"确定" forState:UIControlStateNormal] ;
    [self.sureBlock setTitleColor: [UIColor colorWithRed:92./256. green:128./256. blue:221./256. alpha:1.] forState:UIControlStateNormal];
    [self.sureBlock addTarget:self action:@selector(saveDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.datePickerView addSubview:_sureBlock];
    //self.sureBlock.layer.borderWidth = 1.0;
    //self.sureBlock.layer.borderColor = [UIColor redColor].CGColor;
    
    self.datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePickerView addSubview:_datePicker];
    //self.datePicker.layer.borderWidth = 1.0;
    //self.datePicker.layer.borderColor = [UIColor blueColor].CGColor;
    
    [_datePickerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePickerView);
        make.right.equalTo(_datePickerView);
        make.top.equalTo(_datePickerView);
        
        make.height.mas_equalTo(30);
    }];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePickerView);
        make.right.equalTo(_datePickerView);
        make.top.equalTo(_datePickerTitle.mas_bottom);
        
        make.height.mas_equalTo(80);
    }];
    [_cancelBlock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePickerView);
        make.top.equalTo(_datePicker.mas_bottom);
        make.bottom.equalTo(_datePickerView);
        
        make.width.mas_equalTo(150);
    }];
    [_sureBlock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_datePickerView);
        make.top.equalTo(_datePicker.mas_bottom);
        make.bottom.equalTo(_datePickerView);
        
        make.width.mas_equalTo(150);
    }];
}
 

@end
