//
//  LeftNavView+_.m
//  final
//
//  Created by jinshlin on 2021/1/7.
//

#import "LeftNavView.h"
#import "PlanListVC.h"

#define ImageviewWidth 18

@interface LeftNavView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *contentTableView;
@property (nonatomic,strong) UIView *leftView;
@property(strong, nonatomic) UIButton *close_btn;

@end

@implementation LeftNavView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]){
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.leftView.backgroundColor = [UIColor colorWithRed:92./256. green:128./256. blue:221./256. alpha:1.];
        
        self.close_btn = [[UIButton alloc] initWithFrame:CGRectMake(285, 120, 32, 32)];
        [self.close_btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self.close_btn addTarget:self action:@selector(closeLeftView:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加头部
        UIView *headerView     = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.leftView.frame.size.width, 220)];
        [headerView setBackgroundColor:[UIColor colorWithRed:92./256. green:128./256. blue:221./256. alpha:1.]];
        CGFloat width = 100/2;
        
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30, 120, width, width)];
    //    [imageview setBackgroundColor:[UIColor redColor]];
        imageview.layer.cornerRadius = imageview.frame.size.width / 2;
        imageview.layer.masksToBounds = YES;
        [imageview setImage:[UIImage imageNamed:@"HeadIcon"]];
        [self.leftView addSubview:imageview];
        
        UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+imageview.frame.size.width, 130, 80, 30)];
        [NameLabel setText:@"用户名"];
        NameLabel.textColor = [UIColor whiteColor];
        NameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [self.leftView addSubview:NameLabel];
        
        [self.leftView addSubview:headerView];
        
        
        //中间tableview
        UITableView *contentTableView        = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, self.leftView.frame.size.width, self.leftView.frame.size.height - headerView.frame.size.height * 2)
                                                                           style:UITableViewStylePlain];
        [contentTableView setBackgroundColor:[UIColor whiteColor]];
        contentTableView.dataSource          = self;
        contentTableView.delegate            = self;
        contentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [contentTableView setBackgroundColor:[UIColor whiteColor]];
        contentTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
        contentTableView.tableFooterView = [UIView new];
        self.contentTableView = contentTableView;
        [self.leftView addSubview:contentTableView];
        
        //添加尾部
        width              = 90;
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - headerView.frame.size.height, self.leftView.frame.size.width, self.frame.size.height)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        
        [self.leftView addSubview:footerView];
        
        [self.leftView addSubview:self.close_btn];
        [self addSubview:self.leftView];
    }
    
    return self;
}

-(void)closeLeftView:(id)sender{
    [self removeFromSuperview];
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"LeftView%li",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];

    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:[UIColor grayColor]];

    cell.hidden = NO;
    switch (indexPath.row) {
        case 0:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"collection"]];
            [cell.textLabel setText:@"收集箱"];
        }
            break;
            
        case 1:
        {
            
            [cell.imageView setImage:[UIImage imageNamed:@"tag"]];
            [cell.textLabel setText:@"标签"];
        }
            break;
            
            
        case 2:
        {
            
            [cell.imageView setImage:[UIImage imageNamed:@"work"]];
            [cell.textLabel setText:@"工作"];
        }
            break;
            
        case 3:
        {
            
            [cell.imageView setImage:[UIImage imageNamed:@"study"]];
            [cell.textLabel setText:@"学习"];
        }
            break;
            
        case 4:{
            
            [cell.imageView setImage:[UIImage imageNamed:@"settings"]];
            [cell.textLabel setText:@"设置"];
        }
            break;
            
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:indexPath.row];
    }
    
}

@end
