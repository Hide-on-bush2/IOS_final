//
//  PlanListVC+_.m
//  final
//
//  Created by jinshlin on 2020/12/21.
//

#import "PlanListVC.h"
#import "RecordModel.h"
#import "DynamicCell.h"
#import "AddSimplePlanView.h"
#import "AddPlanVC.h"

#import "Masonry.h"

#import "TestData.h"

@interface PlanListVC ()<UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating,UITextFieldDelegate>
@property (nonatomic,strong) UITableView * tabelView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSMutableArray *filterDataSource;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, assign) bool isFiltering;

@property(strong, nonatomic) UIButton *checkbox;
@property(strong, nonatomic) UIButton *send;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * dateLabel;

@property (nonatomic,strong)AddSimplePlanView* AddView;

//选择是否展开，多个分组时用数组
//@property (nonatomic, strong) NSMutableArray *sectionTitleBtns;

@property (nonatomic, strong) UIButton *sectionTitleBtns;
@end

@implementation PlanListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"updateData" object:nil];
    //观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPlusPlan) name:@"addPlusPlan" object:nil];
    
    self.navigationItem.title = @"收集箱";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gengduo"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    //search
    if(self.searchController == nil){
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.obscuresBackgroundDuringPresentation = false;
        self.searchController.hidesNavigationBarDuringPresentation = false;
        //调整searchbar文字颜色为白色
        self.definesPresentationContext = true;
    }
    
    if(_tabelView == nil){
       // _tabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabelView = [[UITableView alloc]initWithFrame:CGRectZero];
        _tabelView.backgroundColor = [UIColor clearColor];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.tableHeaderView = self.searchController.searchBar;
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_tabelView addGestureRecognizer:longPress];
    
    if(self.send == nil){
        self.send = [[UIButton alloc] init];
        //半径
        self.send.layer.cornerRadius = 30;
        //裁边
        self.send.layer.masksToBounds = YES;
        [self.send setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.send addTarget:self action:@selector(Sendit:) forControlEvents:UIControlEventTouchUpInside];
    }

    [self.view addSubview:_tabelView];
    [self.view addSubview:self.send];
    [self showContent];
    
    [self.send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(310);
        make.top.equalTo(self.view).with.offset(680);
        
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
}
//初始化选择
- (UIButton *)sectionTitleBtns{
    if (!_sectionTitleBtns) {
        _sectionTitleBtns = [[UIButton alloc] init];
        [_sectionTitleBtns setSelected:YES];
    }
    return _sectionTitleBtns;
}


#pragma mark - 导航栏两侧
- (void)leftBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    
}
- (void)rightBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    
}


#pragma mark -添加计划
-(void)Sendit:(id)sender{
    _AddView = [[AddSimplePlanView alloc] init];
    [_AddView showAlert:self.view];
}
- (void)addPlusPlan{
    [_AddView dismissAlert];
    AddPlanVC *vc = [[AddPlanVC alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    [self customPresentWith:@"oglFlip" controller:vc];
}
- (void)customPresentWith:(NSString *)type
               controller:(UIViewController *)view{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = type;
    //可以改变subtype的类型
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:nav animated:YES completion:nil];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tabelView.frame = self.view.bounds;
}

#pragma mark - tableView Data
- (void)updateData{
    [self showContent];
    [_tabelView reloadData];
    //[self viewDidLoad];
    NSLog(@"updateData");
}

- (void)showContent{
    _dataArray = [NSMutableArray array];
    _filterDataSource = @[].mutableCopy;
    
    NSMutableArray *temp = [NSMutableArray array];
    for(id key in [[TestData singleInstance] detailWithNotCompleted]){
        RecordModel *model = [[RecordModel alloc]init];
        model.title = key[@"title"];
        model.date = key[@"date"];
        model.priority = key[@"priority"];
        model.isCompleted = key[@"isCompleted"];
        model.type = key[@"type"];
        model.tag = key[@"tag"];
        model.ID = key[@"ID"];
        
        [temp addObject:model];
    }
    [_dataArray addObject:temp];
    
    NSMutableArray *temp1 = [NSMutableArray array];
    for(id key in [[TestData singleInstance] detailWithCompleted]){
        RecordModel *model = [[RecordModel alloc]init];
        model.title = key[@"title"];
        model.date = key[@"date"];
        model.priority = key[@"priority"];
        model.isCompleted = key[@"isCompleted"];
        model.type = key[@"type"];
        model.tag = key[@"tag"];
        model.ID = key[@"ID"];
        
        [temp1 addObject:model];
    }
    [_dataArray addObject:temp1];
    //NSLog(@"Completed%@",[[TestData singleInstance] detailWithCompleted]);
    //NSLog(@"Not completed%@",[[TestData singleInstance] detailWithNotCompleted]);
    NSLog(@"%@",_dataArray);
    
    [_tabelView reloadData];
}

#pragma mark 一共有多少组（section == 区域\组）

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.isFiltering)
        return 1;
    else if([[TestData singleInstance] detailWithCompleted].count == 0)
        return 1;
    else
        return 2;
}

