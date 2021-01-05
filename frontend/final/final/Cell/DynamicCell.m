//
//  DynamicCell+_.m
//  final
//
//  Created by jinshlin on 2020/12/22.
//

#import "DynamicCell.h"
#import "Masonry.h"

#import "TestData.h"

@interface DynamicCell ()

@property(strong, nonatomic) UIButton *checkbox;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * dateLabel;

@end

@implementation DynamicCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
     }
    return self;
}
- (void)setupUI{
    self.checkbox=[[UIButton alloc] init];

    [self.checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    //[self.checkbox setSelected:NO];//设置按钮得状态是否为选中（可在此根据具体情况来设置按钮得初始状态）
       
    _titleLabel = [[UILabel alloc] init];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    
    self.contentView.clipsToBounds = YES;
    [self.contentView addSubview:self.checkbox];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_dateLabel];
    
    
    [self.checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.contentView).with.offset(10);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkbox.mas_right).offset(12);
        make.top.equalTo(self.checkbox.mas_top);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(32);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(320);
        make.top.equalTo(self.checkbox.mas_top);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(32);
    }];
}

- (void)checkboxClick:(UIButton*)btn{
    btn.selected=!btn.selected;
    //NSLog(@"id %@", _ID);
    if(btn.selected == 0){
        //变成未完成
        self.titleLabel.textColor = [UIColor blackColor];
        for(int i = 0; i<[TestData singleInstance].data.count; i++){
            id key = [TestData singleInstance].data[i];
            if([key[@"ID"] isEqual:_ID]){
                //key[@"isCompleted"] = NO;
                //NSLog(@"key id %@", key[@"ID"]);
                [[TestData singleInstance].data[i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCompleted"];
            }
        }
    }else{
        self.titleLabel.textColor = [UIColor grayColor];
        for(int i= 0; i<[TestData singleInstance].data.count; i++){
            id key = [TestData singleInstance].data[i];
            if([key[@"ID"] isEqual:_ID]){
                //key[@"isCompleted"] = NO;
                //NSLog(@"key id %@", key[@"ID"]);
                [[TestData singleInstance].data[i] setValue:[NSNumber numberWithBool:YES] forKey:@"isCompleted"];
            }
        }
    }
    NSLog(@"TestData %@", [TestData singleInstance].data);
    [self notificate];
}

- (void)notificate{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateData" object:nil];
}

- (void)setModel:(RecordModel *)model{
    //self.model = model;
    _ID = model.ID;
    _titleLabel.text = model.title;
    _dateLabel.text = model.date;
    if([model.isCompleted boolValue]){
        [self.checkbox setSelected:YES];
        self.titleLabel.textColor = [UIColor grayColor];
    }
    else{
        [self.checkbox setSelected:NO];
        self.titleLabel.textColor = [UIColor blackColor];
    }
    if([model.priority isEqualToString:@"无优先级"]){
        //设置正常时图片为check_off，点击选中状态图片为check_on
        [self.checkbox setImage:[UIImage imageNamed:@"check_off"]forState:UIControlStateNormal];
        [self.checkbox setImage:[UIImage imageNamed:@"check_on"]forState:UIControlStateSelected];
    }else if([model.priority isEqualToString:@"！低优先级"]){
        [self.checkbox setImage:[UIImage imageNamed:@"check_off_blue"]forState:UIControlStateNormal];
        [self.checkbox setImage:[UIImage imageNamed:@"check_on"]forState:UIControlStateSelected];
    }else if([model.priority isEqualToString:@"！！中优先级"]){
        [self.checkbox setImage:[UIImage imageNamed:@"check_off_yellow"]forState:UIControlStateNormal];
        [self.checkbox setImage:[UIImage imageNamed:@"check_on"]forState:UIControlStateSelected];
    }else if([model.priority isEqualToString:@"！！！高优先级"]){
        [self.checkbox setImage:[UIImage imageNamed:@"check_off_red"]forState:UIControlStateNormal];
        [self.checkbox setImage:[UIImage imageNamed:@"check_on"]forState:UIControlStateSelected];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

+ (DynamicCell *)dynamicCellWithTable:(UITableView *)table{
    DynamicCell * cell = [table dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (!cell) {
        cell = [[DynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
