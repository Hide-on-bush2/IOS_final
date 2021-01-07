//
//  WorkPlanVC+_.m
//  final
//
//  Created by jinshlin on 2021/1/7.
//

#import "TagsVC.h"
#import "PlanListVC.h"
#import "RecordModel.h"
#import "DynamicCell.h"
#import "AddPlanVC.h"
#import "LeftNavView.h"
#import "TagsVC.h"
#import "WorkPlanVC.h"
#import "StudyPlanVC.h"
#import "SettingVC.h"
#import "Masonry.h"


@interface WorkPlanVC()
{
    LeftNavView *leftNav;

}
@end

@implementation WorkPlanVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"工作";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gengduo"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
}
#pragma mark -左导航栏
- (void)leftBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    //self.navigationController.navigationBar.hidden = YES;
    
    leftNav = [[LeftNavView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*0.85, self.view.bounds.size.height)];
    leftNav.customDelegate = self;
    [self.view addSubview:leftNav];
    
}

-(void)LeftMenuViewClick:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
            PlanListVC *vc = [[PlanListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            TagsVC *vc = [[TagsVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
           
        }
            break;
            
            
        case 2:
        {
            WorkPlanVC *vc = [[WorkPlanVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case 3:
        {
            StudyPlanVC *vc = [[StudyPlanVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
           
        }
            break;
            
        case 4:{
            SettingVC *vc = [[SettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
            
        default:
            break;
    }
}


@end