#pragma mark 第section组一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.isFiltering? self.filterDataSource.count : self.dataArray.count;
    if(self.isFiltering)
        return self.filterDataSource.count;
    else{
        if(section == 0){
            return [[TestData singleInstance] detailWithNotCompleted].count;
        }
        else if(section == 1){
            //return [[TestData singleInstance] detailWithCompleted].count;
            // 判断是否展开
            if (self.sectionTitleBtns.isSelected) {
                //RPCategoryModel *categoryModel = self.category[section];
                //return categoryModel.childs.count;
                return [[TestData singleInstance] detailWithCompleted].count;
            }
                return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark 返回每一行显示的内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DynamicCell * cell = [DynamicCell dynamicCellWithTable:tableView];
    
    if(self.isFiltering){
        cell.model = self.filterDataSource[indexPath.row];
    }
    else{
        cell.model = _dataArray[indexPath.section][indexPath.row];
    }
    //cell.layer.borderWidth = 1.0;
    //cell.layer.borderColor = [UIColor redColor].CGColor;
    //NSLog(@"cell %@", cell.model.ID);
    return cell;
}

#pragma mark 第section组显示的头部
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //if (section == 0) return @"未完成";
    if (section == 1)
        return @"已完成";
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0;
    else
        return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:234.0/255.0 blue:244.0/255.0 alpha:100];
    //将UIView设为可交互的：
    myView.userInteractionEnabled = YES;
    //添加tap手势
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTitleBtnClick:)];
    //给触发事件传参
    //[myView setTag:1];
    //默认为单击触发，也可通过以下方法设置双击，三击...
    [singleTap setNumberOfTapsRequired:1];
    //设置手指个数：
    [singleTap setNumberOfTouchesRequired:1];
    //将手势添加至UIView中
    [myView addGestureRecognizer:singleTap];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    //titleLabel.text=[self.keys objectAtIndex:section];
    if (section == 1)
        titleLabel.text =  @"已完成";
    //titleLabel.layer.borderWidth = 1.0;
    //titleLabel.layer.borderColor = [UIColor redColor].CGColor;
    //myView.layer.borderWidth = 1.0;
    //myView.layer.borderColor = [UIColor redColor].CGColor;
    [myView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myView).with.offset(20);
        make.top.equalTo(myView).with.offset(5);
    }];
    
    UILabel *number = [[UILabel alloc] init];
    number.textColor=[UIColor grayColor];
    number.backgroundColor = [UIColor clearColor];
    number.font = [UIFont systemFontOfSize:12];
    NSUInteger temp = [[TestData singleInstance] detailWithCompleted].count;
    if (section == 1)
        number.text = [[NSNumber numberWithInteger:temp]stringValue];
    //NSLog(@"number %@",number.text);
    //number.layer.borderWidth = 1.0;
    //number.layer.borderColor = [UIColor redColor].CGColor;
    [myView addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myView).with.offset(5);
        make.right.equalTo(myView).with.offset(-20);
    }];
    //[titleLabel release];
    return myView;
}

- (void)sectionTitleBtnClick:(UITapGestureRecognizer *)sender{
    // 修改组标题按钮的状态
    self.sectionTitleBtns.selected = !self.sectionTitleBtns.isSelected;
    // 刷新单独一组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [_tabelView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFiltering) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {


}

# pragma mark - cell移动
- (IBAction)longPressGestureRecognized:(id)sender {
 
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;

    CGPoint location = [longPress locationInView:self.tabelView];
    NSIndexPath *indexPath = [self.tabelView indexPathForRowAtPoint:location];
 
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
     
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
              sourceIndexPath = indexPath;

              UITableViewCell *cell = [self.tabelView cellForRowAtIndexPath:indexPath];
              // Take a snapshot of the selected row using helper method.
              snapshot = [self customSnapshotFromView:cell];

              // Add the snapshot as subview, centered at cell's center...
              __block CGPoint center = cell.center;
              snapshot.center = center;
              snapshot.alpha = 0.0;
              [self.tabelView addSubview:snapshot];
              [UIView animateWithDuration:0.25 animations:^{
                // Offset for gesture location.
                center.y = location.y;
                snapshot.center = center;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshot.alpha = 0.98;

                // Black out.
                cell.backgroundColor = [UIColor whiteColor];
              } completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;

            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... update data source.
                //[self.objects exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // ... move the rows.
                [self.tabelView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tabelView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;

                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {

            [snapshot removeFromSuperview];
            snapshot = nil;

            }];
            sourceIndexPath = nil;
            break;
        }
    }
}
    

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForSearchText:searchController.searchBar.text];
}

- (void)filterContentForSearchText:(NSString *)text {
    [self.filterDataSource removeAllObjects];
    for (RecordModel *model in self.dataArray) {
        if ([model.title containsString:text] ) {
            [self.filterDataSource addObject:model];
        }
    }
    [self.tabelView reloadData];
}

#pragma mark - Getter
- (bool)isFiltering {
    return self.searchController.isActive && !self.isSearchBarEmpty;
}

- (bool)isSearchBarEmpty {
    return self.searchController.searchBar.text.length == 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;

    return snapshot;
}
 
@end
